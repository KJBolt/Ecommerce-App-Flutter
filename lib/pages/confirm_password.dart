import 'package:flutter/material.dart';
import 'package:shop_app/pages/useronboard_signin/onboard_signin.dart';
import 'dart:convert';
import 'package:toastification/toastification.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ConfirmPasswordPage extends StatefulWidget {
  const ConfirmPasswordPage({super.key});

  @override
  State<ConfirmPasswordPage> createState() => _ConfirmPasswordPageState();
}

class _ConfirmPasswordPageState extends State<ConfirmPasswordPage> {
  final _formkey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool loading = false;

  // Input Controllers
  final _password = TextEditingController();
  final _verifycode = TextEditingController();

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
  void redirectSignInPage() {
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
              return const OnboardSignInPage();
            }
        )
    );
  }


  // Make Api Request to server to change password
  Future<void> confirmNewPassword() async{
    // Set loading to true
    setState(() {
      loading = true;
    });

    print(_password.text);
    print(_verifycode.text);
    Map<String, dynamic> bodyData = {
      'code': _verifycode.text,
      'password': _password.text
    };
    final apiEndpoint = dotenv.env['API_KEY'];
    final uri = Uri.parse("$apiEndpoint/password/reset");
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
        _verifycode.clear();
        _password.clear();

        final data = jsonDecode(response.body);
        showSuccessToast(data['message']);
        redirectSignInPage();

      } else {
        setState(() {
          loading = false;
        });
        print(response.body);
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
              const Text("Create New Password", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              const Text("Your new password must be different from previous used passwords.",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Password
                    const Text("Verification Code"),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _verifycode,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email Address is required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding:const EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.black),
                            borderRadius:
                            BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Confirm Password
                    const Text("Password"),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _password,
                      obscureText: _obscureText,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
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
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.black),
                            borderRadius:
                            BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              GestureDetector(
                onTap: (){
                  confirmNewPassword();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      color: const Color(0xFFED294D),
                      borderRadius: BorderRadius.circular(0)
                  ),
                  child: const Center(child: Text("Reset Password",
                      style: TextStyle(color: Colors.white, fontSize: 15))
                  ),
                ),
              )


            ],
          ),
        ),
      ),




    );
  }
}