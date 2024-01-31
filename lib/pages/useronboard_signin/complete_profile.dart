import 'package:flutter/material.dart';
import 'package:shop_app/pages/home_page_new.dart';
import 'package:shop_app/pages/useronboard_signin/onboard_createaccount.dart';

class CompletePasswordPage extends StatefulWidget {
  const CompletePasswordPage({super.key});

  @override
  State<CompletePasswordPage> createState() => _CompletePasswordPageState();
}

class _CompletePasswordPageState extends State<CompletePasswordPage> {

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
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Column(
            children: [
              const SizedBox(height: 15,),
              Container(
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text("Complete your profile", style: TextStyle(fontSize: 20, color: Color(0xFFED294D), fontWeight: FontWeight.w500)),
                        SizedBox(height: 10),
                        Text("Don’t worry only your can see can see your \npersonal data. No one else will be able to see it.", style: TextStyle(fontSize: 15, color: Color(0xFFED294D), fontWeight: FontWeight.w400))
                      ],
                    )

                  ],
                ),
              ),

              const SizedBox(height: 30),
              Container(
                height: screenHeight * 0.2,
                child:  Stack(
                  children: [
                    Positioned(child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80),
                          border: Border.all(color: Colors.grey)
                      ),
                      height: 150,
                      width: 150,
                      child: const Image(image: AssetImage('images/avatar.png')),
                    )),

                    Positioned(
                        bottom: 0,
                        right: 5,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.red,
                          ),
                          child: const Icon(Icons.camera_alt_outlined, size: 30, color: Colors.white,),
                        )),
                  ],
                ),
              ),

              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
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
                                  Text("Name",
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

                                    // Phone Number Input
                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text("Phone Number",
                                            style: TextStyle(fontSize: 15),
                                            textAlign: TextAlign.start
                                        ),
                                      ],
                                    ),
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

                                    // Gender Input
                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text("Gender",
                                            style: TextStyle(fontSize: 15),
                                            textAlign: TextAlign.start
                                        ),
                                      ],
                                    ),
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
                      const SizedBox(height: 20),
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
                              Text("Complete Profile", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 13))
                            ],
                          ),
                        ),
                      ),

                    ],
                  )
              )
            ],
          ),
        ],
      )

    );
  }
}