import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/pages/admin/order_profile.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  //retrieve token
  Future<String?> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retrieve the token
    String? token = prefs.getString('token');
    return token;
  }

  //retrieve name from localstorage
  Future<int>? retrieveId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('shop_id');
    return id!;
  }

  // Fetch products
  Future<Map<String, dynamic>> fetchData() async {
    String? token = await retrieveToken();
    int? shopId = await retrieveId();

    final apiEndpoint = dotenv.env['API_KEY'];
    final url = '${apiEndpoint}/shop/${shopId}/orders';
    final headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(Uri.parse(url), headers: headers);
    final decodedData = jsonDecode(response.body);
    if (decodedData['status'] == 200) {
      final data = decodedData;
      return data;
    } else {
      const data = {'message': 'failed'};
      return data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          title: const Text("Orders", style: TextStyle(fontSize: 18)),
        ),
        body: FutureBuilder(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                if (snapshot.data?['orders'].length == 0) {
                  return const Center(
                    child: Text("No orders yet!", style: TextStyle(fontSize: 16)),
                  );
                } else {
                  final data = snapshot.data;
                  final orders = data!['orders'];
                  return Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: orders.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  // MaterialPageRoute(builder: (context) => const ProductDetails()),
                                  PageRouteBuilder(
                                      transitionDuration:
                                      const Duration(milliseconds: 400),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
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
                                      pageBuilder:
                                          (context, animation, secondaryAnimation) {
                                        return OrderProfilePage(id:orders[index]['id'],);
                                      })
                                );
                              },
                              child:  Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Column(
                                    children: [
                                      // Order Details 1
                                      Container(
                                        margin: const EdgeInsets.only(bottom: 15),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 1,
                                              blurRadius: 2,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            // Order Id and Date
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "Order No ${orders[index]['order_id']}",
                                                    style: const TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 16,
                                                        color: Color(0xFF7386EF)
                                                    ),
                                                  ),
                                                  Text(DateFormat('yyyy-MM-dd').format(
                                                      DateTime.parse(
                                                          orders[index]['created_at'])))
                                                ],
                                              ),
                                            ),

                                            // Tracking Number
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 5),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.only(right: 10),
                                                    child: const Text("Tracking No:"),
                                                  ),
                                                  Text(orders[index]['order_id'],
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.w500)),
                                                ],
                                              ),
                                            ),

                                            // Quantity and Amount
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        margin:
                                                        const EdgeInsets.only(right: 10),
                                                        child: const Text("Quantity:"),
                                                      ),
                                                      Text(orders[index]['quantity'],
                                                          style: const TextStyle(
                                                              fontWeight: FontWeight.w500)),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        margin:
                                                        const EdgeInsets.only(right: 10),
                                                        child: const Text("Amount:"),
                                                      ),
                                                      Text('GHC ${orders[index]['payment']['amount']}.00' ?? "",
                                                          style: const TextStyle(
                                                              fontWeight: FontWeight.w500)),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),

                                            // Details & Delivered
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                  decoration: BoxDecoration(
                                                      color: const Color(0xFF7386EF),
                                                      borderRadius: BorderRadius.circular(10)
                                                  ),
                                                  child: const Text('Edit Order', style: TextStyle(color: Colors.white),),
                                                ),
                                                Text("${orders[index]['status']}",
                                                  style: orders[index]['status'] == 'Processing' ? const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w500) : orders[index]['status'] == 'Out for delivery' ? const TextStyle(color: Colors.green, fontWeight: FontWeight.w500) : const TextStyle(color: Color(0xFFDAC507), fontWeight: FontWeight.w500)
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                            );


                          })
                  );
                  // return ListView.builder(
                  //   scrollDirection: Axis.vertical,
                  //   shrinkWrap: true,
                  //   itemCount: orders != null ? orders.length : 0, // loops through the array ang get the array length
                  //   itemBuilder: (context, index) {
                  //     return GestureDetector(
                  //       onTap: () {
                  //         Navigator.push(
                  //             context,
                  //             // MaterialPageRoute(builder: (context) => const ProductDetails()),
                  //             PageRouteBuilder(
                  //                 transitionDuration:
                  //                 const Duration(milliseconds: 400),
                  //                 transitionsBuilder: (context, animation,
                  //                     secondaryAnimation, child) {
                  //                   const begin = Offset(-1.0, 0.0);
                  //                   const end = Offset.zero;
                  //                   var tween = Tween(begin: begin, end: end);
                  //                   var offsetAnimation = animation.drive(tween);
                  //
                  //                   return SlideTransition(
                  //                     position: offsetAnimation,
                  //                     child: FadeTransition(
                  //                       opacity: animation,
                  //                       child: child,
                  //                     ),
                  //                   );
                  //                 },
                  //                 pageBuilder:
                  //                     (context, animation, secondaryAnimation) {
                  //                   return OrderProfilePage(id:orders[index]['id'],);
                  //                 }));
                  //       },
                  //       child: Container(
                  //         margin: const EdgeInsets.symmetric(
                  //             horizontal: 10, vertical: 8),
                  //         child: Column(
                  //           children: [
                  //             Container(
                  //               padding: const EdgeInsets.symmetric(
                  //                   vertical: 15, horizontal: 10),
                  //               decoration: BoxDecoration(
                  //                 color: Colors.white,
                  //                 borderRadius: BorderRadius.circular(10),
                  //                 boxShadow: [
                  //                   BoxShadow(
                  //                     color: Colors.grey.withOpacity(0.6),
                  //                     spreadRadius: 1,
                  //                     blurRadius: 2,
                  //                     offset: const Offset(0, 1),
                  //                   ),
                  //                 ],
                  //                 // border: Border.all(
                  //                 //     color: Colors.green, width: 2)
                  //               ),
                  //               child: Row(
                  //                 mainAxisAlignment:
                  //                 MainAxisAlignment.spaceBetween,
                  //                 children: [
                  //                   // Left Content
                  //                   Column(
                  //                     mainAxisAlignment: MainAxisAlignment.start,
                  //                     crossAxisAlignment:
                  //                     CrossAxisAlignment.start,
                  //                     children: [
                  //                       Text(
                  //                           "Order No ${orders[index]['order_id']}",
                  //                           style: const TextStyle(
                  //                               fontSize: 15,
                  //                               fontWeight: FontWeight.w500)),
                  //                       Text(
                  //                           "${orders[index]['customer_name']} . ${orders[index]['email']}"),
                  //                     ],
                  //                   ),
                  //
                  //                   // Right Content
                  //                   Container(
                  //                     padding: const EdgeInsets.all(5),
                  //                     decoration: BoxDecoration(
                  //                         borderRadius: BorderRadius.circular(10),
                  //                         color: Colors.black),
                  //                     child: Text(
                  //                         "Ghc ${orders[index]['payment']['amount']}",
                  //                         style: const TextStyle(
                  //                             color: Colors.white, fontSize: 12)),
                  //                   )
                  //                 ],
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // );
                }
              } else {
                return const Center(
                  child: Text("No orders yet!"),
                );
              }
            }));
  }
}
