import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

import 'package:shop_app/pages/shop_details.dart';

class SearchShopPage extends StatefulWidget {
  const SearchShopPage({super.key});

  @override
  State<SearchShopPage> createState() => _SearchShopPageState();
}

class _SearchShopPageState extends State<SearchShopPage> {


  List<dynamic> responseData = [];
  bool loading = false;


  // Form Key
  final _formkey = GlobalKey<FormState>();

  // Search Input Value
  final _searchValue = TextEditingController();

  // Call search endpoint
  Future<Map <String, dynamic>>fetchData(query) async {
    print(query);
    setState(() {
      loading = true;
    });
    final apiEndpoint = dotenv.env['API_KEY'];
    final url = '$apiEndpoint/shops/search';
    final response = await http.get(Uri.parse('$url/$query'));
    final decodedData = jsonDecode(response.body);
    print(decodedData[0]['id']);
    if (decodedData != null) {
      setState(() {
        loading = false;
      });
      setState(() {
        responseData = decodedData;
      });
      return decodedData;
    } else {
      throw Exception("Failed to fetch data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
      ),

      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.white,
        child: Column(
          children: [

            // Search Input
            Container(
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
                        hintText: 'Find shops here',
                        border: const UnderlineInputBorder(borderSide:BorderSide(color: Colors.black))
                    ),
                  )
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // Shop List
            responseData.isNotEmpty ?
            loading == true ?
            Container(
                margin: const EdgeInsets.only(top: 100),
                child: const Center(child: CircularProgressIndicator())
            ) :
            Expanded(
              child: ListView.builder(
                  itemCount: responseData.length,
                  itemBuilder: (context, index) {
                    // Shop item
                     return  ListTile(
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
                                decoration: const BoxDecoration(
                                    image: DecorationImage(image: AssetImage('images/bag.jpg'), fit: BoxFit.cover)
                                ),
                              ),
                      title: Text("${responseData[0]['shop_name']}", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    );
                  }
              ),
            )
                :
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 50),
                child: const Text(''),
              ),
            )


          ],
        ),
      ),
    );
  }
}