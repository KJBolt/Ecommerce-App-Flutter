import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shop_app/pages/cart_page.dart';
import 'package:shop_app/pages/quick_login.dart';
import 'package:shop_app/pages/quick_signup.dart';
import 'package:shop_app/pages/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/pages/shipping_form.dart';
import 'package:toastification/toastification.dart';
// import 'package:shop_app/model/cart_model.dart';
// import 'package:shop_app/provider/cart_provider.dart';

class QuickEmailPage extends StatefulWidget {
  const QuickEmailPage({super.key, required this.prodId});
  final int prodId;

  @override
  State<QuickEmailPage> createState() => _QuickEmailPageState();
}

class _QuickEmailPageState extends State<QuickEmailPage> {
  final _formkey = GlobalKey<FormState>();
  final _emailValue = TextEditingController();

  @override
  void initState() {
    super.initState();
    // cartItems();
  }

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

  //save token to localstorage
  Future<void> saveTokenToLocal(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  //save email to localstorage
  Future<void> saveEmailToLocal(String email) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
  }

  // Redirect to Register Function
  redirectRegisterPage(var email) {
    Navigator.push(
        context,
        // MaterialPageRoute(builder: (context) => const ProductDetails()),
        PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(-1.0, 0.0);
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
              return QuickSignupPage(emailAddress: email, id: widget.prodId,);
            }));
  }

  // Redirect to Login Function
  redirectLoginPage(var email) {
    Navigator.push(
        context,
        // MaterialPageRoute(builder: (context) => const ProductDetails()),
        PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(-1.0, 0.0);
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
              return QuickLoginPage(emailAddress: email, id: widget.prodId,);
            }));
  }

  // Make Api Request to server
  void fetchData(query) async {
    print(query);
    final apiEndpoint = dotenv.env['API_KEY'];
    final url = '$apiEndpoint/check-email-exists';
    final response = await http.get(Uri.parse('$url/$query'));
    final decodedData = jsonDecode(response.body);
    if (decodedData['exists'] != null) {
      final data = decodedData['exists'];
      if (data == true) {
        print("Email exist");
        redirectLoginPage(query);
      } else {
        print("Email does not exist");
        redirectRegisterPage(query);
      }
    } else {
      throw Exception("Failed to fetch data");
    }
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: const Color(0xFFDADADA),
          elevation: 0.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF545D68)),
            onPressed: () {
              Navigator.push(
                  context,
                  // MaterialPageRoute(builder: (context) => const ProductDetails()),
                  PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 400),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(
                            -1.0, 0.0); // Start off the screen to the left
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
                        return CartPage(productId: widget.prodId,);
                      }));
            },
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
              color: Color(0xFFDADADA)
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              height: 360,
              width: 320,
              child: Column(
                children: <Widget>[
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Login or Signup',
                        style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: 280,
                        child: const Text(
                            'Sign up to shop your favourite stores, speed through checkouts, and track your orders',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400)),
                      )
                    ],
                  ),
                  Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 15),
                          child: Column(
                            children: [
                              // Email Field
                              TextFormField(
                                controller: _emailValue,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a valid email address';
                                  }
                                  final bool emailValid = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value);
                                  if (!emailValid) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    hintText: 'Email Address',
                                    border: OutlineInputBorder(
                                        borderSide:
                                        BorderSide(color: Colors.black))),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),

                        // Not a user
                        const SizedBox(
                          height: 10,
                        ),

                        // Continue Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (_formkey.currentState!.validate()) {
                                  fetchData(_emailValue.text);
                                } else {
                                  print("Search field cannot be empty");
                                }
                              },
                              child: Container(
                                  margin: const EdgeInsets.all(10),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 20),
                                  decoration: BoxDecoration(
                                      color: Color(0xFFED294D),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Continue',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white)),
                                    ],
                                  )),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
        );

  }
}
