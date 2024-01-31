import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shop_app/pages/product_details.dart';
import 'package:shop_app/pages/shop_details.dart';

class SearchingPage extends StatefulWidget {
  const SearchingPage({super.key});

  @override
  State<SearchingPage> createState() => _SearchingPageState();
}

class _SearchingPageState extends State<SearchingPage> {
  List<dynamic> responseData = [];

  // Form Key
  final _formkey = GlobalKey<FormState>();

  // Search Input Value
  final _searchValue = TextEditingController();

  // Call search endpoint
  Future<List<dynamic>>fetchData(query) async {
    print(query);
    final apiEndpoint = dotenv.env['API_KEY'];
    // final url = '$apiEndpoint/products/search';
    final url = '$apiEndpoint/shops/search';
    final response = await http.get(Uri.parse('$url/$query'));
    final decodedData = jsonDecode(response.body);
    if (decodedData != null) {
      final data = decodedData;
      setState(() {
        responseData = data;
      });
      return data;
    } else {
      throw Exception("Failed to fetch data");
    }
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
        title: const Text("Search Shop", style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF545D68)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          // Search Section
          Container(
            height: screenHeight * 0.1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Search Input
                Container(
                    width: screenWidth * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[300],
                    ),
                    child: Form(
                        key: _formkey,
                        child: TextFormField(
                          controller: _searchValue,
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
                              hintText: 'Search...',
                              border: InputBorder.none
                          ),
                        )
                    ),
                  ),

              ],
            ),
          ),

          // Recent and Clear All
          responseData.isEmpty ?
          // Container(
          //   child: Column(
          //     children: [
          //       Container(
          //         margin: const EdgeInsets.only(top: 5),
          //         padding: const EdgeInsets.symmetric(horizontal: 10),
          //         height: screenHeight * 0.05,
          //         // decoration: BoxDecoration(
          //         //     border: Border.all(color: Colors.black)
          //         // ),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             TextButton(
          //                 onPressed: () {},
          //                 child: const Text('Recent',style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16))
          //             ),
          //             TextButton(
          //                 onPressed: () {},
          //                 child: const Text('Clear All', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w400))
          //             ),
          //           ],
          //         ),
          //       ),
          //
          //       // Divider
          //       Container(
          //         padding: const EdgeInsets.symmetric(horizontal: 20),
          //         child: const Divider(),
          //       ),
          //
          //       // Categories
          //       Container(
          //         height: screenHeight * 0.65,
          //         child:  ListView.builder(
          //           itemCount: 15,
          //           itemBuilder: (context, index) {
          //             return Container(
          //               padding: const EdgeInsets.symmetric(horizontal: 20),
          //               height: screenWidth * 0.10,
          //               child:  Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 children: [
          //                   Text('Gaming Case', style: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey.shade600)),
          //                   Container(
          //                     decoration: BoxDecoration(
          //                         border: Border.all(color: Colors.grey.shade600),
          //                         borderRadius: BorderRadius.circular(20)
          //                     ),
          //                     child: Icon(Icons.close_rounded, size: 15, color: Colors.grey.shade600),
          //                   )
          //
          //                 ],
          //               ),
          //             );
          //           },
          //         ),
          //       )
          //     ],
          //   ),
          // ) :
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: const Center(child: Text("No results yet")),
          ) :
          Container(
                child:  Column(
                  children: [

                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text("${responseData.length} results found", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        )
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(),
                    ),
                    const SizedBox(height: 15),

                    Container(
                      height: screenHeight * 0.7,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: responseData.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            height: screenHeight * 0.08,
                            width: screenWidth,
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
                                          return ShopDetailsPage(shopId: responseData[0]['id']);
                                        }));
                              },
                              leading: Container(
                                width: 100,
                                height: 150,
                                decoration: BoxDecoration(
                                    image: DecorationImage(image: NetworkImage('${responseData != null ? responseData[index]['banner'] : ''}'), fit: BoxFit.cover)
                                ),
                              ),
                              title: Text("${responseData[index]['shop_name']}", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                            ),
                          );
                        },
                      ),
                    )

                  ],
                ),
              )
        ],
      )

    );
  }
}