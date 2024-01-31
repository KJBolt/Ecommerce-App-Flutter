import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/components/home_comp.dart';
import 'package:shop_app/components/homecompnew_page.dart';
import 'package:shop_app/pages/favourite_page.dart';
import 'package:shop_app/pages/home_page.dart';
import 'package:shop_app/pages/home_page_new.dart';
import 'package:shop_app/pages/login_page.dart';
import 'package:shop_app/pages/my_orders.dart';
import 'package:shop_app/pages/payment_method.dart';
import 'package:shop_app/pages/settings_page.dart';
import 'package:shop_app/pages/useronboard_signin/onboard_signin.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }


  //retrieve name from localstorage
  Future<String>? retrieveName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('name');
    return name!;
  }

  //retrieve email from localstorage
  Future<String>? retrieveEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    return email!;
  }

  //retrieve name from localstorage
  Future<int>? retrieveId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');
    return id!;
  }

  // Redirect to HomePage Function
  void redirectHomePage() {
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: const OnboardSignInPage(),
      withNavBar: false,
    );
  }

  // Clear User Id from localstorage
  void clearLocalStorageExceptOnboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    prefs.remove("email");
    prefs.remove("name");
    prefs.remove("id");
    // prefs.remove('user_onboard');
  }

  //Logout User
  logoutUser() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
    clearLocalStorageExceptOnboard();
    CartProvider myCartProvider = CartProvider();
    myCartProvider.deleteCartItems();
    redirectHomePage();
  }

  //Logout User
  // logoutUser() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.clear();
  //   CartProvider myCartProvider = CartProvider();
  //   myCartProvider.deleteCartItems();
  //   redirectHomePage();
  // }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
        body: ListView(
          scrollDirection: Axis.vertical,
          children: [
            FutureBuilder<int>(
                future: retrieveId(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting){
                    return const Center(
                      child: CircularProgressIndicator(color: Color(0xFF7386EF)),
                    );
                  }
                  else if (snapshot.data == null) {
                    return Container(
                      height: screenHeight,
                      color:  Colors.white,
                      child: Center(
                          child: Container(
                              margin: const EdgeInsets.only(left: 30, right:30),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(10),
                                  primary: Colors.blueAccent,
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0)),
                                ),
                                onPressed: () {
                                  PersistentNavBarNavigator.pushNewScreen(
                                    context,
                                    screen: const OnboardSignInPage(),
                                    withNavBar: false,
                                  );
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Sign In',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ))
                      ),
                    );

                  } else {
                    return Container(
                      margin: const EdgeInsets.only(top: 20),
                      height: screenHeight,
                      width: screenWidth,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Center(
                        child: Container(
                          height: screenHeight * 0.6,
                          width: screenWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Profile Image
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: Column(children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        image: const DecorationImage(
                                            image: AssetImage('images/bolt.png'),
                                            fit: BoxFit.cover)),
                                  ),
                                  const SizedBox(height: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      FutureBuilder<String>(
                                        future: retrieveName(),
                                        builder: (context, usernameSnapshot) {
                                          if (usernameSnapshot.hasError) {
                                            return const Text('No Username Set');
                                          } else {
                                            String username =
                                                usernameSnapshot.data ?? '';
                                            return Text(username,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                      FutureBuilder<String>(
                                        future: retrieveEmail(),
                                        builder: (context, emailSnapshot) {
                                          if (emailSnapshot.hasError) {
                                            return const Text('No Email set.');
                                          } else {
                                            String email = emailSnapshot.data ?? '';
                                            return Text(email,
                                                style: const TextStyle(
                                                    color: Colors.black54));
                                          }
                                        },
                                      ),
                                    ],
                                  )
                                ]),
                              ),

                              const SizedBox(height: 30),
                              GestureDetector(
                                onTap: () {
                                  cart.resetCounter();
                                  cart.deleteCartItems();
                                  logoutUser();
                                },
                                child: Container(
                                  width: screenWidth * 0.8,
                                  height: screenHeight * 0.06,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFED294D),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: const Center(child: Text("Logout",
                                      style: TextStyle(
                                        color: Colors.white,

                                      ))
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )

                    );
                  }

                }),
          ],
        ));
  }
}
