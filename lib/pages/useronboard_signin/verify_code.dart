import 'package:flutter/material.dart';
import 'package:shop_app/pages/useronboard_signin/new_password.dart';

class VerifyCodePage extends StatefulWidget {
  const VerifyCodePage({super.key});

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final _formkey = GlobalKey<FormState>();

  // Input Controllers
  final _firstValue = TextEditingController();
  final _secondValue = TextEditingController();
  final _thirdValue = TextEditingController();
  final _fourthValue = TextEditingController();

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
      ),
      body:  Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Column(
              children: [
                const Text("Verify Code", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                const Text("Please enter the code we sent to mail \ngazaonthedect@gmail.com", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),

                const SizedBox(height: 40),
                Form(
                  key: _formkey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: screenHeight * 0.08,
                        margin: const EdgeInsets.only(right: 10),
                        child: TextFormField(
                          controller: _firstValue,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Field is required';
                            }
                            return null;
                          },
                          decoration:  InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 25),
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                            ),
                          ),

                        ),
                      ),

                      Container(
                        width: screenHeight * 0.08,
                        margin: const EdgeInsets.only(right: 10),
                        child: TextFormField(
                          controller: _secondValue,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Field is required';
                            }
                            return null;
                          },
                          decoration:  InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 25),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),

                        ),
                      ),

                      Container(
                        width: screenHeight * 0.08,
                        margin: const EdgeInsets.only(right: 10),
                        child: TextFormField(
                          controller: _thirdValue,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Field is required';
                            }
                            return null;
                          },
                          decoration:  InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 25),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),

                        ),
                      ),

                      Container(
                        width: screenHeight * 0.08,
                        margin: const EdgeInsets.only(right: 10),
                        child: TextFormField(
                          controller: _fourthValue,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Field is required';
                            }
                            return null;
                          },
                          decoration:  InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 25),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),

                        ),
                      ),

                    ],
                  ),
                ),

                const SizedBox(height: 30),
                const Column(children: [
                  Text("Didn't receive OTP?"),
                  Text("Resend Code")
                ]),


                // Sign In Button
                const SizedBox(height: 20),
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
                              return const NewPasswordPage();
                            }));
                  },
                  child:  Container(
                    width: screenWidth * 0.8,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color(0xFFED294D)
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Verify", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 13))
                      ],
                    ),
                  ),
                ),
              ],
            )

          ],
        ),
      ),

    );
  }
}