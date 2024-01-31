import 'package:flutter/material.dart';
import 'package:shop_app/components/homecompnew_page.dart';
import 'package:shop_app/pages/home_page_new.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  void setOnboardCheck () async{
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('onboardCheck', 1);
  }


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
             Container(
               height: screenHeight * 0.77,
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.end,
                     children: [
                       GestureDetector(
                         onTap: () {
                           setOnboardCheck();
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
                                     return const HomePageNew();
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
                       "Follow your order\n every step of the way",
                       textAlign: TextAlign.center,
                       style: TextStyle(color: Color(0xFFED294D),fontSize: 25, fontWeight: FontWeight.w500),
                     ),
                   ),

                   Container(
                       margin: const EdgeInsets.only(top: 65, bottom: 80),
                       width: screenWidth,
                       child: const Column(
                         children: [
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Image(image: AssetImage('images/hat.png')),
                               Image(image: AssetImage('images/shoe.png')),
                             ],
                           ),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Image(image: AssetImage('images/kettle.png')),
                             ],
                           ),
                         ],
                       )
                   ),
                 ],
               ),
             ),


             Container(
               width: screenWidth,
               margin: const EdgeInsets.symmetric(horizontal: 10),
               padding: const EdgeInsets.symmetric(vertical: 12),
               decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(30),
                   color: const Color(0xFFED294D)
               ),
               child: const Text("Get tracking updates", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 15)),
             ),

             Container(
               margin: const EdgeInsets.only(top: 10),
               child: const Text('We will also send you updates with information about your\norders, special offers, and news.',
                 textAlign: TextAlign.center,
                 style: TextStyle(color: Color(0xFFED294D), fontSize: 12),
               ),
             )



           ],
         ),
       ),

     ),

    );
  }
}