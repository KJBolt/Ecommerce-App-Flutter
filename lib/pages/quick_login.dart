import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shop_app/pages/cart_page.dart';
import 'package:shop_app/pages/quick_email.dart';
import 'package:shop_app/pages/quick_signup.dart';
import 'package:shop_app/pages/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/pages/shipping_form.dart';
import 'package:toastification/toastification.dart';
// import 'package:shop_app/model/cart_model.dart';
// import 'package:shop_app/provider/cart_provider.dart';

class QuickLoginPage extends StatefulWidget {
  dynamic emailAddress;
  final int id;
  QuickLoginPage({super.key, required this.emailAddress, required this.id});

  @override
  State<QuickLoginPage> createState() => _QuickLoginPageState();
}

class _QuickLoginPageState extends State<QuickLoginPage> {
  final _formkey = GlobalKey<FormState>();
  final _passwordValue = TextEditingController();
  bool loading = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    // cartItems();
  }

  //cart
  // void cartItems() async {
  //   CartProvider myCartProvider = CartProvider();
  //   await myCartProvider.getData();
  //   List<Cart> products = myCartProvider.cart;
  //   for (var element in products) {
  //     print(element.id);
  //   }
  // }

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

  //save name to localstorage
  Future<void> saveNameToLocal(String name) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);
  }

  //save name to localstorage
  Future<void> saveIdToLocal(int id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', id);
  }

  // Redirect to HomePage Function
  redirectShippingFormPage(var name, var email) {
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
              return ShippingFormPage(username:name, useremail:email);
            }));
          
  }

  // Make Api Request to server
  Future<void> loginUser() async {

    setState(() {
      loading = true;
    });
    // Map<String, String> headers = {
    //   'Content-Type': 'application/json',
    // };
    Map<String, dynamic> bodyData = {
      'email': widget.emailAddress,
      'password': _passwordValue.text,
    };
    final apiEndpoint = dotenv.env['API_KEY'];
    final uri = Uri.parse("${apiEndpoint}/login");
    try {
      // Response
      final response = await http.post(
        uri,
        body: bodyData,
      );
      final data = jsonDecode(response.body);
      if (data['status'] == 200) {

        // Set loading to false
        setState(() {
          loading = false;
        });

        if (data['user']['is_admin'] == 1){
          showErrorToast('Sign in as a user to purchase product');
        } else {
          // Clear Input values
          _passwordValue.clear();
          saveTokenToLocal(data['access_token']);
          saveNameToLocal(data['user']['name']);
          saveEmailToLocal(data['user']['email']);
          saveIdToLocal(data['user']['id']);
          String username = data['user']['name'];
          String useremail = data['user']['email'];
          showSuccessToast('Login Successfully');
          Future.delayed(
              const Duration(milliseconds: 3000), redirectShippingFormPage(username,useremail)
          );
        }
      } else {
        showErrorToast("Invalid Credentials.");
      }
    } catch (error) {
      showErrorToast("Login failed. Try Again");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        const begin =
                        Offset(-1.0, 0.0); // Start off the screen to the left
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
                        return QuickEmailPage(prodId: widget.id,);
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
              height: 330,
              width: 320,
              child: Column(
                children: <Widget>[
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Login or Signup',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                        width: 280,
                        child: const Text(
                            'Sign up to shop your favourite stores, speed through checkouts, and track your orders'),
                      )
                    ],
                  ),
                  Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              // Password Input
                              TextFormField(
                                controller: _passwordValue,
                                obscureText: _obscureText,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black)
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });

                                    },
                                    child: Icon(
                                        _obscureText ? Icons.visibility_off : Icons.visibility
                                    ),
                                  ),
                                ),
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
                                  loginUser();
                                } else {
                                  print("Search field cannot be empty");
                                }
                              },
                              child: Container(
                                  margin: const EdgeInsets.all(10),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 20),
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFED294D),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      loading == true ?
                                      Container(
                                        height: 30,
                                        width: 30,
                                        child: const Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                                      ):
                                      const Text('Continue',
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
