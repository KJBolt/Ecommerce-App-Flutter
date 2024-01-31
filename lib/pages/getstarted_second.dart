import 'package:flutter/material.dart';
import 'package:shop_app/pages/getstarted_third.dart';

class GetStartedSecondPage extends StatefulWidget {
  const GetStartedSecondPage({super.key});

  @override
  State<GetStartedSecondPage> createState() => _GetStartedSecondPageState();
}

class _GetStartedSecondPageState extends State<GetStartedSecondPage> {

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: const Color(0xFFF4DFE2),
        child: Column(
          children: [
            Container(
              height: screenHeight * 0.85,
              width: screenWidth,
              decoration: BoxDecoration(
              ),
              child: const Stack(
                children: [
                  Positioned(
                    child: Center(child: Text('Discover your next\n favorite brand',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    )),
                  ),
                  Positioned(
                      left: 110,
                      top: 50,
                      child: Image(image: AssetImage('images/ball.png'))
                  ),

                  Positioned(
                      left: 230,
                      top: 150,
                      child: Image(image: AssetImage('images/bags.png'))
                  ),

                  Positioned(
                      right: 240,
                      top: 140,
                      child: Image(image: AssetImage('images/hat.png'))
                  ),

                  Positioned(
                      right: 310,
                      top: 270,
                      child: Image(image: AssetImage('images/cream.png'))
                  ),

                  Positioned(
                      left: 290,
                      top: 270,
                      child: Image(image: AssetImage('images/chair.png'))
                  ),

                  Positioned(
                      right: 270,
                      top: 350,
                      child: Image(image: AssetImage('images/lipstick.png'))
                  ),

                  Positioned(
                      right: 160,
                      top: 380,
                      child: Image(image: AssetImage('images/kettle.png'))
                  ),

                  Positioned(
                      left: 190,
                      top: 380,
                      child: Image(image: AssetImage('images/clock.png'))
                  ),
                ],
              ),
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
                          return const GetStartedThirdPage();
                        }));
              },
              child: Container(
                width: screenWidth,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFFED294D)
                ),
                child: const Text("Get Started", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 15)),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 10),
              child: const Text('By proceeding to use Shop Ship Pay, you agree to our\n terms of service and privacy policy.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFED294D), fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}