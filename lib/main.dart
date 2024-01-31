import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/pages/add_card.dart';
import 'package:shop_app/pages/admin/dashboard_new.dart';
import 'package:shop_app/pages/admin/messges_page.dart';
import 'package:shop_app/pages/confirm_password.dart';
import 'package:shop_app/pages/filter_search.dart';
import 'package:shop_app/pages/getstarted_first.dart';
import 'package:shop_app/pages/home_page_new.dart';
import 'package:shop_app/pages/reset_password.dart';
import 'package:shop_app/pages/shippingpages/choose_shipping.dart';
import 'package:shop_app/pages/splash_screen.dart';
import 'package:shop_app/pages/useronboard_signin/complete_profile.dart';
import 'package:shop_app/pages/useronboard_signin/new_password.dart';
import 'package:shop_app/pages/useronboard_signin/onboard_signin.dart';
import 'package:shop_app/pages/useronboard_signin/verify_code.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/viewModel/formsVM.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'dart:io';




Future <void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform
    );
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  @override
  const MyApp({super.key});

  void initState() {
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => FormDataModel()),
      ],
      child: MaterialApp(
          title: 'ShopShipPay',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const SplashScreenPage(),
        ),
      );
  }
} 
