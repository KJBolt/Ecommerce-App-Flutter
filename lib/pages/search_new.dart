import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shop_app/pages/filter_search.dart';
import 'package:shop_app/pages/product_details.dart';
import 'package:shop_app/pages/searching_page.dart';
import 'package:shop_app/pages/shop_details.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchPageNew extends StatefulWidget {
  const SearchPageNew({super.key});

  @override
  State<SearchPageNew> createState() => _SearchPageNewState();
}

class _SearchPageNewState extends State<SearchPageNew> {

  @override
  void initState() {
    super.initState();
    fetchFeaturedProducts();
  }

  List<dynamic> responseData = [];
  List<dynamic> featuedProducts = [];
  bool loading = false;

  // Form Key
  final _formkey = GlobalKey<FormState>();

  // Search Input Value
  final _searchValue = TextEditingController();

  // Call search endpoint
  Future<List<dynamic>>fetchData(query) async {
    print(query);
    final apiEndpoint = dotenv.env['API_KEY'];
    final url = '$apiEndpoint/products/search';
    final response = await http.get(Uri.parse('$url/$query'));
    final decodedData = jsonDecode(response.body);
    if (decodedData['data'] != null) {
      final data = decodedData['data'];
      setState(() {
        responseData = data;
      });
      return data;
    } else {
      throw Exception("Failed to fetch data");
    }
  }

  // Fetch featured shops
  Future<Map <String, dynamic>>fetchFeaturedProducts() async {
    setState(() {
      loading = true;
    });
    final apiEndpoint = dotenv.env['API_KEY'];
    final url = '$apiEndpoint';
    final response = await http.get(Uri.parse('${url}/shops'));
    final decodedData = jsonDecode(response.body);
    return decodedData;
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF545D68)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
     body:
     responseData.isNotEmpty ?
     Container(
       color: Colors.white,
       child: ListView.builder(
           scrollDirection: Axis.vertical,
           itemCount: responseData.length,
           itemBuilder: (context, index) {
             // Shop item
             return Column(
               children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 10),
                       child: Text("${responseData.length} results found",
                         style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                       ),
                     )

                   ],
                 ),


                 const SizedBox(height: 20),
                 Container(
                   padding: const EdgeInsets.symmetric(vertical: 10),
                   margin: const EdgeInsets.symmetric(horizontal: 10),
                   decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.circular(10),
                     boxShadow: [
                       BoxShadow(
                         color: Colors.grey.withOpacity(0.3),
                         spreadRadius: 1,
                         blurRadius: 2,
                         offset: const Offset(0, 1),
                       ),
                     ],
                   ),
                   child: ListTile(
                     onTap: () {
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
                                 return ProductDetails(productId: responseData[0]['id']);
                               }));
                     },
                     leading: Container(
                       width: 100,
                       height: 150,
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(10),
                         image: DecorationImage(image: NetworkImage("${responseData[index]['image_url']}"), fit: BoxFit.cover),
                       ),
                     ),
                     title: Text("${responseData[0]['name']}", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                   ),
                 )

               ],
             );

           }),
     ) :
     ListView(
       scrollDirection: Axis.vertical,
       children: [
         Container(
           color: Colors.white,
           height: screenHeight,
           width: screenWidth,
           child: Padding(
             padding: const EdgeInsets.symmetric(horizontal: 15),
             child: Column(
               children: [
                 // Search Section
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     // Search Input
                     GestureDetector(
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
                                   return const SearchingPage();
                                 }));
                       },
                       child: Container(
                         width: screenWidth * 0.9,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(10),
                           color: Colors.grey[300],
                         ),
                         child: Form(
                             key: _formkey,
                             child: TextFormField(
                               controller: _searchValue,
                               enabled: false,
                               validator: (value) {
                                 if (value == null || value.isEmpty) {
                                   return 'Search field cannot be empty';
                                 }
                                 return null;
                               },
                               decoration: InputDecoration(
                                   contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                   suffixIcon: IconButton(
                                       onPressed: () {
                                         if (_formkey.currentState!.validate()) {
                                           fetchData(_searchValue.text);
                                         } else {
                                           print("Search field cannot be empty");
                                         }
                                       },
                                       icon: const Icon(Icons.search)
                                   ),
                                   hintText: 'Search',
                                   border: InputBorder.none
                               ),
                             )
                         ),
                       ),
                     ),

                   ],
                 ),

                 // Grid Items
                 Container(
                   child: Column(
                     children: [
                       const SizedBox(height: 20),
                       const Row(
                         children: [
                           Padding(
                             padding: EdgeInsets.symmetric(horizontal: 10),
                             child: Text("Shop by category", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                           ),
                           Icon(Icons.arrow_circle_right_sharp, color: Colors.white),
                         ],
                       ),

                       const SizedBox(height: 15),
                       Container(
                           height: screenHeight * 0.26,
                           child:  Column(
                             children: [
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                                 children: [
                                   // Computers
                                   Container(
                                     height: screenHeight * 0.12,
                                     width: screenWidth * 0.43,
                                     decoration: BoxDecoration(
                                         borderRadius: BorderRadius.circular(20),
                                         color: const Color(0xFF2C8915)
                                     ),
                                     child: const Stack(
                                       children: [
                                         Positioned(
                                             child: Padding(
                                                 padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                 child: Text('Computers', style: TextStyle(fontSize: 15, color: Colors.white),)
                                             )

                                         ),
                                         Positioned(
                                             bottom: 0,
                                             right: 0,
                                             child: Image(image: AssetImage('images/computer.png'))
                                         ),
                                       ],
                                     ),
                                   ),

                                   // Clothing
                                   Container(
                                     height: screenHeight * 0.12,
                                     width: screenWidth * 0.43,
                                     decoration: BoxDecoration(
                                         borderRadius: BorderRadius.circular(20),
                                         color: const Color(0xFFD2D60C)
                                     ),
                                     child: const Stack(
                                       children: [
                                         Positioned(
                                             child: Padding(
                                                 padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                 child: Text("Women's\n Clothing", style: TextStyle(fontSize: 15, color: Colors.white),)
                                             )

                                         ),
                                         Positioned(
                                             bottom: 0,
                                             right: 0,
                                             child: Image(image: AssetImage('images/clothing.png'))
                                         ),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),

                               const SizedBox(height: 10),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                                 children: [
                                   // Computers
                                   Container(
                                     height: screenHeight * 0.12,
                                     width: screenWidth * 0.43,
                                     decoration: BoxDecoration(
                                         borderRadius: BorderRadius.circular(20),
                                         color: const Color(0xFFF91111)
                                     ),
                                     child: const Stack(
                                       children: [
                                         Positioned(
                                             child: Padding(
                                                 padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                 child: Text('Home Appliances', style: TextStyle(fontSize: 15, color: Colors.white),)
                                             )

                                         ),
                                         Positioned(
                                             bottom: 0,
                                             right: 0,
                                             child: Image(image: AssetImage('images/iron.png'))
                                         ),
                                       ],
                                     ),
                                   ),

                                   // Clothing
                                   Container(
                                     height: screenHeight * 0.12,
                                     width: screenWidth * 0.43,
                                     decoration: BoxDecoration(
                                         borderRadius: BorderRadius.circular(20),
                                         color: const Color(0xFF7386EF)
                                     ),
                                     child: const Stack(
                                       children: [
                                         Positioned(
                                             child: Padding(
                                                 padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                 child: Text("Home\n Decor", style: TextStyle(fontSize: 15, color: Colors.white),)
                                             )

                                         ),
                                         Positioned(
                                             bottom: 0,
                                             right: 0,
                                             child: Image(image: AssetImage('images/paint.png'))
                                         ),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                             ],
                           )
                       )

                     ],
                   ),
                 ),

                 // Second Horizontal products
                 const SizedBox(height: 20),
                 const Row(
                   children: [
                     Padding(
                       padding: EdgeInsets.symmetric(horizontal: 10),
                       child: Text("Featured Shops", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                     ),
                     Icon(Icons.arrow_circle_right_sharp, color: Colors.white),
                   ],
                 ),
                 FutureBuilder<dynamic>(
                   future: fetchFeaturedProducts(),
                   builder: (context, snapshot) {
                     var featuredproduct = snapshot.data?['featured_products'];

                    if (snapshot.hasError) {
                      return Container(
                        height: screenHeight * 0.4,
                        child: const Center(
                            child:  Text(
                            'Something went wrong!',
                              style: TextStyle(color: Colors.black, fontSize: 15),
                            )
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting){
                      return Container(
                        height: screenHeight * 0.4,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                      if (snapshot.data['featured_products'] != null) {
                        return Container(
                          height: screenHeight * 0.40,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: featuredproduct.length,
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
                                            return ProductDetails(productId: featuredproduct[index]['id']);
                                          }));
                                },
                                child: Container(
                                  width: screenWidth * 0.7,
                                  height: screenHeight * 0.40,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFDADADA),
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
                                      image: DecorationImage(
                                          image: NetworkImage('${featuredproduct[index]['image_url']}'),
                                          fit: BoxFit.cover)
                                  ),
                                  margin: const EdgeInsets.all(10),

                                ),
                              );
                            },
                          ),
                        );
                      }
                      else {
                        return Container(
                          height: screenHeight * 0.4,
                          child: const Center(child:  Text('No Products to display')),
                        );
                      }


                   },
                 ),


               ],
             ),
           ),

         )
       ],
     ),

    );
  }
}