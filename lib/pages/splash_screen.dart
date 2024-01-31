import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_app/components/homecompnew_page.dart';
import 'package:shop_app/pages/buyerorseller_page.dart';
import 'package:shop_app/pages/getstarted_first.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/pages/home_page_new.dart';
import 'package:shop_app/pages/useronboard_signin/onboard_signin.dart';

class SplashScreenPage extends StatefulWidget {

  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> with SingleTickerProviderStateMixin
{
  late String onBoardChecker = '0';

  void retriveOnboardValue () async{
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? onboardValue = prefs.getString('user_onboard');
      print("Onboard Value => ${onboardValue}");
      if (onboardValue != null) {
        setState(() {
          onBoardChecker = onboardValue!;
        });
      } else {
        print("Onboard Value is null");
        setState(() {
          onBoardChecker = '0';
        });
      }

    } catch (e) {
      print(e);
    }

  }

  @override
  void initState(){
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // Check the onboard value
    retriveOnboardValue();

    Future.delayed(const Duration(seconds: 5), (){
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => onBoardChecker != '1' ? const BuyerOrSellerPage() : const HomePageNew()
      ));
    });
  }

  @override
  void dispose(){
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFED294D),
        child: const Center(
            child: Image(
              image: AssetImage('images/logo.png'), height: 150, width: 150,)),
      ),

    );
  }
}