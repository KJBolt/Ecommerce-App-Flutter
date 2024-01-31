// import 'package:flutter/material.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:country_picker/country_picker.dart';
// import 'package:shop_app/pages/cart_page.dart';
// import 'package:shop_app/pages/payment_page.dart';
// import 'package:shop_app/model/formModel.dart';
// import 'package:shop_app/viewModel/formsVM.dart';
// import 'package:provider/provider.dart';

// class ShippingPage extends StatefulWidget {
//   const ShippingPage({super.key});

//   @override
//   State<ShippingPage> createState() => _ShippingPageState();
// }

// class _ShippingPageState extends State<ShippingPage> {
//   //Input controllers from form
//   final _firstName = TextEditingController();
//   final _lastName = TextEditingController();
//   final _address = TextEditingController();
//   final _country = TextEditingController();
//   final _city = TextEditingController();
//   final _phone = TextEditingController();
//   final _postalCode = TextEditingController();

  
//   //page Ui
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0.0,
//         centerTitle: true,
//         title: const Text("Shipping Address", style: TextStyle(fontSize: 18)),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Color(0xFF545D68)),
//           onPressed: () {
//             Navigator.push(
//                 context,
//                 // MaterialPageRoute(builder: (context) => const ProductDetails()),
//                 PageRouteBuilder(
//                     transitionDuration: const Duration(milliseconds: 400),
//                     transitionsBuilder:
//                         (context, animation, secondaryAnimation, child) {
//                       const begin =
//                           Offset(-1.0, 0.0); // Start off the screen to the left
//                       const end = Offset.zero;
//                       var tween = Tween(begin: begin, end: end);
//                       var offsetAnimation = animation.drive(tween);

//                       return SlideTransition(
//                         position: offsetAnimation,
//                         child: FadeTransition(
//                           opacity: animation,
//                           child: child,
//                         ),
//                       );
//                     },
//                     pageBuilder: (context, animation, secondaryAnimation) {
//                       return const CartPage();
//                     }));
//           },
//         ),
//         actions: <Widget>[
//           IconButton(
//             icon:
//                 const Icon(Icons.notifications_none, color: Color(0xFF545D68)),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: ListView(
//         children: [
//           Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//               child: Column(
//                 children: [
//                   // Process
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 10),
//                     margin: const EdgeInsets.only(bottom: 30),
//                     // decoration: const BoxDecoration(border: Border.fromBorderSide(BorderSide(color: Colors.black12))),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         // Shipping
//                         Row(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(2),
//                               decoration: BoxDecoration(
//                                 color: Colors.green,
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: const Icon(Icons.done,
//                                   size: 15, color: Colors.white),
//                             ),
//                             Container(
//                               margin: const EdgeInsets.only(left: 5),
//                               child: const Text("Shipping",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: 16)),
//                             ),
//                           ],
//                         ),

//                         // Payment
//                         Row(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(2),
//                               decoration: BoxDecoration(
//                                 color: Colors.grey,
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: const Icon(Icons.done,
//                                   size: 15, color: Colors.white),
//                             ),
//                             Container(
//                               margin: const EdgeInsets.only(left: 5),
//                               child: const Text("Payment"),
//                             ),
//                           ],
//                         ),

//                         // Review
//                         Row(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(2),
//                               decoration: BoxDecoration(
//                                 color: Colors.grey,
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: const Icon(Icons.done,
//                                   size: 15, color: Colors.white),
//                             ),
//                             Container(
//                               margin: const EdgeInsets.only(left: 5),
//                               child: const Text("Review"),
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),

//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: TextFormField(
//                       controller: _firstName,
//                       decoration: const InputDecoration(
//                         contentPadding:
//                             EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.black87),
//                         ),
//                         focusColor: Colors.blueAccent,
//                         hintText: 'Firstname',
//                       ),
//                     ),
//                   ),

//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: TextFormField(
//                       controller: _lastName,
//                       decoration: const InputDecoration(
//                         contentPadding:
//                             EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.black87),
//                         ),
//                         focusColor: Colors.blueAccent,
//                         hintText: 'Lastname',
//                       ),
//                     ),
//                   ),

//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: TextFormField(
//                       controller: _address,
//                       decoration: const InputDecoration(
//                         contentPadding:
//                             EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.black87),
//                         ),
//                         focusColor: Colors.blueAccent,
//                         hintText: 'Address',
//                       ),
//                     ),
//                   ),

//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: TextFormField(
//                       controller: _country,
//                       decoration: const InputDecoration(
//                         contentPadding:
//                             EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.black87),
//                         ),
//                         focusColor: Colors.blueAccent,
//                         hintText: 'Country',
//                       ),
//                     ),
//                   ),

//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: TextFormField(
//                       controller: _city,
//                       decoration: const InputDecoration(
//                         contentPadding:
//                             EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.black87),
//                         ),
//                         focusColor: Colors.blueAccent,
//                         hintText: 'City',
//                       ),
//                     ),
//                   ),

//                   IntlPhoneField(
//                     controller: _phone,
//                     decoration: const InputDecoration(
//                       contentPadding:
//                           EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
//                       labelText: 'Phone Number',
//                       border: OutlineInputBorder(
//                         borderSide: BorderSide(),
//                       ),
//                     ),
//                     languageCode: "en",
//                     onChanged: (phone) {
//                       // print(phone.completeNumber);
//                     },
//                     onCountryChanged: (country) {
//                       // print('Country changed to: ' + country.name);
//                     },
//                   ),

//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: TextFormField(
//                       controller: _postalCode,
//                       decoration: const InputDecoration(
//                         contentPadding:
//                             EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
//                         border: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.black87),
//                         ),
//                         focusColor: Colors.blueAccent,
//                         hintText: 'Postal Code',
//                       ),
//                     ),
//                   ),

//                   GestureDetector(
//                     onTap: () {

//                       // Navigator.push(
//                           // context,
//                           // MaterialPageRoute(builder: (context) => const ProductDetails()),
//                           // PageRouteBuilder(
//                           //     transitionDuration:
//                           //         const Duration(milliseconds: 400),
//                           //     transitionsBuilder: (context, animation,
//                           //         secondaryAnimation, child) {
//                           //       const begin = Offset(-1.0,
//                           //           0.0); // Start off the screen to the left
//                           //       const end = Offset.zero;
//                           //       var tween = Tween(begin: begin, end: end);
//                           //       var offsetAnimation = animation.drive(tween);

//                           //       return SlideTransition(
//                           //         position: offsetAnimation,
//                           //         child: FadeTransition(
//                           //           opacity: animation,
//                           //           child: child,
//                           //         ),
//                           //       );
//                           //     },
//                           //     pageBuilder:
//                           //         (context, animation, secondaryAnimation) {
//                           //       return const PaymentPage();
//                           //     }));
//                     },
//                     child: Container(
//                       width: screenWidth,
//                       margin: const EdgeInsets.only(top: 10),
//                       padding: const EdgeInsets.symmetric(vertical: 15),
//                       decoration: BoxDecoration(
//                           color: Colors.blueAccent,
//                           borderRadius: BorderRadius.circular(10)),
//                       child: const Text('Confirm and continue',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(color: Colors.white)),
//                     ),
//                   )
//                 ],
//               ))
//         ],
//       ),
//     );
//   }
// }
