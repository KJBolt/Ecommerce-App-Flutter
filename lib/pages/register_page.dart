import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:shop_app/pages/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  // Form Key
  final _formkey = GlobalKey<FormState>();

  // Input Controllers
  final _emailValue = TextEditingController();
  final _fullnameValue = TextEditingController();
  final _passwordValue = TextEditingController();

  // Success Toast Alerts
  void showSuccessToast(msg) {
    toastification.show(
      context: context,
      title: '$msg',
      autoCloseDuration: const Duration(seconds: 2),
      backgroundColor: Colors.green,
      foregroundColor: Colors.white
    );
  }

  // Error Toast Alerts
  void showErrorToast(msg) {
    toastification.show(
      context: context,
      title: '$msg',
      autoCloseDuration: const Duration(seconds: 2),
        backgroundColor: Colors.redAccent[200],
        foregroundColor: Colors.white
    );
  }

  // Redirect to HomePage Function
  void redirectLoginPage() {
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
              return const RegisterPage();
            }
        )
    );
  }

  // Make Api Request to server
  Future<void> registerUser() async{
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> bodyData = {
      'name': _fullnameValue.text,
      'email': _emailValue.text,
      'password': _passwordValue.text,
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
      print(data['message']);
      if (data['message'].toString() == "Successfully registered.") {
        // Clear Input values
        _emailValue.clear();
        _fullnameValue.clear();
        _passwordValue.clear();

        showSuccessToast(data['message']);
        Future.delayed(const Duration(milliseconds: 3000), redirectLoginPage);
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
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF545D68)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body:
          ListView(
            scrollDirection: Axis.vertical,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 250,
                    child: const Image(image: AssetImage('images/signin.jpg'), fit: BoxFit.cover,),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formkey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            const Text("Sign Up", textAlign: TextAlign.start, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 10,),
                            TextFormField(
                              controller: _emailValue,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a valid email address';
                                }
                                final bool emailValid =
                                RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value);
                                if (!emailValid) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.email_rounded),
                                  hintText: 'Email Address',
                                  border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black))
                              ),
                            ),

                            const SizedBox(height: 22),
                             TextFormField(
                               controller: _fullnameValue,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your full name';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  hintText: 'Full Name',
                                  border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black))
                              ),
                            ),

                            const SizedBox(height: 22),
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
                                  border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black))
                              ),
                            ),

                            const SizedBox(height: 22),

                            GestureDetector(
                              onTap: () {
                                if (_formkey.currentState!.validate()) {
                                  registerUser();
                                } else {
                                  print("Not validated");
                                }
                              },
                              child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(20)),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                          onPressed: null,
                                          child: Text("Continue", style: TextStyle(color: Colors.white),)
                                      )
                                    ],
                                  )
                              ),
                            ),

                            // Not a user button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                              return const LoginPage();
                                            }));
                                  },
                                  child: const Text("Already a user?", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400)),
                                ),
                              ],
                            ),

                          ]
                      ),
                    )

                  )

                ],
              ),
            ],
          )


    );
  }
}