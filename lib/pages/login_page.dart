import 'package:flutter/material.dart';
import 'package:shop_app/components/home_comp.dart';
import 'package:shop_app/components/homecompnew_page.dart';
import 'package:shop_app/pages/admin/admin_login.dart';
import 'package:shop_app/pages/register_page.dart';
import 'package:toastification/toastification.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/database/db_helper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Form Key
  final _formkey = GlobalKey<FormState>();

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
              return const HomeCompNewPage();
            }));
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

  // Make Api Request to server
  Future<void> loginUser() async {
    // Map<String, String> headers = {
    //   'Content-Type': 'application/json',
    // };
      
    Map<String, dynamic> bodyData = {
      'email': _emailValue.text,
      'password': _passwordValue.text,
    };
    final apiEndpoint = dotenv.env['API_KEY'];
    final uri = Uri.parse(
        "${apiEndpoint}/login");
    try {
      // Response
      final response = await http.post(
        uri,
        body: bodyData,
      );
      final data = jsonDecode(response.body);
      print("Response => ${data}");
      if (data['status'] == 200) {
        // Clear Input values
        _emailValue.clear();
        _passwordValue.clear();
    
        saveTokenToLocal(data['access_token']);
        saveNameToLocal(data['user']['name']);
        saveEmailToLocal(data['user']['email']);
        saveIdToLocal(data['user']['id']);
        showSuccessToast('Login Successfully');
        Future.delayed(const Duration(milliseconds: 3000), redirectHomePage);
      } else {
        showErrorToast("Invalid Credentials.");
      }
    } catch (error) {
      showErrorToast("Login failed. Try Again");
    }
  }

  @override
  Widget build(BuildContext context) {
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(

                  height: 250,
                  child: Image(
                    image: AssetImage('images/login.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formkey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 25,
                            ),
                            const Text("Login",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w600)),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _emailValue,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a valid email address';
                                }
                                final bool emailValid = RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value);
                                if (!emailValid) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.email_rounded),
                                  hintText: 'Email Address',
                                  border: UnderlineInputBorder(borderSide:BorderSide(color: Colors.black))
                              ),
                            ),
                            const SizedBox(height: 25),
                            TextFormField(
                              controller: _passwordValue,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.lock),
                                  hintText: 'Password',
                                  border: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black))),
                            ),

                            const SizedBox(height: 18),

                            // Not a user button
                             Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        // MaterialPageRoute(builder: (context) => const ProductDetails()),
                                        PageRouteBuilder(
                                            transitionDuration: const Duration(
                                                milliseconds: 400),
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              const begin = Offset(-1.0,
                                                  0.0); // Start off the screen to the left
                                              const end = Offset.zero;
                                              var tween =
                                              Tween(begin: begin, end: end);
                                              var offsetAnimation =
                                              animation.drive(tween);

                                              return SlideTransition(
                                                position: offsetAnimation,
                                                child: FadeTransition(
                                                  opacity: animation,
                                                  child: child,
                                                ),
                                              );
                                            },
                                            pageBuilder: (context, animation,
                                                secondaryAnimation) {
                                              return const RegisterPage();
                                            }));
                                  },
                                  child: const Text("Not a user?", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400)),
                                ),
                              ],
                            ),


                            GestureDetector(
                              onTap: () {
                                if (_formkey.currentState!.validate()) {
                                  loginUser();
                                } else {
                                  print("Not validated");
                                }
                              },
                              child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                          onPressed: null,
                                          child: Text(
                                            "Login",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ))
                                    ],
                                  )),
                            ),

                            TextButton(
                                onPressed: (){
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
                                            return const AdminLoginPage();
                                          }));
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 25),
                                    Text("Shop Owner?",
                                      style: TextStyle(color: Colors.black, fontSize: 15),
                                    )
                                  ],
                                )

                            )
                          ]),
                    ))
              ],
            ),
          ],
        )
    );
  }
}
