import 'package:flutter/material.dart';
// import 'package:shop_app/pages/signin_page.dart';
import 'package:shop_app/pages/useronboard_signin/onboard_signin.dart';
import 'package:shop_app/pages/useronboard_signin/onboard_createaccount.dart';
import 'package:shop_app/pages/useronboard_signin/onboard_createshop.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page_new.dart';


class BuyerOrSellerPage extends StatefulWidget {
  const BuyerOrSellerPage({super.key});

  @override
  State<BuyerOrSellerPage> createState() => _BuyerOrSellerPageState();
}

class _BuyerOrSellerPageState extends State<BuyerOrSellerPage> {
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
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: onboardLoading == true ? (useronboard == true ? ( isLoggedIn ? const HomePageNew() : (isAdminLoggedIn ? const HomePageNew() : const OnboardSignInPage()))  :
      ListView(
        scrollDirection: Axis.vertical,
        children: [
          Container(
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
                                    return const OnboardSignInPage();
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
                      "Follow your order every \nstep of the way",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFFED294D),fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: screenWidth,
                    child: const Text(
                      "To track your orders in Shop Ship Pay, \nconnect the email you use for online shopping.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFFED294D),fontSize: 13),
                    ),
                  ),

                  Container(
                      margin: const EdgeInsets.only(top: 40, bottom: 20),
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
                          Text("Are you a Buyer?", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 13))
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
                    child: Container(
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
                          Text("Are you a Seller?", textAlign: TextAlign.center, style: TextStyle(color: Colors.black, fontSize: 13))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

          ),
        ],
      )) :
      const Center(child: CircularProgressIndicator(color: Color(0xFFED294D),))



    );
  }
}