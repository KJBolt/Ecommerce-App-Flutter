import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shop_app/pages/check_email.dart';
import 'package:shop_app/pages/confirm_password.dart';
import 'dart:convert';
import 'package:toastification/toastification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formkey = GlobalKey<FormState>();
  bool loading = false;

  // Input Controllers
  final _emailValue = TextEditingController();

  // Success Toast Alerts
  void showSuccessToast(msg) {
    toastification.show(
        context: context,
        title: '$msg',
        autoCloseDuration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white
    );
  }

  // Error Toast Alerts
  void showErrorToast(msg) {
    toastification.show(
        context: context,
        title: '$msg',
        autoCloseDuration: const Duration(seconds: 2),
        backgroundColor: Colors.redAccent[200],
        foregroundColor: Colors.white
    );
  }

  // Redirect to HomePage Function
  void redirectCheckEmailPage() {
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
              return const CheckEmailPage();
            }
        )
    );
  }

  // Make Api Request to server to reset password
  Future<void> resetPassword() async{
    // Set loading to true
    setState(() {
      loading = true;
    });

    Map<String, dynamic> bodyData = {
      'email': _emailValue.text,
    };
    final apiEndpoint = dotenv.env['API_KEY'];
    final uri = Uri.parse("$apiEndpoint/password/email");
    try {
      // Response
      final response = await http.post(
        uri,
        body: bodyData,
      );

      if (response.statusCode == 200){
        // Set loading to false
        setState(() {
          loading = false;
        });

        // Clear Input values
        _emailValue.clear();

        final data = jsonDecode(response.body);
        // showSuccessToast(data['message']);
        redirectCheckEmailPage();
      } else {
        setState(() {
          loading = false;
        });
        showErrorToast('Enter valid email address');
      }
    } catch (error) {
      print(error);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
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
      ),
      body: Center(
        child:  Container(
          height: screenHeight * 0.85,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ListView(
            children: [
              const Text("Reset Password", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              const Text("Enter the email associated with your account "
                  "and we'll send an email with instructions to reset your password",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 20),
              const Text("Email Address"),
              const SizedBox(height: 5),
              Form(
                key: _formkey,
                child: TextFormField(
                  controller: _emailValue,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email Address is required';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding:
                    const EdgeInsets.symmetric(
                        horizontal: 10),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.black),
                        borderRadius:
                        BorderRadius.circular(10)),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              GestureDetector(
                onTap:() {
                  resetPassword();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: const Color(0xFFED294D),
                      borderRadius: BorderRadius.circular(0)
                  ),
                  child: Center(
                      child: loading ? const CircularProgressIndicator(color: Colors.white,) : const Text("Send Instructions",
                      style: TextStyle(color: Colors.white, fontSize: 15))),
                ),
              )
            ],
          ),
        ),
      ),




    );
  }
}