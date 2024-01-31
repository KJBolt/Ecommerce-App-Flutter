import 'package:flutter/material.dart';
import 'package:shop_app/pages/home_page_new.dart';
import 'package:shop_app/pages/useronboard_signin/complete_profile.dart';
import 'package:shop_app/pages/useronboard_signin/onboard_createaccount.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {

  final _formkey = GlobalKey<FormState>();

  // Input Controllers
  final _emailValue = TextEditingController();
  final _passwordValue = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF545D68)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text("Skip", style: TextStyle(color: Color(0xFFED294D))),
          ),

        ],
      ),
      body: Column(
        children: [
          Container(
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text("New Password", style: TextStyle(fontSize: 20, color: Color(0xFFED294D), fontWeight: FontWeight.w500)),
                    SizedBox(height: 10),
                    Text("Your new password must be different \nfrom previously used passwords.", style: TextStyle(fontSize: 15, color: Color(0xFFED294D), fontWeight: FontWeight.w400))
                  ],
                )

              ],
            ),
          ),

          Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: Column(
                children: [
                  // Input Fields
                  Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("New Password",
                                  style: TextStyle(fontSize: 15),
                                  textAlign: TextAlign.start
                              ),
                            ],
                          ),

                          Container(
                            child: Column(
                              children: [
                                const SizedBox(height: 8),
                                // Email Input
                                TextFormField(
                                  controller: _emailValue,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Field is required';
                                    }
                                    return null;
                                  },
                                  decoration:  InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                    border: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(30)
                                    ),
                                  ),

                                ),
                                const SizedBox(height: 20),


                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("Confirm Password",
                                        style: TextStyle(fontSize: 15),
                                        textAlign: TextAlign.start
                                    ),
                                  ],
                                ),

                                // Password Input
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _passwordValue,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Field is required';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                      border: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Colors.black),
                                          borderRadius: BorderRadius.circular(30)
                                      )
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ],
                      )
                  ),

                  // Sign In Button
                  const SizedBox(height: 40),
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
                                return const HomePageNew();
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
                          Text("Create New Password", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 13))
                        ],
                      ),
                    ),
                  ),

                ],
              )
          )
        ],
      ),
    );
  }
}