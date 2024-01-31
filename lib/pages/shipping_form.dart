import 'package:flutter/material.dart';
import 'package:shop_app/model/formModel.dart';
import 'package:shop_app/pages/cart_page.dart';
import 'package:shop_app/viewModel/formsVM.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/pages/checkout_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShippingFormPage extends StatefulWidget {
  dynamic username;
  dynamic useremail;
  ShippingFormPage({required this.username, required this.useremail});

  @override
  State<ShippingFormPage> createState() => _ShippingFormPageState();
}

class _ShippingFormPageState extends State<ShippingFormPage> {
  // Input Values
  TextEditingController _emailValue = TextEditingController();
  TextEditingController _nameValue = TextEditingController();
  final _phoneValue = TextEditingController();
  final _streetValue = TextEditingController();
  final _countryValue = TextEditingController();

  // Radio button value
  String groupValue = "Mobile Money";

  // Variable to store the selected value
  String selectedValue = 'Same-day-delivery';
  double deliveryFee = 10.00;

  // Form Key
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _emailValue.text = widget.useremail;
    _nameValue.text = widget.username;
    _countryValue.text = "Ghana";

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0.5,
        centerTitle: true,
        title: const Text("Delivery Info", style: TextStyle(fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF545D68)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: [
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              margin: const EdgeInsets.only(bottom: 30),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 20, top: 10),
                          child: const Text("Contact Details",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                        )
                      ],
                    ),

                    // Email Input
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text("Email Address",
                                style: TextStyle(fontWeight: FontWeight.w500)),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[500],
                            ),
                            child: TextFormField(
                              controller: _emailValue,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a valid email address';
                                }
                                final bool emailValid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value);
                                if (!emailValid) {
                                  return 'Field is required';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white70,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Name Input
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text("Name",
                                style: TextStyle(fontWeight: FontWeight.w500)),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[500],
                            ),
                            child: TextFormField(
                              controller: _nameValue,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Field is required';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white70,
                                  border: InputBorder.none),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Phone Input
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text("Phone Number",
                                style: TextStyle(fontWeight: FontWeight.w500)),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[500],
                            ),
                            child: TextFormField(
                              controller: _phoneValue,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Field is required';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  filled: true,
                                  fillColor: Colors.white70,
                                  border: InputBorder.none),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Shipping Details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 20, top: 5),
                          child: const Text("Shipping Details",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                        )
                      ],
                    ),

                    // Shipping Type
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text("Delivery Cost",
                              style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5)),
                      width: screenWidth,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          items: const [
                            DropdownMenuItem(
                                value: "Same-day-delivery",
                                child: Text("Same-day-delivery - GHC 10.00",
                                    style:
                                    TextStyle(fontWeight: FontWeight.w400))),
                            DropdownMenuItem(
                                value: "2-day Delivery",
                                child: Text("2-day Delivery - GHC 5.00",
                                    style:
                                    TextStyle(fontWeight: FontWeight.w400))),
                          ],
                          value: selectedValue,
                          onChanged: (String? value) {
                            setState(() {
                              selectedValue = value!;
                              if (selectedValue == "Same-day-delivery") {
                                deliveryFee = 10.00;
                              } else {
                                deliveryFee = 5.00;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    // Address
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text("Address",
                                style: TextStyle(fontWeight: FontWeight.w600)),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[500],
                            ),
                            child: TextFormField(
                              controller: _streetValue,
                              maxLines: 3,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Field is required';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white70,
                                  border: InputBorder.none),
                            ),
                          )
                        ],
                      ),
                    ),

                    // Country / Region
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text("Country/Region",
                                style: TextStyle(fontWeight: FontWeight.w600)),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[500],
                            ),
                            child: TextFormField(
                              controller: _countryValue,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Field is required';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white70,
                                  border: InputBorder.none),
                            ),
                          )
                        ],
                      ),
                    ),

                    // Button
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(10),
                          primary: const Color(0xFFED294D),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0)),
                        ),
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            // Get the form data from the input fields
                            FormData data = FormData(
                              name: _nameValue.text,
                              email: _emailValue.text,
                              phoneNumber: _phoneValue.text,
                              streetName: _streetValue.text,
                              country: _countryValue.text,
                              paymentMethod: groupValue,
                              shippingOption: selectedValue,
                              deliveryFee: deliveryFee,
                            );

                            // Save the form data using the provider
                            Provider.of<FormDataModel>(context, listen: false)
                                .saveFormData(data);
                            Navigator.push(
                                context,
                                // MaterialPageRoute(builder: (context) => const ProductDetails()),
                                PageRouteBuilder(
                                    transitionDuration:
                                    const Duration(milliseconds: 400),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      const begin = Offset(-1.0,
                                          0.0); // Start off the screen to the left
                                      const end = Offset.zero;
                                      var tween = Tween(begin: begin, end: end);
                                      var offsetAnimation =
                                      animation.drive(tween);

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
                                      return const CheckoutPage();
                                    }));
                          } else {
                            print("Fields required");
                          }
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Proceed',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
