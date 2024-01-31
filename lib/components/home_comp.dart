import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shop_app/pages/login_page.dart';
import 'package:shop_app/pages/profile_page.dart';
import 'package:shop_app/pages/searchshops_page.dart';
import 'package:shop_app/pages/shop_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeComp extends StatefulWidget {
  const HomeComp({super.key});

  @override
  State<HomeComp> createState() => _HomeCompState();
}

class _HomeCompState extends State<HomeComp> {

  // List to store api response
  List d_shops = [];

  bool loading = false;

  //retrieve name from localstorage
  Future<int>? retrieveId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');
    return id!;
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Call the fetchData function when the page loads
  }

  //get shops
  Future<void> fetchData() async {
    try {
      loading = true;
      final apiEndpoint = dotenv.env['API_KEY'];
      final url ="$apiEndpoint/shops";
      final response = await http.get(Uri.parse(url));
      final data = jsonDecode(response.body);

      if (data['status'] == 200) {
        loading = false;
        setState(() {
          d_shops = data['shops'];
        });
      } else {
        loading = false;
        setState(() {
          d_shops = [];
        });
      }
    } catch (e) {
      print(e);
    }

   
  }


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFDADADA),
          elevation: 0.2,
          centerTitle: true,
          leadingWidth: 300,
          leading: GestureDetector(
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
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const SearchShopPage();
                      }));
            },
            child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                height: 20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[200]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: const Icon(Icons.search),
                    ),

                    const Text("Search shops")
                  ],
                )
            ),
          ),
          actions: <Widget>[
            FutureBuilder<int>(
                future: retrieveId(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return  TextButton(
                      onPressed: () {
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
                                  return const LoginPage();
                                }));
                      },
                      child: Text("SIGN IN"),
                    );
                  } else {
                    return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child:  CircleAvatar(
                            backgroundImage: AssetImage('images/bolt.png'),
                          ),
                        );
                  }
                }),

          ],
        ),

        // Grid View of Items
        body: loading == true ? Container(
          color: const Color(0xFFDADADA),
          child: const Center(child: CircularProgressIndicator()),
        )
         :
        d_shops.isEmpty ? Container(
          color: const Color(0xFFDADADA),
          child: const Center(child: Text('No shops to display')),
        )
         :
        // Container(
        //   padding: const EdgeInsets.symmetric(horizontal: 15),
        //   height: double.infinity,
        //   color: const Color(0xFFDADADA),
        //   child: ListView.builder(
        //     shrinkWrap: true,
        //     itemCount: d_shops.length, // loops through the array ang get the array length
        //     itemBuilder: (context, index) {
        //
        //       // Get the values from the array
        //       var shopname = d_shops[index]['shop_name'] as String;
        //       var banner = d_shops[index]['banner'] as String;
        //       var shopid = d_shops[index]['id'] ;
        //
        //
        //       return GestureDetector(
        //         onTap: () {
        //           Navigator.push(
        //               context,
        //               // MaterialPageRoute(builder: (context) => const ProductDetails()),
        //               PageRouteBuilder(
        //                   transitionDuration: const Duration(milliseconds: 400),
        //                   transitionsBuilder:
        //                       (context, animation, secondaryAnimation, child) {
        //                     const begin = Offset(
        //                         -1.0, 0.0); // Start off the screen to the left
        //                     const end = Offset.zero;
        //                     var tween = Tween(begin: begin, end: end);
        //                     var offsetAnimation = animation.drive(tween);
        //
        //                     return SlideTransition(
        //                       position: offsetAnimation,
        //                       child: FadeTransition(
        //                         opacity: animation,
        //                         child: child,
        //                       ),
        //                     );
        //                   },
        //                   pageBuilder: (context, animation, secondaryAnimation) {
        //                     return ShopDetailsPage(shopId: shopid);
        //                   }));
        //         },
        //         child: Container(
        //           decoration: BoxDecoration(
        //             color: Colors.white,
        //             boxShadow: [
        //               BoxShadow(
        //                 color: Colors.grey.withOpacity(0.5),
        //                 spreadRadius: 1,
        //                 blurRadius: 2,
        //                 offset: const Offset(0, 1),
        //               ),
        //             ],
        //             borderRadius: const BorderRadius.only(
        //               topRight: Radius.circular(20),
        //               topLeft: Radius.circular(20),
        //               bottomLeft: Radius.circular(20),
        //               bottomRight: Radius.circular(20),
        //             ),
        //           ),
        //
        //           margin: const EdgeInsets.all(10),
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.stretch,
        //             children: [
        //               Stack(
        //                 children: [
        //                   Container(
        //                     height: 150,
        //                     decoration: BoxDecoration(
        //                         borderRadius: BorderRadius.circular(10),
        //                         image: DecorationImage(
        //                             image: NetworkImage('$banner'),
        //                             fit: BoxFit.cover)),
        //                   ),
        //                 ],
        //               ),
        //               Container(
        //                 padding: const EdgeInsets.symmetric(
        //                     vertical: 15, horizontal: 2),
        //                 child: Row(
        //                   crossAxisAlignment: CrossAxisAlignment.center,
        //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //                   children: [
        //                     Text(shopname,style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        //                     Container(
        //                       padding: const EdgeInsets.all(5),
        //                       decoration: BoxDecoration(
        //                           color: Colors.black,
        //                           borderRadius: BorderRadius.circular(10)
        //                       ),
        //                       child: const Text("Visit Shop",
        //                           style: TextStyle(fontSize: 12, color: Colors.white)
        //                       ),
        //                     )
        //
        //                   ],
        //                 ),
        //               )
        //             ],
        //           ),
        //         ),
        //       );
        //     },
        //   )
        // ),
        Container(
          height: screenHeight,
          width: screenWidth,
          color: const Color(0xFFDADADA),
          child: Column(
            children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: d_shops.length, // loops through the array ang get the array length
              itemBuilder: (context, index) {

                // Get the values from the array
                var shopname = d_shops[index]['shop_name'] as String;
                var banner = d_shops[index]['banner'] as String;
                var shopid = d_shops[index]['id'] ;


                return GestureDetector(
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
                            pageBuilder: (context, animation, secondaryAnimation) {
                              return ShopDetailsPage(shopId: shopid);
                            }));
                  },
                  child: Container(
                    width: 50,
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: banner != null ? NetworkImage(banner) : const NetworkImage('https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg?w=900'),
                                      fit: BoxFit.cover)),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(shopname,style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: const Text("Visit Shop",
                                    style: TextStyle(fontSize: 12, color: Colors.white)
                                ),
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

              ],
          ),
        )
        );

  }
}
