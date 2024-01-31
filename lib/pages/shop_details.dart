import 'package:flutter/material.dart';
import 'package:shop_app/components/home_comp.dart';
import 'package:shop_app/components/homecompnew_page.dart';
import 'package:shop_app/pages/home_page_new.dart';
import 'package:shop_app/pages/product_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shop_app/pages/search_new.dart';
import 'dart:convert';

import 'package:shop_app/pages/search_page.dart';
import 'package:shop_app/pages/search_shop_product.dart';
import 'package:shop_app/pages/searching_page.dart';
import 'package:shop_app/pages/searchshops_page.dart';

class ShopDetailsPage extends StatefulWidget {
  final int shopId; // Initialize prop variable
  const ShopDetailsPage({super.key,required this.shopId}); // Get the prop

  @override
  State<ShopDetailsPage> createState() => _ShopDetailsPageState();
}

class _ShopDetailsPageState extends State<ShopDetailsPage> {
  Map shopDetails = {};

  //get shop details
  Future<void> fetchData(int? id) async {
    final apiEndpoint = dotenv.env['API_KEY'];
    final url = '${apiEndpoint}/shops';
    final response = await http.get(Uri.parse('$url/$id'));
    final data = jsonDecode(response.body);

    if (data['status'] == 200) {
      if (mounted){
        setState(() {
          shopDetails = data;
        });
      }
      saveShopIdToLocal();
      saveShopLocationToLocal();
      saveShippingOptionToLocal();
    } else {
      if (mounted) {
        setState(() {
          shopDetails = {};
        });
      }

    }
  }

  //save important shop datails into localstorage
  Future<void> saveShopIdToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('shopId', shopDetails['shop']['id']);
  }

  Future<void> saveShopLocationToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('shopLocation', shopDetails['shop']['location']);
  }

  Future<void> saveShippingOptionToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('shippingOption', shopDetails['shop']['shiping_options']);
  }


  @override
  void initState() {
    super.initState();
    fetchData(widget.shopId);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: shopDetails.isNotEmpty
            ? Container(
                color: Colors.white,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                child: Stack(
                                  children: [
                                    ColorFiltered(
                                      colorFilter: ColorFilter.mode(Colors.black38.withOpacity(0.6), BlendMode.srcOver),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            image: shopDetails['shop']['banner'] == null ? const DecorationImage(image: AssetImage('images/shopbanner.png'), fit: BoxFit.cover) : DecorationImage(image: NetworkImage('${shopDetails['shop']['banner']}'), fit: BoxFit.cover)
                                        ),
                                        height: 300,
                                      ),
                                    ),

                                    Container(
                                      padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          // Back Icon
                                          Container(
                                            margin:
                                            const EdgeInsets.only(bottom: 55),
                                            child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                      padding:
                                                      const EdgeInsets.all(5),
                                                      decoration: BoxDecoration(
                                                          color: Colors.white70,
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                      margin: const EdgeInsets.only(
                                                          left: 10, bottom: 5),
                                                      child: const Icon(
                                                          Icons.arrow_back,
                                                          color: Colors.black),
                                                    ),
                                                  )
                                                ]),
                                          ),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              shopDetails['shop']['logo'] == null ? Text('') : Container(
                                                height: 50,
                                                width: 50,
                                                margin: const EdgeInsets.only(right: 10),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(50),
                                                  image: DecorationImage(
                                                    image: NetworkImage("${shopDetails['shop']['logo']}"),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Text(shopDetails['shop']['shop_name'],
                                                  style: const TextStyle(
                                                      fontSize: 30,
                                                      fontWeight: FontWeight.w900,
                                                      color: Colors.white)
                                              ),
                                            ],
                                          ),


                                          // Shop Details
                                          // Container(
                                          //   padding: const EdgeInsets.symmetric(
                                          //       vertical: 5),
                                          //   width: 200,
                                          //   child: const Text(
                                          //       "Get the affordable products at discount with AdminShop",
                                          //       style: TextStyle(
                                          //           color: Colors.white,
                                          //           fontWeight: FontWeight.w400),
                                          //       textAlign: TextAlign.center),
                                          // ),

                                          // Follow Button
                                          // Container(
                                          //   margin: const EdgeInsets.only(top: 5),
                                          //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                          //   decoration:  BoxDecoration(
                                          //     color: const Color(0xFFED294D),
                                          //     borderRadius: BorderRadius.circular(20),
                                          //   ),
                                          //   child: const Text("Follow", style: TextStyle(color: Colors.white)),
                                          // )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              // Search Bar
                              GestureDetector(
                                onTap: () {
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
                                            return SearchShopProductPage(shopId: shopDetails['shop']['id']);
                                          }));
                                },
                                child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: const Color(0xFFC5AEB2)),
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                          prefixIcon: Icon(Icons.search, color: Colors.white,),
                                          hintText: 'Search Products',
                                          enabled: false,
                                          hintStyle:
                                          TextStyle(color: Colors.white),
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide.none)),
                                    )),
                              ),

                              // Products Title
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("All Products",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black
                                        )
                                    ),
                                    // Container(
                                    //   child: const IconButton(
                                    //       icon: Icon(Icons.keyboard_control),
                                    //       onPressed: null,
                                    //       style: ButtonStyle(
                                    //           foregroundColor:
                                    //           MaterialStatePropertyAll(
                                    //               Colors.black))),
                                    // )
                                  ],
                                ),
                              ),

                              // Product Count
                              Text(
                                "${shopDetails['shop']['product'].length.toString()} products",
                                style: const TextStyle(color: Colors.black),
                                textAlign: TextAlign.center,
                              ),

                              // Products
                              Container(
                                height: screenHeight * 0.40,
                                child: shopDetails != null && shopDetails['shop']['product'].length == 0 ?
                                    Center(
                                      child: Text('No products'),
                                    ):
                                GridView.builder(
                                    physics: const ScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.78,
                                        mainAxisSpacing: 1),
                                    itemCount: shopDetails['shop']['product'].length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                // MaterialPageRoute(builder: (context) => const ProductDetails()),
                                                PageRouteBuilder(
                                                    transitionDuration:
                                                    const Duration(
                                                        milliseconds: 400),
                                                    transitionsBuilder: (context,
                                                        animation,
                                                        secondaryAnimation,
                                                        child) {
                                                      const begin = Offset(-1.0,
                                                          0.0); // Start off the screen to the left
                                                      const end = Offset.zero;
                                                      var tween = Tween(
                                                          begin: begin, end: end);
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
                                                      return ProductDetails(
                                                          productId:
                                                          shopDetails['shop']
                                                          ['product'][index]
                                                          ['id']);
                                                    }));
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.5),
                                                  spreadRadius: 0,
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
                                              crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                              children: [
                                                Stack(
                                                  children: [
                                                    Container(
                                                      // child: Image.network(shopDetails['shop']['product'][index]['media'][0]['original_url'],
                                                      // height: 160,
                                                      // ),
                                                      height: 160,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                          image: DecorationImage(
                                                              image: NetworkImage('${shopDetails['shop']['product'][index] ['image_url']}'),
                                                              fit: BoxFit.cover)),
                                                    ),
                                                    // Positioned(
                                                    //     bottom: 10,
                                                    //     right: 10,
                                                    //     child: Container(
                                                    //       padding:
                                                    //       const EdgeInsets.all(5),
                                                    //       decoration: BoxDecoration(
                                                    //           color: Colors.grey[200],
                                                    //           borderRadius:
                                                    //           BorderRadius
                                                    //               .circular(20)),
                                                    //       child: const Icon(
                                                    //         Icons.favorite_outline,
                                                    //         color: Colors.black,
                                                    //         size: 18,
                                                    //       ),
                                                    //     ))
                                                  ],
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                      vertical: 2, horizontal: 2),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                          shopDetails['shop']['product'][index] ['name'].toString(),
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                              FontWeight.w600)),
                                                      Text(
                                                          "GHC ${shopDetails['shop']['product'][index]['price'].toString()}",
                                                          style: const TextStyle(
                                                              fontSize: 11,
                                                              color: Colors.black)),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ));
                                    }),
                              )

                            ],
                          ),
                        ],
                      );
                    }),
              )
            : Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              )
            ),
        );

  }
}
