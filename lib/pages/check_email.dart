import 'package:flutter/material.dart';
import 'package:shop_app/pages/confirm_password.dart';

class CheckEmailPage extends StatefulWidget {
  const CheckEmailPage({super.key});

  @override
  State<CheckEmailPage> createState() => _CheckEmailPageState();
}

class _CheckEmailPageState extends State<CheckEmailPage> {

  // Redirect to HomePage Function
  void redirectConfirmPasswordPage() {
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
              return const ConfirmPasswordPage();
            }
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;


    return Scaffold(
      body: Center(
        child: Container(
          height: screenHeight * 0.6,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  height: 100,
                  width: 80,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('images/mail.png'))),
                ),

                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: const Text("Check your mail",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: const Text("We have sent a password recover \n instructions to your email",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),


                GestureDetector(
                  onTap:() {
                    redirectConfirmPasswordPage();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    width: 200,
                    decoration: BoxDecoration(
                        color: const Color(0xFFED294D),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: const Center(child: Text("Proceed",
                        style: TextStyle(color: Colors.white, fontSize: 18))),
                  ),
                )
              ],
            )
        ),
      ),


    );
  }
}