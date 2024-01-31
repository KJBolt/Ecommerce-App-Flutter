import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

import '../pages/admin/order_profile.dart';
import '../pages/order_profile_user.dart';

class DeliveredTab extends StatefulWidget {
  const DeliveredTab({super.key});

  @override
  State<DeliveredTab> createState() => _DeliveredTabState();
}

class _DeliveredTabState extends State<DeliveredTab> {

  //retrieve token
  Future<String?> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retrieve the token
    String? token = prefs.getString('token');
    return token;
  }

  // Fetch orders
  Future<Map<String, dynamic>> fetchData() async {
    String? token = await retrieveToken();
    final apiEndpoint = dotenv.env['API_KEY'];
    final url = '${apiEndpoint}/orders';
    final headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(Uri.parse(url), headers: headers);
    final decodedData = jsonDecode(response.body);
    // print(decodedData);
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
      body: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          // If request is loading show loading animation
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );

          }

          else if (snapshot.data?['message'] == 'failed') {
            return Container(
              color: Colors.white,
              child: const Center(
                child: Text("No orders to display", style: TextStyle(fontSize: 18),)
              ),
            );
          }

          else if(snapshot.data == null) {
            return Container(
              color: Colors.white,
              child: const Center(
                  child: Text("No orders to display", style: TextStyle(fontSize: 18),)
              ),
            );
          }
         else {
            final data = snapshot.data;
            final orders = data != null ? data['orders'] : null;
            int ordersCount = 0;
            if(orders != null){
              ordersCount = orders.length;
            }
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: ordersCount,
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
                                  return OrderProfileUserPage(id:orders[index]['id'],);
                                })
                        );
                      },
                      child: Container(
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
                                                color: Color(0xFFED294D)
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
                                              Text('GHC ${orders[index]['payment']['amount']}' ?? "",
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
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFED294D),
                                            borderRadius: BorderRadius.circular(5)
                                          ),
                                            child: const Center(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 10),
                                                child: Text("View Order", style: TextStyle(color: Colors.white)),
                                              ),
                                            )
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
          }
        },
      ),
    );
  }
}
