import 'package:flutter/material.dart';
import 'package:shop_app/pages/admin/onboarding/congrats_onboard.dart';
import 'package:shop_app/pages/admin/onboarding/payment_onboard.dart';
import 'package:shop_app/pages/admin/onboarding/shipping_onboard.dart';

class LocatioOnboardPage extends StatefulWidget {
  const LocatioOnboardPage(
      {super.key, required this.shippingOption, required this.paymentMethod});

  final List<String> shippingOption;
  final List<String> paymentMethod;

  @override
  State<LocatioOnboardPage> createState() => _LocatioOnboardPageState();
}

class _LocatioOnboardPageState extends State<LocatioOnboardPage> {
  // Form Key
  final _formkey = GlobalKey<FormState>();

  // Input Controllers
  final location = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
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
                      return PaymentOnboardPage(shippingOption: widget.shippingOption,);
                    }));
          },
        ),
      ),
      body: Container(
        color: Colors.blue[300],
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            height: 400,
            width: 340,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Step 3",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                const SizedBox(height: 5),

                const Text("Shop Location",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500)),
                const SizedBox(height: 10),

                const Text("Select the location of your shop",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54)),
                const SizedBox(height: 15),

                // Email Input field
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formkey,
                    child: TextFormField(
                      controller: location,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid location';
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
                          hintText: 'Enter location here..',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                GestureDetector(
                  onTap: () {
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
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return CongratsOnboardPage(shippingOption: widget.shippingOption,paymentMethod: widget.paymentMethod,location: location.text,);
                            }));
                  },
                  child: Container(
                    width: 200,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Continue", style: TextStyle(color: Colors.white)),
                        Icon(Icons.arrow_forward_rounded, color: Colors.white)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )

    );
  }
}
