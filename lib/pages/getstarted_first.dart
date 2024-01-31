import 'package:flutter/material.dart';
import 'package:shop_app/pages/buyerorseller_page.dart';
import 'package:shop_app/pages/getstarted_second.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/pages/home_page_new.dart';
import 'package:shop_app/pages/useronboard_signin/onboard_createaccount.dart';
import 'package:shop_app/pages/useronboard_signin/onboard_signin.dart';
import 'package:toastification/toastification.dart';
import 'dart:convert';

class GetStartedFirstPage extends StatefulWidget {
  const GetStartedFirstPage({super.key});

  @override
  State<GetStartedFirstPage> createState() => _GetStartedFirstPageState();
}

class _GetStartedFirstPageState extends State<GetStartedFirstPage> with TickerProviderStateMixin
{
  late AnimationController _firstController;
  late Animation<double> _firstAnimation;
  bool loading = false;
  bool onboardLoading = false;
  bool isLoggedIn  = false;
  bool isAdminLoggedIn  = false;
  bool useronboard = false;



  //retrieve user onboard value from localstorage
  Future<String?> retrieveUserOnboard() async {
    setState(() {
      onboardLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString('user_onboard');
    print('UserOnboard => ${value}');
    if (value != null){
      if (value == '1'){
        setState(() {
          useronboard = true;
          onboardLoading = false;
        });
      } else {
        setState(() {
          useronboard = false;
          onboardLoading = false;
        });
      }
      return value;
    }
  }

  //retrieve userId from localstorage
  Future<int?> retrieveUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? value = prefs.getInt('id');
    print('UserId => ${value}');
    if (value != null){
      setState(() {
        isLoggedIn = true;
      });
    } else {
      setState(() {
        isLoggedIn = false;
      });
    }
    return value;
  }

  //retrieve admin id from localstorage
  Future<int?> retrieveAdminId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? value = prefs.getInt('admin_id');
    print('AdminId => ${value}');
    if (value != null){
      setState(() {
        isAdminLoggedIn = true;
      });
    } else {
      setState(() {
        isAdminLoggedIn = false;
      });
    }
    return value;
  }



  @override
  void initState() {
    super.initState();
    retrieveUserOnboard();
    retrieveUserId();
    retrieveAdminId();



    // First Animation
    _firstController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _firstController.repeat(reverse: true);
    _firstAnimation = CurvedAnimation(parent: _firstController, curve: Curves.bounceInOut);
    _firstAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(_firstController);
  }


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: onboardLoading == true ? (useronboard == true ? ( isLoggedIn ? const HomePageNew() : (isAdminLoggedIn ? const HomePageNew() : const OnboardSignInPage()))  :
      Container(
        width: screenWidth,
        height: screenHeight,
        color: const Color(0xFFF4DFE2),
        child: Column(
          children: [
            Container(
              height: screenHeight * 0.85,
              width: screenWidth,
              decoration: const BoxDecoration(
              ),
              child:  Stack(
                children: [
                  const Positioned(
                    child: Center(child: Text('Track your orders\n every step of the way',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    )),
                  ),
                  Positioned(
                      left: 110,
                      top: 50,
                      child: ScaleTransition(
                        scale: _firstAnimation,
                        child: const Image(image: AssetImage('images/ball.png')),
                      )

                  ),

                  Positioned(
                      left: 230,
                      top: 150,
                      child: ScaleTransition(
                        scale: _firstAnimation,
                        child: const Image(image: AssetImage('images/bags.png')),
                      )
                  ),

                  Positioned(
                      right: 240,
                      top: 140,
                      child: ScaleTransition(
                        scale: _firstAnimation,
                        child: const Image(image: AssetImage('images/hat.png')),
                      )
                  ),

                  Positioned(
                      right: 310,
                      top: 270,
                      child: ScaleTransition(
                        scale: _firstAnimation,
                        child: const Image(image: AssetImage('images/cream.png')),
                      )
                  ),

                  Positioned(
                      left: 290,
                      top: 270,
                      child: ScaleTransition(
                        scale: _firstAnimation,
                        child: const Image(image: AssetImage('images/chair.png')),
                      )
                  ),

                  Positioned(
                      right: 270,
                      top: 350,
                      child: ScaleTransition(
                        scale: _firstAnimation,
                        child: const Image(image: AssetImage('images/lipstick.png')),
                      )
                  ),

                  Positioned(
                      right: 160,
                      top: 380,
                      child: ScaleTransition(
                        scale: _firstAnimation,
                        child: const Image(image: AssetImage('images/kettle.png')),
                      )
                  ),

                  Positioned(
                      left: 190,
                      top: 380,
                      child: ScaleTransition(
                        scale: _firstAnimation,
                        child: const Image(image: AssetImage('images/clock.png')),
                      )
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
                          return const BuyerOrSellerPage();
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
      )) :
      const Center(child: CircularProgressIndicator(color: Color(0xFFED294D),))
    );
  }
}