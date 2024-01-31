import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shop_app/pages/admin/admin_register.dart';
import 'package:shop_app/pages/admin/dashboard_new.dart';
import 'package:shop_app/pages/admin/onboarding/welcome_onboard.dart';
import 'package:shop_app/pages/login_page.dart';
import 'package:toastification/toastification.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shop_app/pages/home_page_new.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  // Form Key
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  bool _obscureText = true;

  // Input Controllers
  final _emailValue = TextEditingController();
  final _passwordValue = TextEditingController();

  // Success Toast Alerts
  void showSuccessToast(msg) {
    toastification.show(
        context: context,
        title: '$msg',
        autoCloseDuration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white);
  }

  // Error Toast Alerts
  void showErrorToast(msg) {
    toastification.show(
        context: context,
        title: '$msg',
        autoCloseDuration: const Duration(seconds: 2),
        backgroundColor: Colors.redAccent[200],
        foregroundColor: Colors.white);
  }

  // Redirect to HomePage Function
  void redirectHomePage() {
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: const HomePageNew(),
      withNavBar: false,
    );
  }
   void redirectWelcomePage() {
     PersistentNavBarNavigator.pushNewScreen(
       context,
       screen: const WelcomeOnboardPage(),
       withNavBar: false,
     );
  }

  //save token to localstorage
  Future<void> saveTokenToLocal(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  Future<void> saveShopNameToLocal(String name) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('shop_name', name);
  }

  //save AdminId to localstorage
  Future<void> saveAdminIdToLocal(int id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('admin_id', id);
  }

  //save ShopID to localstorage
  Future<void> saveShopIdToLocal(int id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('shop_id', id);
  }

  // Make Api Request to server
  Future<void> loginUser() async {
    // Map<String, String> headers = {
    //   'Content-Type': 'application/json',
    // };
    setState(() {
      loading = true;
    });
    Map<String, dynamic> bodyData = {
      'email': _emailValue.text,
      'password': _passwordValue.text,
    };
    final apiEndpoint = dotenv.env['API_KEY'];
    final uri = Uri.parse("${apiEndpoint}/login");
    try {
      // Response
      final response = await http.post(
        uri,
        body: bodyData,
      );

      final data = jsonDecode(response.body);
      // print(data);
      if (data['status'] == 200) {
        setState(() {
          loading = false;
        });

        // Clear Input values
        _emailValue.clear();
        _passwordValue.clear();

        // Save data to local storage
        saveTokenToLocal(data['access_token']);
        // saveIdToLocal(data['user']['id']);
        saveAdminIdToLocal(data['user']['is_admin']);
        saveShopNameToLocal(data['user']['shop'][0]['shop_name']);
        saveShopIdToLocal(data['user']['shop'][0]['id']);

        showSuccessToast('Login Successfully');
        print("User is_board => ${data['user']['is_board']}");
        if(data['user']['is_board'] != 1){
          Future.delayed(const Duration(milliseconds: 3000), redirectWelcomePage);
        } else {
          Future.delayed(const Duration(milliseconds: 3000), redirectHomePage);
        }
      } else {
        showErrorToast("Invalid Credentials.");
        setState(() {
          loading = false;
        });
      }
    } catch (error) {
      print(error);
      showErrorToast("Login failed. Try Again");
      setState(() {
        loading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF545D68)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body:  ListView(
          scrollDirection: Axis.vertical,
          children: [
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text("Sign In",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF7386EF),
                                  fontWeight: FontWeight.w500)),
                          SizedBox(height: 10),
                          Text("Welcome back Shop Owner",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF7386EF),
                                  fontWeight: FontWeight.w400))
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                    child: Column(
                      children: [
                        // Input Fields
                        Form(
                            key: _formkey,
                            child: Column(
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("Email Address",
                                        style: TextStyle(fontSize: 15),
                                        textAlign: TextAlign.start),
                                  ],
                                ),
                                Container(
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 8),
                                      // Email Input
                                      TextFormField(
                                        controller: _emailValue,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Email Address is required';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          border: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.black),
                                              borderRadius:
                                              BorderRadius.circular(30)),
                                        ),
                                      ),
                                      const SizedBox(height: 20),

                                      // Password Input
                                      const Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Text("Password",
                                              style: TextStyle(fontSize: 15),
                                              textAlign: TextAlign.start),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        obscureText: _obscureText,
                                        controller: _passwordValue,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your password';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.all(10),
                                            suffixIcon: GestureDetector(
                                              onTap: (){
                                                setState(() {
                                                  _obscureText = !_obscureText;
                                                });

                                              },
                                              child: Icon(
                                                _obscureText ? Icons.visibility_off : Icons.visibility
                                                ),
                                            ),

                                            border: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.black),
                                                borderRadius:
                                                BorderRadius.circular(30))),
                                      ),
                                      const SizedBox(height: 10),

                                      // Not a user
                                      Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                                padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        // MaterialPageRoute(builder: (context) => const ProductDetails()),
                                                        PageRouteBuilder(
                                                            transitionDuration: const Duration(milliseconds: 400),
                                                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                              const begin = Offset(-1.0, 0.0); // Start off the screen to the left
                                                              const end = Offset.zero;
                                                              var tween = Tween(begin: begin, end: end);
                                                              var offsetAnimation = animation.drive(tween);

                                                              return SlideTransition(
                                                                position: offsetAnimation,
                                                                child: FadeTransition(
                                                                  opacity: animation,
                                                                  child: child,
                                                                ),
                                                              );
                                                            },
                                                            pageBuilder: (context, animation, secondaryAnimation) {
                                                              return const AdminRegisterPage();
                                                            }
                                                        )
                                                    );
                                                  },
                                                  child: const Text(
                                                    "Not a user?",
                                                    style: TextStyle(
                                                    fontSize: 15,
                                                    color: Color(0xFF7386EF),
                                                    ),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ))
                                          ]),
                                    ],
                                  ),
                                ),
                              ],
                            )),

                        // Sign In Button
                        const SizedBox(height: 40),
                        GestureDetector(
                          onTap: () {
                            if (_formkey.currentState!.validate()) {
                              loginUser();
                            } else {
                              print("Not validated");
                            }
                          },
                          child: Container(
                            width: screenWidth,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: const Color(0xFF7386EF)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                loading == true ? const Center(child: CircularProgressIndicator(color: Colors.white)) :
                                const Text("Sign In",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 13)
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                      ],
                    ))
              ],
            ),
          ],
        )

    );
  }
}
