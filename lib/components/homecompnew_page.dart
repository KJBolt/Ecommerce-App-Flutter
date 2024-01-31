import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shop_app/pages/product_details.dart';
import 'package:shop_app/pages/search_new.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/pages/search_page.dart';
import 'package:shop_app/pages/searching_page.dart';
import 'dart:convert';
import 'package:shop_app/pages/shop_details.dart';
import 'package:shop_app/pages/useronboard_signin/onboard_signin.dart';
import 'package:shop_app/provider/cart_provider.dart';

class HomeCompNewPage extends StatefulWidget {
  const HomeCompNewPage({super.key});

  @override
  State<HomeCompNewPage> createState() => _HomeCompNewPageState();
}

class _HomeCompNewPageState extends State<HomeCompNewPage> {

  // List to store api response
  List shops = [];
  List featured_products = [];

  bool loading = false;

  //retrieve name from local storage
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
      final data  = jsonDecode(response.body);

      if (data['status'] == 200) {
        loading = false;
        // print(data['shops']);
        if(mounted){
          setState(() {
            shops = data['shops'];
            // featured_products = data['featured_products'];
          });
        };
        // printShopState();
        return data;
      } else {
        loading = false;
        if(mounted){
          setState(() {
            shops = [];
          });
        }
      }
    } catch (e) {
      print('Error => ${e}');
    }
  }

  void printShopState () {
    print("Shop State => ${shops}");
  }

  // Redirect to HomePage Function
  void redirectHomePage() {
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: const OnboardSignInPage(),
      withNavBar: false,
    );
  }

  // Clear User Id from localstorage
  void clearLocalStorageExceptOnboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    prefs.remove("email");
    prefs.remove("name");
    prefs.remove("id");
  }

  //Logout User
  logoutUser() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.clear();

    clearLocalStorageExceptOnboard();
    CartProvider myCartProvider = CartProvider();
    myCartProvider.deleteCartItems();
    redirectHomePage();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: loading == true ? Container(
        height: screenHeight,
        width: screenWidth,
        color: Colors.white,
        child: const Center(child: CircularProgressIndicator()),
      )
       :
      shops.isEmpty ? const Center(child: Text('No shops to display')) :
      Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            // Search shops header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context,
                        // MaterialPageRoute(builder: (context) => const ProductDetails()),
                        PageRouteBuilder(
                            transitionDuration: const Duration(milliseconds: 400),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              const begin = 0.0;
                              const end = 1.0;
                              const curve = Curves.easeInOut;
                              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                              var opacityAnimation = animation.drive(tween);
                              var scaleAnimation = animation.drive(Tween(begin: 0.5, end: 1.0).chain(CurveTween(curve: curve)));
                              return FadeTransition(
                                opacity: opacityAnimation,
                                child: Transform.scale(
                                  scale: scaleAnimation.value,
                                  child: child,
                                ),
                              );
                            },
                            pageBuilder: (context, animation, secondaryAnimation) {
                              return const SearchingPage();
                            }));
                  },
                  child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      width: screenWidth * 0.9,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xFFC5AEB2)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(left: 10),
                            margin: const EdgeInsets.only(right: 10),
                            child: const Icon(Icons.search, color: Colors.white),
                          ),

                          const Text("Search shops", style: TextStyle(color: Colors.white),)
                        ],
                      )
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Row(
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Featured Shops", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                )

              ]
            ),
            Container(
              height: screenHeight * 0.3,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: shops.length,
                itemBuilder: (context, index) {
                  // Get the values from the array
                  var shopname = shops[index]['shop_name'] as String;
                  var banner = shops[index]['banner'] == null ? 'https://fabamall.com/media/product/image/2021/05/3e66039d0d1745299b1e7e2c9aa39b1a.jpg' : shops[index]['banner'] as String;
                  var shopid = shops[index]['id'] ;

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
                      width: screenWidth * 0.5,
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
                      ),

                      margin: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Stack(
                            children: [
                              // Image Container
                              Container(
                                height: screenHeight * 0.19,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                                    image: DecorationImage(
                                        image: NetworkImage(banner),
                                        fit: BoxFit.cover)),
                              ),
                            ],
                          ),
                          Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                    color: Color(0xFFC5AEB2)
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(shopname,style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: const Color(0xFFED294D),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: const Text("Visit",
                                          style: TextStyle(fontSize: 12, color: Colors.white)
                                      ),
                                    )

                                  ],
                                ),
                              )

                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),


            // Second Horizontal products
            const SizedBox(height: 10),
            const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("All Shops", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                  )

                ]
            ),
            Container(
              height: screenHeight * 0.35,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: shops.length,
                itemBuilder: (context, index) {
                  // Get the values from the array
                  var shopname = shops[index]['shop_name'];
                  var banner = shops[index]['banner'] == null ? 'https://fabamall.com/media/product/image/2021/05/3e66039d0d1745299b1e7e2c9aa39b1a.jpg' : shops[index]['banner'] as String;
                  var shopid = shops[index]['id'] ;

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
                      width: screenWidth * 0.9,
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
                      ),

                      margin: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Stack(
                            children: [
                              // Image Container
                              Container(
                                height: screenHeight * 0.25,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                                    image: DecorationImage(
                                          image: NetworkImage(banner),
                                          fit: BoxFit.cover
                                        )
                                        ),
                                    
                              ),
                            ],
                          ),
                          Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                    color: Color(0xFFC5AEB2)
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                     Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 0),
                                      child: Text(shopname,style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                    )

                                    // Container(
                                    //   padding: const EdgeInsets.all(5),
                                    //   decoration: BoxDecoration(
                                    //       color: Colors.black,
                                    //       borderRadius: BorderRadius.circular(10)
                                    //   ),
                                    //   child: const Padding(
                                    //     padding: EdgeInsets.symmetric(horizontal: 10),
                                    //     child: Text("Follow",
                                    //         style: TextStyle(fontSize: 12, color: Colors.white)
                                    //     ),
                                    //   )
                                    //
                                    // )

                                  ],
                                ),
                              )

                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Third Horizontal products
            const SizedBox(height: 10),
            const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("More to explore", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                  )

                ]
            ),
            Container(
              height: screenHeight * 0.3,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: shops.length,
                itemBuilder: (context, index) {
                  // Get the values from the array
                  var shopname = shops[index]['shop_name'] as String;
                  var banner = shops[index]['banner'] == null ? 'https://fabamall.com/media/product/image/2021/05/3e66039d0d1745299b1e7e2c9aa39b1a.jpg' : shops[index]['banner'] as String;
                  var shopid = shops[index]['id'] ;

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
                      width: screenWidth * 0.5,
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
                      ),

                      margin: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Stack(
                            children: [
                              // Image Container
                              Container(
                                height: screenHeight * 0.19,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                                    image: DecorationImage(
                                        image: NetworkImage(banner),
                                        fit: BoxFit.cover)),
                              ),
                            ],
                          ),
                          Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                    color: Color(0xFFC5AEB2)
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(shopname,style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: const Color(0xFFED294D),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: const Text("Visit Shop",
                                          style: TextStyle(fontSize: 12, color: Colors.white)
                                      ),
                                    )

                                  ],
                                ),
                              )

                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),


          ],
        ),
      ),

    );
  }
}