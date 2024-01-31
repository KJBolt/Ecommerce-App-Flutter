import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shop_app/pages/admin/admin_login.dart';
import 'package:shop_app/pages/admin/onboarding/welcome_onboard.dart';
// import 'package:shop_app/pages/login_page.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class AdminRegisterPage extends StatefulWidget {
  const AdminRegisterPage({super.key});

  @override
  State<AdminRegisterPage> createState() => _AdminRegisterPageState();
}

class _AdminRegisterPageState extends State<AdminRegisterPage> {
  // Form Key
  final _formkey = GlobalKey<FormState>();
  bool _obscureText = true;

  // Input Controllers
  final _fullnameValue = TextEditingController();
  final _emailValue = TextEditingController();
  final _shopValue = TextEditingController();
  final _passwordValue = TextEditingController();
  bool loading = false;

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
  void redirectOnboardPage() {
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

  //Shop name
  Future<void> saveShopNAmeToLocal(String name) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('shop_name', name);
  }

  //save ShopID to localstorage
  Future<void> saveShopIdToLocal(int id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('shop_id', id);
  }
    //save name to localstorage
  Future<void> saveIdToLocal(int id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('admin_id', id);
  }

  // Make Api Request to server
  Future<void> registerUser() async{
    setState(() {
      loading = true;
    });
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> bodyData = {
      'name': _fullnameValue.text,
      'email': _emailValue.text,
      'password': _passwordValue.text,
      'shop_name': _shopValue.text
    };
    final apiEndpoint = dotenv.env['API_KEY'];
    final uri = Uri.parse("${apiEndpoint}/register");
    try {
      // Response
      final response = await http.post(
        uri,
        body: bodyData,
      );
      final data = jsonDecode(response.body);
      // print(data['message']['is_admin']);
      if (data['status'] == 201) {
        setState(() {
          loading = false;
        });
        // Clear Input values
        _emailValue.clear();
        _fullnameValue.clear();
        _passwordValue.clear();
        _shopValue.clear();

        saveTokenToLocal(data['access_token']);
        saveIdToLocal(data['user']['id']);
        saveShopNAmeToLocal(data['shop_name']);
        saveShopIdToLocal(data['shop_id']);

        showSuccessToast(data['message']);
        Future.delayed(const Duration(milliseconds: 3000), redirectOnboardPage);
      } else {
        showErrorToast("Email has already been taken.");
        setState(() {
          loading = false;
        });
      }
    } catch (error) {
      showErrorToast("Registration failed. Try Again");
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
        body: ListView(
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
                          Text("Create an Account", style: TextStyle(fontSize: 20, color: Color(0xFF7386EF), fontWeight: FontWeight.w500)),
                          SizedBox(height: 10),
                          Text("Hi welcome back", style: TextStyle(fontSize: 15, color: Color(0xFF7386EF), fontWeight: FontWeight.w400))
                        ],
                      )

                    ],
                  ),
                ),

                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                                    Text("Name",
                                        style: TextStyle(fontSize: 15),
                                        textAlign: TextAlign.start
                                    ),
                                  ],
                                ),
                                Container(
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 8),
                                      // Name Input
                                      TextFormField(
                                        controller: _fullnameValue,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Name is required';
                                          }
                                          return null;
                                        },
                                        decoration:  InputDecoration(
                                          contentPadding: const EdgeInsets.all(10),
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(color: Colors.black),
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                        ),

                                      ),
                                      const SizedBox(height: 10),

                                      // Email Address Input
                                      const Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text("Email Address",
                                              style: TextStyle(fontSize: 15),
                                              textAlign: TextAlign.start
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: _emailValue,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a valid email address';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.all(10),
                                            border: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Colors.black),
                                                borderRadius: BorderRadius.circular(30)
                                            )
                                        ),
                                      ),
                                      const SizedBox(height: 10),

                                      // Shop Name Input
                                      const Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text("Shop Name",
                                              style: TextStyle(fontSize: 15),
                                              textAlign: TextAlign.start
                                          ),
                                        ],
                                      ),
                                      // Password Input
                                      const SizedBox(height: 8),
                                      TextFormField(
                                        controller: _shopValue,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a shop name';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.all(10),
                                            border: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Colors.black),
                                                borderRadius: BorderRadius.circular(30)
                                            )
                                        ),
                                      ),
                                      const SizedBox(height: 10),


                                      const Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text("Password",
                                              style: TextStyle(fontSize: 15),
                                              textAlign: TextAlign.start
                                          ),
                                        ],
                                      ),
                                      // Password Input
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
                                                borderSide: const BorderSide(color: Colors.black),
                                                borderRadius: BorderRadius.circular(30)
                                            )
                                        ),
                                      ),
                                      const SizedBox(height: 10),


                                      // const Row(
                                      //   mainAxisAlignment: MainAxisAlignment.start,
                                      //   children: [
                                      //     Text("Repeat Password",
                                      //         style: TextStyle(fontSize: 15),
                                      //         textAlign: TextAlign.start
                                      //     ),
                                      //   ],
                                      // ),
                                      // // Password Input
                                      // const SizedBox(height: 8),
                                      // TextFormField(
                                      //   // controller: _passwordValue,
                                      //   validator: (value) {
                                      //     if (value == null || value.isEmpty) {
                                      //       return 'Please enter your password';
                                      //     }
                                      //     return null;
                                      //   },
                                      //   decoration: InputDecoration(
                                      //       contentPadding: const EdgeInsets.all(10),
                                      //       border: OutlineInputBorder(
                                      //           borderSide: const BorderSide(color: Colors.black),
                                      //           borderRadius: BorderRadius.circular(30)
                                      //       )
                                      //   ),
                                      // ),
                                      // const SizedBox(height: 10),

                                      // Forgot password
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    // Navigate to CreatePage
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => const AdminLoginPage()),
                                                    );
                                                  },
                                                  child: const Text("Already a user?",
                                                    style: TextStyle(fontSize: 15, color: Color(0xFF7386EF), decoration: TextDecoration.underline),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                )
                                            )

                                          ]
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                        ),

                        // Sign In Button
                        const SizedBox(height: 25),
                        GestureDetector(
                          onTap: () {
                            if (_formkey.currentState!.validate()) {
                              registerUser();
                            } else {
                              print("Not validated");
                            }
                          },
                          child:  Container(
                            width: screenWidth,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: const Color(0xFF7386EF)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                loading == true ? const Center(child: CircularProgressIndicator(color: Colors.white)) :
                                const Text("Register",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white,
                                        fontSize: 13)
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),



                      ],
                    )
                )
              ],
            )
          ],
        ),



    );
  }
}
