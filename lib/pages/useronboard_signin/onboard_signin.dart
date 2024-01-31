import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shop_app/pages/home_page_new.dart';
import 'package:shop_app/pages/reset_password.dart';
import 'package:shop_app/pages/useronboard_signin/onboard_createaccount.dart';
import 'package:toastification/toastification.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shop_app/pages/admin/admin_login.dart';

class OnboardSignInPage extends StatefulWidget {
  const OnboardSignInPage({super.key});

  @override
  State<OnboardSignInPage> createState() => _OnboardSignInPageState();
}

class _OnboardSignInPageState extends State<OnboardSignInPage> {
  final _formkey = GlobalKey<FormState>();
  bool _obscureText = true;

  // Input Controllers
  final _emailValue = TextEditingController();
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
  void redirectHomePage() {
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: const HomePageNew(),
      withNavBar: false,
    );
  }

  //save token to localstorage
  Future<void> saveTokenToLocal(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  //save email to localstorage
  Future<void> saveEmailToLocal(String email) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
  }

  //save name to localstorage
  Future<void> saveNameToLocal(String name) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);
  }

  //save id to localstorage
  Future<void> saveIdToLocal(int id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', id);
  }

  //save onboard to localstorage
  Future<void> saveUserOnboardToLocal(String onboard) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user_onboard', onboard);
  }

  // Make Api Request to server
  Future<void> loginUser() async {
    setState(() {
      loading = true;
    });
    // Map<String, String> headers = {
    //   'Content-Type': 'application/json',
    // };
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
      print('Response from Onboard SignIn => ${data}');


      if (data['status'] == 200) {
        if (data['user']['is_admin'] == 1) {

          // Clear Input values
          _emailValue.clear();
          _passwordValue.clear();

          setState(() {
            loading = false;
          });
          showErrorToast('User not found');

        } else {
          setState(() {
            loading = false;
          });
          // Clear Input values
          _emailValue.clear();
          _passwordValue.clear();

          saveTokenToLocal(data['access_token']);
          saveNameToLocal(data['user']['name']);
          saveEmailToLocal(data['user']['email']);
          saveIdToLocal(data['user']['id']);
          saveUserOnboardToLocal("1");
          showSuccessToast('Login Successfully');
          Future.delayed(const Duration(milliseconds: 3000), redirectHomePage);
        }

      } else {
        showErrorToast("Invalid Credentials.");
        setState(() {
          loading = false;
        });
      }
    } catch (error) {
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
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              saveUserOnboardToLocal("1");
              Navigator.push(
                  context,
                  // MaterialPageRoute(builder: (context) => const ProductDetails()),
                  PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 400),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = 0.0;
                        const end = 1.0;
                        const curve = Curves.easeInOut;
                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                        var opacityAnimation = animation.drive(tween);
                        var scaleAnimation = animation.drive(Tween(begin: 0.5, end: 1.0).chain(CurveTween(curve: curve)));
                        return FadeTransition(
                          opacity: opacityAnimation,
                          child: Transform.scale(
                            scale: scaleAnimation.value,
                            child: child,
                          ),
                        );
                      },
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const HomePageNew();
                      }));
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text("Skip", style: TextStyle(color: Color(0xFFED294D), fontSize: 17)),
            ),
          )
        ],
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Column(
            children: [
              Container(
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text("Sign In",
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFFED294D),
                                fontWeight: FontWeight.w500)),
                        SizedBox(height: 10),
                        Text("Hi welcome back",
                            style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFFED294D),
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

                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text("Password",
                                            style: TextStyle(fontSize: 15),
                                            textAlign: TextAlign.start),
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
                                              borderSide: const BorderSide(
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(30))),
                                    ),
                                    const SizedBox(height: 10),

                                    // Forgot password
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: GestureDetector(
                                                onTap: () {
                                                  // Navigate to CreatePage
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const OnboardCreateAccount()),
                                                  );
                                                },
                                                child: const Text(
                                                  "Create account",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                              )),
                                          Padding(
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: GestureDetector(
                                                onTap: () {
                                                  // Navigate to CreatePage
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                        const ResetPasswordPage()),
                                                  );
                                                },
                                                child: const Text(
                                                  "Forgot Password?",
                                                  style: TextStyle(
                                                    fontSize: 15,
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
                              color: const Color(0xFFED294D)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              loading == true ? const Center(child: CircularProgressIndicator(color: Colors.white)) :
                              const Text("Sign In",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15)
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),


                      // Shop Owner
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: (){
                                Navigator.push(
                                    context,
                                    // MaterialPageRoute(builder: (context) => const ProductDetails()),
                                    PageRouteBuilder(
                                        transitionDuration: const Duration(milliseconds: 400),
                                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                          const begin = 0.0;
                                          const end = 1.0;
                                          const curve = Curves.easeInOut;
                                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                          var opacityAnimation = animation.drive(tween);
                                          var scaleAnimation = animation.drive(Tween(begin: 0.5, end: 1.0).chain(CurveTween(curve: curve)));
                                          return FadeTransition(
                                            opacity: opacityAnimation,
                                            child: Transform.scale(
                                              scale: scaleAnimation.value,
                                              child: child,
                                            ),
                                          );
                                        },
                                        pageBuilder: (context, animation, secondaryAnimation) {
                                          return const AdminLoginPage();
                                        }));
                              },
                              child: const Text("Shop Owner?", style: TextStyle(color: Color(0xFFED294D), fontSize: 15))
                          )
                        ],
                      ),
                      const SizedBox(height: 20),

                      // or icon
                      // Container(
                      //   width: screenWidth,
                      //   height: 50,
                      //   decoration: const BoxDecoration(
                      //       image: DecorationImage(
                      //           image: AssetImage('images/signinwith.png'))),
                      // ),
                      // const SizedBox(height: 20),

                      // Social Media Icons
                      // Container(
                      //   child: const Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Padding(
                      //         padding: EdgeInsets.symmetric(horizontal: 10),
                      //         child:
                      //             Image(image: AssetImage('images/apple.png')),
                      //       ),
                      //       Padding(
                      //         padding: EdgeInsets.symmetric(horizontal: 10),
                      //         child:
                      //             Image(image: AssetImage('images/google.png')),
                      //       ),
                      //       Padding(
                      //         padding: EdgeInsets.symmetric(horizontal: 10),
                      //         child: Image(
                      //             image: AssetImage('images/facebook.png')),
                      //       ),
                      //     ],
                      //   ),
                      // )
                    ],
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
