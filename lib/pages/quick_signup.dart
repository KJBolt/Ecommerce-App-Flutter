import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shop_app/pages/quick_email.dart';
import 'package:shop_app/pages/register_page.dart';
import 'package:shop_app/pages/quick_login.dart';
import 'package:shop_app/pages/shipping_form.dart';
import 'package:toastification/toastification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuickSignupPage extends StatefulWidget {
  dynamic emailAddress;
  final int id;
  QuickSignupPage({super.key, required this.emailAddress, required this.id});

  @override
  State<QuickSignupPage> createState() => _QuickSignupPageState();
}

class _QuickSignupPageState extends State<QuickSignupPage> {
  String loggedIn = 'false';
  final _formkey = GlobalKey<FormState>();
  final _nameValue = TextEditingController();
  final _passwordValue = TextEditingController();
  bool _obscureText = true;

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

  //save name to localstorage
  Future<void> saveIdToLocal(int id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', id);
  }

  // Redirect to HomePage Function
  redirectShippingFormPage(var name, var email) {
    Navigator.push(
        context,
        // MaterialPageRoute(builder: (context) => const ProductDetails()),
        PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(-1.0, 0.0);
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
              return ShippingFormPage(username: name, useremail: email);
            }));
  }

  // Make Api Request to server
  Future<void> registerUser() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> bodyData = {
      'name': _nameValue.text,
      'email': widget.emailAddress,
      'password': _passwordValue.text,
      'name': _nameValue.text,
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
      print("Response => ${data}");
      if (data['status'] == 201) {
        // Clear Input values
        _nameValue.clear();
        _passwordValue.clear();
        saveTokenToLocal(data['access_token']);
        saveNameToLocal(data['user']['name']);
        saveEmailToLocal(data['user']['email']);
        saveIdToLocal(data['user']['id']);
        String username = data['user']['name'];
        String useremail = data['user']['email'];
        showSuccessToast('Login Successfully');
        Future.delayed(const Duration(milliseconds: 3000),
            redirectShippingFormPage(username, useremail));
      } else {
        showErrorToast("Email has already been taken.");
      }
    } catch (error) {
      showErrorToast("Registration failed. Try Again");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF545D68)),
            onPressed: () {
              Navigator.push(
                  context,
                  // MaterialPageRoute(builder: (context) => const ProductDetails()),
                  PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 400),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(
                            -1.0, 0.0); // Start off the screen to the left
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
                        return QuickEmailPage(prodId: widget.id,);
                      }));
            },
          ),
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            height: 430,
            width: 320,
            child: Column(
              children: <Widget>[
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Login or Signup',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      width: 280,
                      child: const Text(
                          'Sign up to shop your favourite stores, speed through checkouts, and track your orders'),
                    )
                  ],
                ),
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            // Name Field
                            TextFormField(
                              controller: _nameValue,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  hintText: 'Full Name',
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black))),
                            ),
                            const SizedBox(height: 10),

                            // Password Input
                            TextFormField(
                              controller: _passwordValue,
                              obscureText: _obscureText,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  hintText: 'Password',
                                  border: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)
                                  ),
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
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),

                      // Not a user
                      const SizedBox(
                        height: 10,
                      ),

                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.push(
                      //         context,
                      //         // MaterialPageRoute(builder: (context) => const ProductDetails()),
                      //         PageRouteBuilder(
                      //             transitionDuration: const Duration(milliseconds: 400),
                      //             transitionsBuilder:
                      //                 (context, animation, secondaryAnimation, child) {
                      //               const begin = Offset(-1.0, 0.0);
                      //               const end = Offset.zero;
                      //               var tween = Tween(begin: begin, end: end);
                      //               var offsetAnimation = animation.drive(tween);
                      //
                      //               return SlideTransition(
                      //                 position: offsetAnimation,
                      //                 child: FadeTransition(
                      //                   opacity: animation,
                      //                   child: child,
                      //                 ),
                      //               );
                      //             },
                      //             pageBuilder: (context, animation, secondaryAnimation) {
                      //               return const QuickLoginPage();
                      //             }));
                      //   },
                      //   child: const Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Text("Already a user?", style: TextStyle(color: Colors.blueAccent),)
                      //     ],
                      //   ),
                      // ),
                      // Continue Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (_formkey.currentState!.validate()) {
                                registerUser();
                              } else {
                                print("Search field cannot be empty");
                              }
                            },
                            child: Container(
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20),
                                decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Continue',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.white)),
                                  ],
                                )),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
