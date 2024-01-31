import 'package:flutter/material.dart';
import 'package:shop_app/pages/admin/orders_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

class OrderProfilePage extends StatefulWidget {
  const OrderProfilePage({super.key, required this.id});
  final int id;

  @override
  State<OrderProfilePage> createState() => _OrderProfilePageState();
}

class _OrderProfilePageState extends State<OrderProfilePage> {
  Map orders = {};
  late String orderId;
  late String noteMessage = '';
  bool loading = false;
  // Form Key
  final _formkey = GlobalKey<FormState>();

  // Input Values
  final _orderNote = TextEditingController();

  // Variable to store the selected value
  String selectedValue = 'Pending';

  // List of items for the dropdown
  List<String> items = ['Pending','Processing', 'Out for delivery', 'Delivered'];

  //retrieve token
  Future<String?> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retrieve the token
    String? token = prefs.getString('token');
    return token;
  }

  // Fetch products
   Future<void> fetchData(int? id) async {
    String? token = await retrieveToken();

    final apiEndpoint = dotenv.env['API_KEY'];
    final url = '${apiEndpoint}/orders/$id';
    final headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(Uri.parse(url), headers: headers);
    final decodedData = jsonDecode(response.body);
    if (decodedData['status'] == 200) {
      final data = decodedData;
      print(data);
       setState(() {
        noteMessage = data['order']['notes'] ?? '';
        orderId = data['order']['order_id'].toString();
        orders = data;
      });
       // print(orders['products'].length);
    } else {
      setState(() {
        orders = {};
      });
    }
  }

  // Success Toast Alerts
  void showSuccessToast(msg) {
    toastification.show(
        context: context,
        title: '$msg',
        autoCloseDuration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white);
  }

  // Error Toast Alerts
  void showErrorToast(msg) {
    toastification.show(
        context: context,
        title: '$msg',
        autoCloseDuration: const Duration(seconds: 2),
        backgroundColor: Colors.redAccent[200],
        foregroundColor: Colors.white);
  }

  // Redirect to HomePage Function
  void redirectOrdersPage() {
    Navigator.push(
        context,
        // MaterialPageRoute(builder: (context) => const ProductDetails()),
        PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
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
            pageBuilder: (context, animation, secondaryAnimation) {
              return const OrdersPage();
            }));
  }

  // Send Status Notification
  Future<void> sendStatusMessage() async {
    // print('Status => ${selectedValue}');
    // print('Notes => ${_orderNote.text}');
    // print('OrderId = ${orderId}');

    setState(() {
      loading = true;
    });

    // Get token
    String? token = await retrieveToken();
    Map<String, dynamic> bodyData = {
      'status': selectedValue,
      'notes': _orderNote.text,
      'order_id': orderId
    };
    final apiEndpoint = dotenv.env['API_KEY'];
    final uri = Uri.parse("${apiEndpoint}/shop/order/update");
    try {
      // Response
      final response = await http.post(
        uri,
        body: bodyData,
        headers: {'Authorization': 'Bearer $token'}
      );

      final data = jsonDecode(response.body);
      // print(data);
      if (data['status'] == 200) {
        setState(() {
          loading = false;
        });

        // Clear Input values
        _orderNote.clear();
        showSuccessToast('${data['message']}');
        Future.delayed(const Duration(milliseconds: 3000), redirectOrdersPage);
      } else {
        showErrorToast("Something went wrong!");
        setState(() {
          loading = false;
        });
      }
    } catch (error) {
      print(error);
      showErrorToast("Something went wrong!");
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(widget.id);
  }

  @override
  Widget build(BuildContext context) {
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
        body: orders.isNotEmpty ?
            Container(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [

                        // Customer Card
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Column(
                              children: [

                                // Title
                                Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    height: 60,
                                    width: double.infinity,
                                    decoration:  BoxDecoration(
                                      color: Colors.grey.shade50,
                                    ),
                                    child: const Padding(
                                        padding: EdgeInsets.only(top: 20),
                                        child:  Text("Customer Details", textAlign: TextAlign.center, style: TextStyle(fontSize: 15),)
                                    )
                                ),



                                // Customer Name
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  height: 60,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Customer Name : "),
                                      Text("${orders['order']['customer_name']}")
                                    ],
                                  ),
                                ),

                                // Email Address
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  height: 60,
                                  decoration:  BoxDecoration(
                                    color: Colors.grey.shade50,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Email Address : "),
                                      Text("${orders['order']['email']}")
                                    ],
                                  ),
                                ),

                                // Contact
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  height: 60,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Phone Number : "),
                                      Text("${orders['order']['phone_number']}")
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Order Card
                        const SizedBox(height: 30),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Column(

                              children: [

                                // Title
                                Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    height: 60,
                                    width: double.infinity,
                                    decoration:  BoxDecoration(
                                      color: Colors.grey.shade50,
                                    ),
                                    child: const Padding(
                                        padding: EdgeInsets.only(top: 20),
                                        child:  Text("Order Details", textAlign: TextAlign.center, style: TextStyle(fontSize: 15),)
                                    )
                                ),

                                // Ordrer ID
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  height: 60,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Order ID : "),
                                      Text("${orders['order']['order_id']}")
                                    ],
                                  ),
                                ),

                                // Order Address
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  height: 60,
                                  decoration:  BoxDecoration(
                                    color: Colors.grey.shade50,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Order Address : "),
                                      Text("${orders['shipping']['dropoff_address']}")
                                    ],
                                  ),
                                ),

                                // Payment Method
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  height: 60,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Payment Method : "),
                                      Text("${orders['payment']['method']}")
                                    ],
                                  ),
                                ),

                                // Shipping Type
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  height: 60,
                                  decoration:  BoxDecoration(
                                    color: Colors.grey.shade50,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Shipping Type : "),
                                      // Text("${orders['shipping']['shipping_type'].substring(1, orders['shipping']['shipping_type'].length - 1)}")
                                      Text("${orders['shipping']['shipping_type']}")
                                    ],
                                  ),
                                ),

                                // Order Date
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  height: 60,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Order Date : "),
                                      Text(
                                          DateFormat('MMM d, y - HH:mm a').format(DateTime.parse('${orders['order']['created_at']}').toLocal()).toString()
                                        // DateTime.parse('${orders['order']['created_at']}').toLocal().toString()
                                      )
                                    ],
                                  ),
                                ),

                                // Delivery
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  height: 60,
                                  decoration:  BoxDecoration(
                                    color: Colors.grey.shade50,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Delivery Date : "),
                                      Text("${orders['shipping']['dropoff_date']}")
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Product Card
                        const SizedBox(height: 30),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                // Title
                                Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    height: 60,
                                    width: double.infinity,
                                    decoration:  BoxDecoration(
                                      color: Colors.grey.shade50,
                                    ),
                                    child: const Padding(
                                        padding: EdgeInsets.only(top: 20),
                                        child:  Text("Ordered Products", textAlign: TextAlign.center, style: TextStyle(fontSize: 15),)
                                    )
                                ),

                                // Product
                                ListView.builder(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: orders['products'] != null ? orders['products'].length : 0,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      height: 75,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [

                                          // Product Image
                                          Container(
                                            margin: const EdgeInsets.only(right: 15),
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(image: NetworkImage('${orders['products'][index]['product']['image_url']}'), fit: BoxFit.cover),
                                            ),
                                          ),

                                          Container(
                                            margin: const EdgeInsets.only(top: 10),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text("#0000${orders['products'][index]['product']['id']}", style: const TextStyle(fontSize: 12)),
                                                Text("${orders['products'][index]['product']['name']}", style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
                                                Text("GHC ${orders['products'][index]['product']['price']}", style: const TextStyle(fontSize: 12),)
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    );
                                  },
                                ),

                              ],
                            ),
                          ),
                        ),

                        // Notes Card
                        const SizedBox(height: 30),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    height: 60,
                                    width: double.infinity,
                                    decoration:  BoxDecoration(
                                      color: Colors.grey.shade50,
                                    ),
                                    child: const Padding(
                                        padding: EdgeInsets.only(top: 20),
                                        child:  Text("Notes", textAlign: TextAlign.center, style: TextStyle(fontSize: 15),)
                                    )
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  height: 60,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(noteMessage == '' ? 'No Notes Yet' : noteMessage),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Status Card
                        const SizedBox(height: 30),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Column(
                              children: [

                                // Title
                                Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    height: 60,
                                    width: double.infinity,
                                    decoration:  BoxDecoration(
                                      color: Colors.grey.shade50,
                                    ),
                                    child: const Padding(
                                        padding: EdgeInsets.only(top: 20),
                                        child:  Text("Status", textAlign: TextAlign.center, style: TextStyle(fontSize: 15),)
                                    )
                                ),

                                // Product
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Form(
                                        key: _formkey,
                                        child: Column(
                                          children: [
                                            // Status
                                            const Padding(
                                              padding: EdgeInsets.only(top: 10, bottom: 5),
                                              child:  Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text("Order Status")
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.black),
                                                  borderRadius: BorderRadius.circular(5)
                                              ),
                                              width: screenWidth,
                                              child: DropdownButtonHideUnderline(
                                                child: DropdownButton(
                                                  items: const[
                                                    DropdownMenuItem(value: "Pending",child: Text("Pending", style: TextStyle(fontWeight: FontWeight.w400))),
                                                    DropdownMenuItem(value: "Processing",child: Text("Processing", style: TextStyle(fontWeight: FontWeight.w400))),
                                                    DropdownMenuItem(value: "Out for delivery",child: Text("Out for delivery", style: TextStyle(fontWeight: FontWeight.w400))),
                                                    DropdownMenuItem(value: "Delivered",child: Text("Delivered", style: TextStyle(fontWeight: FontWeight.w400))),
                                                  ],
                                                  value: selectedValue,
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      selectedValue = value!;
                                                    });
                                                  },
                                                ),
                                              ),

                                            ),

                                            // Order Note
                                            const Padding(
                                              padding: EdgeInsets.only(top: 10, bottom: 5),
                                              child:  Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text("Order Note")
                                                ],
                                              ),
                                            ),
                                            TextFormField(
                                              controller: _orderNote,
                                              maxLines: 3,
                                              validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                  return 'Please enter message';
                                                }
                                                return null;
                                              },
                                              decoration: const InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white70,
                                                  border: OutlineInputBorder()),
                                            ),

                                            // Send Msg
                                            GestureDetector(
                                              onTap: () {
                                                if (_formkey.currentState!.validate()) {
                                                  sendStatusMessage();
                                                }
                                              },
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets.only(top: 10),
                                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                    decoration: const BoxDecoration(
                                                        color: Color(0xFF7386EF)
                                                    ),
                                                    child: loading == true ?
                                                    const Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 4)):
                                                    const Center(
                                                      child: Text("Send Message",
                                                          style: TextStyle(color: Colors.white)),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            ) :
            const Center(
              child: CircularProgressIndicator(),
            )
          );
  }
}
