import 'package:flutter/material.dart';
import 'package:shop_app/pages/admin/add_product.dart';
import 'package:toastification/toastification.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shop_app/pages/admin/edit_product.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {

  @override
  void initState() {
    super.initState();
    fetchData(); // Call the fetchData function when the page loads
  }

  // Map products = {};
  bool loading = false;

  //retrieve token
  Future<String?> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retrieve the token
    String? token = prefs.getString('token');
    return token;
  }

  //retrieve token
  Future<String?> retrieveShopName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retrieve the token
    String? shopName = prefs.getString('shop_name');
    return shopName;
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
  void redirectProductsPage() {
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
              return const ProductsPage();
            }));
  }

  // Fetch products
  Future<Map<String, dynamic>> fetchData() async {
    loading = true;
    String? token = await retrieveToken();
    String? shop_name = await retrieveShopName();

    final apiEndpoint = dotenv.env['API_KEY'];
    final url = '${apiEndpoint}/products/$shop_name';
    final headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(Uri.parse(url), headers: headers);
    final decodedData = jsonDecode(response.body);
    if (decodedData['status'] == 200) {
      loading = false;
      final data = decodedData;
      return data;
    } else {
      const data = {'message': 'failed'};
      return data;
    }
  }

  // Delete Product
  Future<void> deleteProduct(int? id) async {
    String? token = await retrieveToken();
    final apiEndpoint = dotenv.env['API_KEY'];
    final url = '${apiEndpoint}/product';
    final headers = {'Authorization': 'Bearer $token'};
    final response = await http.delete(Uri.parse('$url/$id'), headers: headers);
    redirectProductsPage();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          actions: [
            // Add Product Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          // MaterialPageRoute(builder: (context) => const ProductDetails()),
                          PageRouteBuilder(
                              transitionDuration: const Duration(
                                  milliseconds: 400),
                              transitionsBuilder: (context,
                                  animation,
                                  secondaryAnimation,
                                  child) {
                                const begin = Offset(-1.0,
                                    0.0); // Start off the screen to the left
                                const end = Offset.zero;
                                var tween =
                                Tween(begin: begin, end: end);
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
                              pageBuilder: (context, animation,
                                  secondaryAnimation) {
                                return const AddProductPage();
                              }));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(color: Colors.black),
                          borderRadius:
                          BorderRadius.circular(10)),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          Text(
                            "New Product",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        body: Container(
          height: screenHeight,
          width: screenWidth,
          child: FutureBuilder(
              future: fetchData(),
              builder: (context, snapshot) {
                // If request is loading show loading animation
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData) {
                  if (snapshot.data?['products']?.length == 0) {
                    return const Center(
                      child: Text("No Products", style: TextStyle(fontSize: 16)),
                    );
                  } else {
                    final data = snapshot.data;
                    final products = data!['products'];
                    return ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              // Product Card
                              Container(
                                height: 590,
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: products != null ? products.length : 0, // loops through the array ang get the array length
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 1,
                                              blurRadius: 2,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            topLeft: Radius.circular(20),
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                          ),
                                        ),
                                        margin: const EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            // Image
                                            Stack(
                                              children: [
                                                Container(
                                                  height: 120,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: NetworkImage('${products[index]['image_url']}'),
                                                          fit: BoxFit.cover)),
                                                ),
                                              ],
                                            ),

                                            // Product Details
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              decoration: const BoxDecoration(),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                                children: [
                                                  Text("#0000${products[index]['id']}",
                                                      style: const TextStyle(
                                                          fontSize: 12)
                                                  ),
                                                  Text("${products[index]['name']}",
                                                      style: const TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                          FontWeight.w500)
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text(
                                                          "GHC ${products[index]['price']}", style: const TextStyle(fontSize: 12)),
                                                      Row(
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  // MaterialPageRoute(builder: (context) => const ProductDetails()),
                                                                  PageRouteBuilder(
                                                                      transitionDuration:
                                                                      const Duration(
                                                                          milliseconds:
                                                                          400),
                                                                      transitionsBuilder: (context,
                                                                          animation,
                                                                          secondaryAnimation,
                                                                          child) {
                                                                        const begin =
                                                                        Offset(
                                                                            -1.0,
                                                                            0.0);
                                                                        const end =
                                                                            Offset
                                                                                .zero;
                                                                        var tween = Tween(
                                                                            begin:
                                                                            begin,
                                                                            end:
                                                                            end);
                                                                        var offsetAnimation =
                                                                        animation
                                                                            .drive(tween);

                                                                        return SlideTransition(
                                                                          position:
                                                                          offsetAnimation,
                                                                          child:
                                                                          FadeTransition(
                                                                            opacity:
                                                                            animation,
                                                                            child:
                                                                            child,
                                                                          ),
                                                                        );
                                                                      },
                                                                      pageBuilder: (context,
                                                                          animation,
                                                                          secondaryAnimation) {
                                                                        return EditProductPage(
                                                                            id: products[index]
                                                                            [
                                                                            'id']);
                                                                      }));
                                                            },
                                                            child: const Icon(
                                                              Icons.edit,
                                                              color: Colors.green,
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              // Delete logic here
                                                              showDialog(
                                                                context: context,
                                                                builder:
                                                                    (BuildContext
                                                                context) {
                                                                  // Alert Popup for delete icon
                                                                  return AlertDialog(
                                                                    title: const Text(
                                                                        'Delete Product'),
                                                                    content: const Text(
                                                                        'Are you sure you want to delete this product.'),
                                                                    actions: <Widget>[
                                                                      TextButton(
                                                                        child: const Text(
                                                                            'Delete',
                                                                            style: TextStyle(
                                                                                color:
                                                                                Colors.redAccent)),
                                                                        onPressed:
                                                                            () {
                                                                          //Delete logic here
                                                                          deleteProduct(
                                                                              products[index]
                                                                              [
                                                                              'id']);
                                                                          Navigator.of(
                                                                              context)
                                                                              .pop();
                                                                        },
                                                                      ),
                                                                      TextButton(
                                                                        child: const Text(
                                                                            'Cancel'),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(
                                                                              context)
                                                                              .pop(); // Close the dialog
                                                                        },
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            child: const Icon(
                                                              Icons.delete_outline,
                                                              color:
                                                              Colors.redAccent,
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  }
                } else {
                  return const Center(
                    child: Text("No Products", style: TextStyle(fontSize: 16)),
                  );
                }
              }),
        ),

    );
  }
}
