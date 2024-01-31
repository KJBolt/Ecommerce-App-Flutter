import 'package:flutter/material.dart';
import 'package:shop_app/pages/useronboard_signin/onboard_createshop.dart';
import 'package:shop_app/pages/useronboard_signin/onboard_signin.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:toastification/toastification.dart';
import 'dart:convert';

class OnboardCreateAccount extends StatefulWidget {
  const OnboardCreateAccount({super.key});

  @override
  State<OnboardCreateAccount> createState() => _OnboardCreateAccountState();
}

class _OnboardCreateAccountState extends State<OnboardCreateAccount> {

  final _formkey = GlobalKey<FormState>();
  bool _obscureText = true;

  // Input Controllers
  final _emailValue = TextEditingController();
  final _fullnameValue = TextEditingController();
  final _passwordValue = TextEditingController();
  bool loading = false;

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
              return const OnboardSignInPage();
            }
        )
    );
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
        setState(() {
          loading = false;
        });
        // Clear Input values
        _emailValue.clear();
        _fullnameValue.clear();
        _passwordValue.clear();

        showSuccessToast(data['message']);
        Future.delayed(const Duration(milliseconds: 3000), redirectLoginPage);
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
    double screenHeight = MediaQuery.of(context).size.height;

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
        actions: <Widget>[
          GestureDetector(
            onTap: () {
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
                        return const OnboardCreateShop();
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
                        Text("Create an Account", style: TextStyle(fontSize: 20, color: Color(0xFFED294D), fontWeight: FontWeight.w500)),
                        SizedBox(height: 10),
                        Text("Hi welcome back", style: TextStyle(fontSize: 15, color: Color(0xFFED294D), fontWeight: FontWeight.w400))
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


                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text("Email Address",
                                            style: TextStyle(fontSize: 15),
                                            textAlign: TextAlign.start
                                        ),
                                      ],
                                    ),
                                    // Password Input
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: _emailValue,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your password';
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
                                              MaterialPageRoute(builder: (context) => const OnboardSignInPage()),
                                            );
                                          },
                                          child: const Text("SignIn",
                                            style: TextStyle(fontSize: 15, color: Color(0xFFED294D), decoration: TextDecoration.underline),
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
                              color: const Color(0xFFED294D)
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

                      // or icon
                      Container(
                        width: screenWidth,
                        height: 50,
                        decoration: const BoxDecoration(
                            image: DecorationImage(image: AssetImage('images/signinwith.png'))
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Social Media Icons
                      Container(
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Image(image: AssetImage('images/apple.png')),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Image(image: AssetImage('images/google.png')),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Image(image: AssetImage('images/facebook.png')),
                            ),
                          ],
                        ),
                      )

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