import 'package:flutter/material.dart';
import 'package:shop_app/pages/admin/onboarding/payment_onboard.dart';
import 'package:shop_app/pages/admin/onboarding/welcome_onboard.dart';

class ShippingOnboardPage extends StatefulWidget {
  const ShippingOnboardPage({super.key});

  @override
  State<ShippingOnboardPage> createState() => _ShippingOnboardPageState();
}

class _ShippingOnboardPageState extends State<ShippingOnboardPage> {
  String shippingOption = "";
  List<String> shippingArrayValues = [];

  // Shipping Option new settings
  bool isSameDayShipping = false;
  bool isTwoDayShipping = false;
  String SameDayShipping = '';
  String TwoDayShipping = '';

  void handleRadioValueChange(String value) {
    print(value);
    setState(() {
      shippingOption = value;
    });
  }

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
                      return const WelcomeOnboardPage();
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
            height: 350,
            width: 340,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Step 1",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                const SizedBox(height: 5),

                const Text("Which shipping method do you prefer?",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54)),
                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                              value: isSameDayShipping,
                              onChanged: (bool? newValue){
                                setState(() {
                                  isSameDayShipping = newValue!;
                                  newValue == true ? shippingArrayValues.add('Same day shipping') : shippingArrayValues.remove('Same day shipping');
                                });
                                print(shippingArrayValues);
                              }
                          ),
                          const Text('Same day shiping'),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                              value: isTwoDayShipping,
                              onChanged: (bool? newValue){
                                setState(() {
                                  isTwoDayShipping = newValue!;
                                  newValue == true ? shippingArrayValues.add('2-day shipping') : shippingArrayValues.remove('2-day shipping');
                                });
                                print(shippingArrayValues);
                              }
                          ),
                          const Text('2-day shipping'),
                        ],
                      ),
                    ],
                  ),
                ),


                // Same day shipping input ld
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Radio(
                //         value: "Same dayshipping",
                //         activeColor: Colors.blueAccent,
                //         groupValue: shippingOption,
                //         onChanged: (value){
                //           handleRadioValueChange(value!);
                //         }
                //     ),
                //     const Text("Same day shipping"),
                //   ],
                // ),
                // Tow day shipping input old
                // Container(
                //   margin: const EdgeInsets.only(right: 8),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Radio(
                //           value: "Two day shipping",
                //           activeColor: const Color.fromRGBO(68, 138, 255, 1),
                //           groupValue: shippingOption,
                //           onChanged: (value){
                //             handleRadioValueChange(value!);
                //           }
                //       ),
                //       const Text("Two day shipping"),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 20),

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
                              return PaymentOnboardPage(shippingOption: shippingArrayValues);
                            }));
                  },
                  child: Container(
                    width: 380,
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
