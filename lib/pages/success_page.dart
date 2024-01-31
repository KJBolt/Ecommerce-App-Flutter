import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shop_app/components/delivered_tab.dart';
import 'package:shop_app/components/home_comp.dart';
import 'package:shop_app/components/homecompnew_page.dart';
import 'package:shop_app/pages/home_page.dart';
import 'package:shop_app/pages/home_page_new.dart';
import 'package:shop_app/viewModel/productsVM.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/database/db_helper.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/model/cart_model.dart';

class SuccessPage extends StatefulWidget {
  const SuccessPage({
    super.key,
    required this.amount,
    required this.email,
    required this.reference,
    required this.name,
    required this.phoneNumber,
    required this.streetName,
    required this.country,
    required this.paymentMethod,
    required this.quantity,
    required this.shopId,
    required this.shopLocation,
    required this.shippingOption,
  });
  final String amount;
  final String email;
  final String reference;
  final String name;
  final String phoneNumber;
  final String streetName;
  final String country;
  final String paymentMethod;
  final String quantity;
  final int shopId;
  final String shopLocation;
  final String shippingOption;

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  late Future<String>? _data;
  DBHelper dbHelper = DBHelper();



  @override
  void initState() {
    super.initState();
    clearTotalPrice();
    _data = sendFormDataToApi();// Call the API once in initState
  }

  Future<String> sendFormDataToApi() async {
    final int? id = await retrieveId();

    List<Cart> cartItems = await dbHelper.getCartList();
    final itemsData = cartItems.map((item) => item.toMap()).toList();
    // print('Items Data => ${itemsData}');

    Map<String, dynamic> requestData = {
      'name': widget.name,
      'email': widget.email,
      'phone_number': widget.phoneNumber,
      'street_name': widget.streetName,
      'country': widget.country,
      'payment_method': widget.paymentMethod,
      'shipping_type': widget.shippingOption,
      'shop_id': widget.shopId,
      'shop_address': widget.shopLocation,
      'reference': widget.reference,
      'amount': widget.amount,
      'products': itemsData,
      'quantity': widget.quantity,
      'user_id': id,
    };

    final apiEndpoint = dotenv.env['API_KEY'];
    final apiUrl = '${apiEndpoint}/pay';
    final response = await http.post(Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode(requestData));

    print('From success page => ${response.body}');
    if (response.statusCode == 200) {
      CartProvider myCartProvider = CartProvider();
      print("myCartProvider => $myCartProvider");
      myCartProvider.deleteCartItems();
      return 'success';
    }
    return 'not success';
  }

  //retrieve name from localstorage
  Future<int>? retrieveId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');
    return id!;
  }

  // Clear total price from localstorage
  void clearTotalPrice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("totalPrice");
  }

  @override
  Widget build(BuildContext context) {
    // Screen width
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white
        ),
        child: FutureBuilder<String>(
            future: _data,
            builder: (context, snapshot) {
              print('Snapshot => ${snapshot}');
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Center(
                  child: Container(
                    height: screenHeight * 0.6,
                    width: screenWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 200,
                          width: 200,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('images/correct.png'))),
                        ),

                        const SizedBox(height: 20),
                        const Text("Success!",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500)
                        ),

                        const SizedBox(height: 15),
                        const Text("Your order will be delivered soon.\n Thank you for choosing our app",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)
                        ),

                        const SizedBox(height: 60),
                        GestureDetector(
                          onTap: () {
                            cart.resetCounter();
                            cart.deleteCartItems();
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: const HomePageNew(),
                              withNavBar: false, // OPTIONAL VALUE. True by default.
                              pageTransitionAnimation: PageTransitionAnimation.cupertino,
                            );
                          },
                          child: Container(
                            width: screenWidth,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                                color: const Color(0xFFED294D),
                                borderRadius: BorderRadius.circular(15)),
                            child: const Text('Continue Shopping',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white)),
                          ),
                        )
                      ],
                    ),
                  )

                );

              }
            }),
      )

    );
  }
}
