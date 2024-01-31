import 'package:flutter/material.dart';
import 'package:shop_app/pages/buyerorseller_page.dart';
import 'package:shop_app/pages/notification_page.dart';
import 'package:shop_app/pages/useronboard_signin/onboard_signin.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        color: const Color(0xFFF4DFE2),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                                return const NotificationPage();
                              }));
                    },
                    child: Container(
                      child: const Text("Skip", style: TextStyle(color: Color(0xFFED294D), fontWeight: FontWeight.w500)),
                    ),
                  )

                ],
              ),

              Container(
                margin: const EdgeInsets.only(top: 50),
                width: screenWidth,
                child: const Text(
                    "Get all your online\n shopping in one place",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFFED294D),fontSize: 25, fontWeight: FontWeight.w500),
                ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 20),
                width: screenWidth,
                child: const Text(
                  "To track your orders in Shop Ship Pay,\n connect the email you use for online shopping.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFFED294D),fontSize: 13),
                ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 40, bottom: 80),
                width: screenWidth,
                child: const Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image(image: AssetImage('images/box.png'), height: 100, width: 100,),
                        Image(image: AssetImage('images/box.png'), height: 100, width: 100,),
                        Image(image: AssetImage('images/box.png'), height: 100, width: 100,)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image(image: AssetImage('images/box.png'), height: 100, width: 100,),
                        Image(image: AssetImage('images/box.png'), height: 100, width: 100,),
                        Image(image: AssetImage('images/box.png'), height: 100, width: 100,)
                      ],
                    ),
                  ],
                )
              ),

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
                            return const OnboardSignInPage();
                          }));
                },
                child:  Container(
                  width: screenWidth,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color(0xFFED294D)
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Sign In", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 13))
                    ],
                  ),
                ),
              ),


              Container(
                width: screenWidth,
                height: 50,
                decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage('images/or.png'))
                ),
              ),

              Container(
                width: screenWidth,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color(0xFFFFFFFF)
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Sign Up", textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 13))
                  ],
                ),
              ),
            ],
          ),
        ),
        
      ),
    );
  }
}