import 'package:flutter/material.dart';
import 'package:shop_app/pages/useronboard_signin/new_password.dart';
// import 'package:shop_app/pages/useronboard_signin/verify_code.dart';
import 'package:shop_app/pages/admin/onboarding/welcome_onboard.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardCreateShop extends StatefulWidget {
  const OnboardCreateShop({super.key});

  @override
  State<OnboardCreateShop> createState() => _OnboardCreateShopState();
}

class _OnboardCreateShopState extends State<OnboardCreateShop> {

  final _formkey = GlobalKey<FormState>();

  // Input Controllers
  final _nameValue = TextEditingController();
  final _emailValue = TextEditingController();
  final _shopValue = TextEditingController();
  final _passwordValue = TextEditingController();
  bool loading = false;

    // Success Toast Alerts
  void showSuccessToast(msg) {
    toastification.show(
        context: context,
        title: '$msg',
        autoCloseDuration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white);
  }

  // Error Toast Alerts
  void showErrorToast(msg) {
    toastification.show(
        context: context,
        title: '$msg',
        autoCloseDuration: const Duration(seconds: 2),
        backgroundColor: Colors.redAccent[200],
        foregroundColor: Colors.white);
  }

  // Redirect to HomePage Function
  void redirectOnboardPage() {
    Navigator.push(
        context,
        // MaterialPageRoute(builder: (context) => const ProductDetails()),
        PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(-1.0, 0.0); // Start off the screen to the left
              const end = Offset.zero;
              var tween = Tween(begin: begin, end: end);
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            pageBuilder: (context, animation, secondaryAnimation) {
              return const WelcomeOnboardPage();
            }
        )
    );
  }

    //save token to localstorage
  Future<void> saveTokenToLocal(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  Future<void> saveShopNAmeToLocal(String name) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('shop_name', name);
  }

  //save ShopID to localstorage
  Future<void> saveShopIdToLocal(int id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('shop_id', id);
  }

    //save name to localstorage
  Future<void> saveIdToLocal(int id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('admin_id', id);
  }

  // Make Api Request to server
  Future<void> registerUser() async{
    setState(() {
      loading = true;
    });
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> bodyData = {
      'name': _nameValue.text,
      'email': _emailValue.text,
      'password': _passwordValue.text,
      'shop_name': _shopValue.text
    };
    final apiEndpoint = dotenv.env['API_KEY'];
    final uri = Uri.parse("${apiEndpoint}/register");
    try {
      // Response
      final response = await http.post(
        uri,
        body: bodyData,
      );
      final data = jsonDecode(response.body);
      // print(data['message']['is_admin']);
      if (data['status'] == 201) {
        setState(() {
          loading = false;
        });
        // Clear Input values
        _emailValue.clear();
        _nameValue.clear();
        _passwordValue.clear();
        _shopValue.clear();

         saveTokenToLocal(data['access_token']);
        saveIdToLocal(data['user']['id']);
        saveShopNAmeToLocal(data['shop_name']);
        saveShopIdToLocal(data['shop_id']);
        
        showSuccessToast(data['message']);
        Future.delayed(const Duration(milliseconds: 3000), redirectOnboardPage);
      } else {
        showErrorToast("Email has already been taken.");
        setState(() {
          loading = false;
        });
      }
    } catch (error) {
      showErrorToast("Registration failed. Try Again");
      setState(() {
        loading = false;
      });
    }
  }

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
              Container(
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text("Create Shop", style: TextStyle(fontSize: 20, color: Color(0xFFED294D), fontWeight: FontWeight.w500)),
                        SizedBox(height: 10),
                        Text("Fill your information below or Register \n with your social account.",
                            style: TextStyle(fontSize: 15, color: Color(0xFFED294D), fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                        )
                      ],
                    )

                  ],
                ),
              ),

              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                                  Text("Full Name",
                                      style: TextStyle(fontSize: 15),
                                      textAlign: TextAlign.start
                                  ),
                                ],
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 8),
                                    // Name Input
                                    TextFormField(
                                      controller: _nameValue,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Name is required';
                                        }
                                        return null;
                                      },
                                      decoration:  InputDecoration(
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(color: Colors.black),
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),

                                    ),
                                    const SizedBox(height: 10),


                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text("Shop Name",
                                            style: TextStyle(fontSize: 15),
                                            textAlign: TextAlign.start
                                        ),
                                      ],
                                    ),
                                    // Password Input
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: _shopValue,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your shop name';
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


                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text("Email Address",
                                            style: TextStyle(fontSize: 15),
                                            textAlign: TextAlign.start
                                        ),
                                      ],
                                    ),
                                    // Password Input
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: _emailValue,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your email';
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


                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text("Password",
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
                                          return 'Please enter your password';
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
                      const SizedBox(height: 25),
                      GestureDetector(
                        onTap: () {
                           if (_formkey.currentState!.validate()) {
                            registerUser();
                          } else {
                            print("Not validated");
                          }
                        },
                        child:  Container(
                          width: screenWidth,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: const Color(0xFFED294D)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              loading == true ? const Center(child: CircularProgressIndicator(color: Colors.white,),) :
                              const Text("Create Shop",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white,
                                      fontSize: 13)
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),


                      // Social Media Icons
                      const SizedBox(height: 10),
                      Container(
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Image(image: AssetImage('images/shoe.png'), width: 60, height: 60,),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Image(image: AssetImage('images/box.png'), width: 50, height: 50,),
                            ),
                          ],
                        ),
                      )

                    ],
                  )
              )
            ],
          )
        ],
      ),
    );
  }
}