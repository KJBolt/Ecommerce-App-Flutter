import 'package:flutter/material.dart';
import 'package:shop_app/pages/admin/admin_login.dart';
import 'package:shop_app/pages/admin/onboarding/shipping_onboard.dart';

class WelcomeOnboardPage extends StatefulWidget {
  const WelcomeOnboardPage({super.key});

  @override
  State<WelcomeOnboardPage> createState() => _WelcomeOnboardPageState();
}

class _WelcomeOnboardPageState extends State<WelcomeOnboardPage> {

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
                      return const AdminLoginPage();
                    }));
          },
        ),
      ),
      body: Container(
        color: Colors.blue[300],
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            height: 350,
            width: 340,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Hello!", textAlign: TextAlign.center,style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                const SizedBox(height: 5),

                const Text("Welcome to ShopShipPay", textAlign: TextAlign.center,style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500)),
                const SizedBox(height: 15),

                const Text("Lets guide you step by step on how to setup your shop",
                    textAlign: TextAlign.center,style: TextStyle(fontSize: 14, color: Colors.black54)
                ),
                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () {
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
                              return const ShippingOnboardPage();
                            }));
                  },
                  child: Container(
                    width: 150,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Continue", style: TextStyle(color: Colors.white)),
                        Icon(Icons.arrow_forward_rounded, color: Colors.white)
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      )




    );
  }
}