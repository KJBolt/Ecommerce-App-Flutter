import 'package:flutter/material.dart';
import 'package:shop_app/pages/multistep_form.dart';
import 'package:shop_app/pages/payment_page.dart';
import 'package:shop_app/model/formModel.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/viewModel/formsVM.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
// import 'package:shop_app/viewModel/productsVM.dart';
import 'package:shop_app/provider/cart_provider.dart';
// import 'package:shop_app/model/productModel.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:math';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late int shopID;
  late String shopLocation = '';
  late String shippingOption = '';
  late int totalPrice = 0;

  @override
  void initState() {
    super.initState();
    retrieveShopId();
    retrieveTotalPrice();
    // retrieveShopLocatiion();
    // retrieveShippingOption();
  }

  //used to generate a unique reference for payment
  String _getReference() {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    int random = Random().nextInt(9000) + 1000;
    String reference = '$timestamp$random';
    return reference;
  }

  Future<void> retrieveShopId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? shopId = prefs.getInt('shopId');
    String? shop_Location = prefs.getString('shopLocation');
    String? shipping_Option = prefs.getString('shippingOption');
    // print(shopId);
    setState(() {
      shopID = shopId!;
      shopLocation = shop_Location!;
      shippingOption = shipping_Option!;
    });
  }

  //retrieve Total price from localstorage
  Future<int?> retrieveTotalPrice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? val = prefs.getInt('totalPrice');
    if (val != null){
      // print('Total price from local storage => ${val}');
      setState(() {
        totalPrice = val;
      });
      return val;
    }
  }

  // Future<String> retrieveShopLocatiion() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? shopLocation = prefs.getString('shopLocation');
  //   print('shopLocation from checkout page => ${shopLocation}');
  //   return shopLocation.toString();
  //   // setState(() {
  //   //   shopLocation = shopLocation;
  //   // });
  //
  // }
  //
  // Future<String>retrieveShippingOption() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? shippingOption = prefs.getString('shippingOption');
  //   print('shopOption from checkout page => ${shippingOption}');
  //   return shippingOption.toString();
  //   // setState(() {
  //   //   shippingOption = shippingOption;
  //   // });
  //
  // }

  // double total = 0.00;
  // int quantity = 0;
  // double subTotal(List products) {
  //   quantity = products.length;
  //   var subtotal = 0.00;
  //   for (var product in products) {
  //     subtotal += product.price;
  //   }
  //   total = subtotal + 9.00;
  //   return subtotal;
  // }

  @override
  Widget build(BuildContext context) {
    // Screen width
    double screenWidth = MediaQuery.of(context).size.width;
    // Retrieve the saved form data from the provider
    FormData? formData = Provider.of<FormDataModel>(context).formData;
    //retrieve products from cart
    // List? products = Provider.of<ProductsVM>(context).lst;
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: const Text("Order Summary", style: TextStyle(fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF545D68)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                // Order Card
                Container(
                  
                ),


                // Shipping Details
                Container(
                  padding: const EdgeInsets.all(10),
                  width: screenWidth,
                  child: const Text("Shipping Address",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 1),
                        ),
                      ]),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (formData != null)
                              Text(formData.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)), //
                          ],
                        ),
                      ),
                      if (formData != null) Text(formData.email),
                      if (formData != null) Text(formData.streetName),
                    ],
                  ),
                ),

                // Payment Details
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 1),
                        ),
                      ]
                  ),
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "Payment",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                            ),

                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        width: screenWidth,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Mobile Money Image
                            Container(
                              height: 60,
                              margin: const EdgeInsets.only(bottom: 10, left: 10),
                              width: 60,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('images/mtn.png'))),
                            ),

                            // Visa Card Image
                            Container(
                              height: 60,
                              width: 60,
                              margin: const EdgeInsets.only(left: 10),
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('images/mastercard.png'))),
                            )
                          ],
                        ),
                      )

                    ],
                  ),
                ),

                // Order Summary
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Column(
                    children: [
                      Container(
                        width: screenWidth,
                        child: const Text(
                          "Order Summary",
                          textAlign: TextAlign.left,
                          style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Subtotal",
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              'GHC $totalPrice.0',
                              style: const TextStyle(color: Colors.black),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                           const Text(
                              "Delivery",
                              style: TextStyle(color: Colors.black),
                            ),
                            Text('GHC ${formData!.deliveryFee}',
                            style: const TextStyle(color: Colors.black))
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total",
                              style: TextStyle(
                                  color: Colors.black, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              'GHC ${totalPrice + formData!.deliveryFee}',
                              style: const TextStyle(
                                  color: Colors.black, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                GestureDetector(
                  child: Container(
                    width: screenWidth,
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(10),
                          primary: const Color(0xFFED294D),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0)),
                        ),
                        onPressed: () {
                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: PaymentPage(
                              amount: '${totalPrice + formData.deliveryFee}',
                              email: formData!.email,
                              reference: _getReference(),
                              name: formData.name,
                              streetName: formData.streetName,
                              country: formData.country,
                              phoneNumber: formData.phoneNumber,
                              paymentMethod: formData.paymentMethod,
                              quantity: cart.quantity.toString().toString(),
                              shopId: shopID,
                              shopLocation: shopLocation,
                              shippingOption: formData.shippingOption,
                            ),
                            withNavBar: true, // OPTIONAL VALUE. True by default.
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Pay Now!!!',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),

    );
  }
}
