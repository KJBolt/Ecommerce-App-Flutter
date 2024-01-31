import 'package:flutter/material.dart';
import 'package:shop_app/pages/admin/onboarding/location_onboard.dart';
import 'package:shop_app/pages/admin/onboarding/shipping_onboard.dart';

class PaymentOnboardPage extends StatefulWidget {
  const PaymentOnboardPage({super.key, required this.shippingOption});
  final List<String> shippingOption;

  @override
  State<PaymentOnboardPage> createState() => _PaymentOnboardPageState();
}

class _PaymentOnboardPageState extends State<PaymentOnboardPage> {
  // String paymentMethod = "";
  List<String> paymentArrayValues = [];

  // Payment Option new settings
  bool isCashonDelivery = false;
  bool isMobileMoney = false;
  bool isCard = false;
  String CashonDelivery = '';
  String MobileMoney = '';
  String Card = '';

  // void handleRadioValueChange(String value) {
  //   print(value);
  //   setState(() {
  //     paymentMethod = value;
  //   });
  // }
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
                      return const ShippingOnboardPage();
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
                const Text("Step 2",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                const SizedBox(height: 5),

                const Text("Payment Method",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500)),
                const SizedBox(height: 15),

                const Text("Select the payment to be enabled on your shop",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54)),
                const SizedBox(height: 10),

                // Check boxes
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                              value: isCashonDelivery,
                              onChanged: (bool? newValue){
                                setState(() {
                                  isCashonDelivery = newValue!;
                                  newValue == true ? paymentArrayValues.add('Cash on Delivery') : paymentArrayValues.remove('Cash on Delivery');
                                });
                                print(paymentArrayValues);
                              }
                          ),
                          const Text('Cash on Delivery'),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                              value: isMobileMoney,
                              onChanged: (bool? newValue){
                                setState(() {
                                  isMobileMoney = newValue!;
                                  newValue == true ? paymentArrayValues.add('Mobile Money') : paymentArrayValues.remove('Mobile Money');
                                });
                                print(paymentArrayValues);
                              }
                          ),
                          const Text('Mobile Money'),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                              value: isCard,
                              onChanged: (bool? newValue){
                                setState(() {
                                  isCard = newValue!;
                                  newValue == true ? paymentArrayValues.add('Card') : paymentArrayValues.remove('Card');
                                });
                                print(paymentArrayValues);
                              }
                          ),
                          const Text('Card(Visa, Master Card)'),
                        ],
                      ),
                    ],
                  ),
                ),


                // Container(
                //   margin: const EdgeInsets.only(right: 30),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Radio(
                //           value: "Card",
                //           activeColor: Colors.blueAccent,
                //           groupValue: paymentMethod,
                //           onChanged: (value){
                //             handleRadioValueChange(value!);
                //           }
                //       ),
                //       const Text("Master Card"),
                //     ],
                //   ),
                // ),
                //
                // Container(
                //   margin: const EdgeInsets.only(right: 20),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Radio(
                //           value: "Mobile Money",
                //           activeColor: Colors.blueAccent,
                //           groupValue: paymentMethod,
                //           onChanged: (value){
                //             handleRadioValueChange(value!);
                //           }
                //       ),
                //       const Text("Mobile Money"),
                //     ],
                //   ),
                // ),
                //
                // Container(
                //   margin: const EdgeInsets.only(right: 2),
                //   child:Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Radio(
                //           value: "Cash on delivery",
                //           activeColor: Colors.blueAccent,
                //           groupValue: paymentMethod,
                //           onChanged: (value){
                //             handleRadioValueChange(value!);
                //           }
                //       ),
                //       const Text("Cash on delivery"),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 20),
                // Continue Button
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
                              return LocatioOnboardPage(shippingOption: widget.shippingOption,paymentMethod: paymentArrayValues,);
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
