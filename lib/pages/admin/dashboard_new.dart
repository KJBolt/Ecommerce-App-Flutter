import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/homecompnew_page.dart';
import 'package:shop_app/pages/getstarted_first.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_app/pages/home_page_new.dart';
import '../../provider/cart_provider.dart';
import '../shop_details.dart';
import '../useronboard_signin/onboard_signin.dart';
import 'package:toastification/toastification.dart';

class DashboardNew extends StatefulWidget {
  const DashboardNew({super.key});

  @override
  State<DashboardNew> createState() => _DashboardNewState();
}

class _DashboardNewState extends State<DashboardNew> {
  String selectedOption = 'Today';
  bool loading = false;
  bool adminOnboard = false;
  late int shopId;

  //retrieve ShopId from localstorage
  Future<int>? retrieveId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('shop_id');
    return id!;
  }

  //retrieve token
  Future<int?> getShopId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retrieve the token
    int? id = prefs.getInt('shop_id');
    // print('Shop Id => ${id}');
    if (mounted) {
      setState(() {
        shopId = id!;
      });
    }
    return id!;
  }

  void redirectHomePageNew() {
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: const HomePageNew(),
      withNavBar: false,
    );
  }

  //retrieve token
  Future<String?> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retrieve the token
    String? token = prefs.getString('token');
    return token;
  }

  // Fetch Dashboard data
  Future<Map<String, dynamic>> fetchData() async {
    String? token = await retrieveToken();
    int? shopId = await retrieveId();

    final apiEndpoint = dotenv.env['API_KEY'];
    final url = '$apiEndpoint/calculate-totals/$shopId';
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

  // Error Toast Alerts
  void showErrorToast(msg) {
    toastification.show(
        context: context,
        title: '$msg',
        autoCloseDuration: const Duration(seconds: 2),
        backgroundColor: Colors.redAccent[200],
        foregroundColor: Colors.white);
  }

  //retrieve name from localstorage
  Future<int>? retrieveAdminId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('admin_id');
    print('AdminId => ${id}');
    return id!;
  }

  // Fetch Filter data
  Future<Map<String, dynamic>> fetchFilterData() async {
    loading = true;
    String? token = await retrieveToken();
    int? shopId = await retrieveId();

    final apiEndpoint = dotenv.env['API_KEY'];
    final url ='$apiEndpoint/filter-totals/$shopId/${selectedOption[0].toLowerCase() + selectedOption.substring(1)}';
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

  // Redirect to Login Page
  void redirectAdminOnboardPage() {
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
    prefs.remove("shop_name");
    prefs.remove("shop_id");
    prefs.remove("admin_id");
  }

  //Logout User
  logoutUser() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
    clearLocalStorageExceptOnboard();
    redirectHomePageNew();
  }

  @override
  void initState() {
    retrieveAdminId();
    getShopId();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          leadingWidth: 200,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.login_outlined, color: Colors.redAccent),
              onPressed: () {
                cart.resetCounter();
                cart.deleteCartItems();
                logoutUser();
              },
            ),
          ],
        ),
        body: FutureBuilder(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting){
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF7386EF)),
                );
              } else if (snapshot.data == null) {
                return const Center(
                  child: Text('Start Selling to see your analytics', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                );
              }
              else {
                return ListView(scrollDirection: Axis.vertical, children: [
                  Container(
                    height: screenHeight,
                    width: screenWidth,
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Welcome, Admin",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w600),
                              ),
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: const DecorationImage(
                                        image: AssetImage('images/bolt.png'),
                                        fit: BoxFit.cover)),
                              )
                            ],
                          ),
                        ),

                        // Analytics title
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              const Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: [
                                  Text("Analytics",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)
                                  ),
                                ],
                              ),

                              // Analytics
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                height: screenHeight * 0.2,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          border:
                                          Border.all(color: Colors.black),
                                          color: const Color(0xFF041261),
                                          borderRadius:
                                          BorderRadius.circular(5)),
                                      width: screenWidth * 0.30,
                                      height: screenHeight * 0.2,
                                      child: Column(
                                        children: [
                                          // Green Arrow
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              children: [
                                                Image(
                                                  image: AssetImage(
                                                      'images/greenarrow.png'),
                                                  height: 20,
                                                  width: 20,
                                                )
                                              ],
                                            ),
                                          ),

                                          // Percentage figure
                                          Container(
                                            padding:const EdgeInsets.only(left: 10),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                    "${snapshot.data?['total_orders'].toString()}",
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white)),
                                              ],
                                            ),
                                          ),

                                          // Bar
                                          Container(
                                            margin:
                                            const EdgeInsets.only(top: 20),
                                            width: screenWidth * 0.3,
                                            child: const Image(
                                                image: AssetImage(
                                                    'images/fullbar.png')),
                                          ),

                                          Container(
                                            margin:
                                            const EdgeInsets.only(top: 35),
                                            child: const Text('Total Orders',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white60)),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          border:
                                          Border.all(color: Colors.black),
                                          color: const Color(0xFF045661),
                                          borderRadius:
                                          BorderRadius.circular(5)),
                                      width: screenWidth * 0.30,
                                      height: screenHeight * 0.3,
                                      child: Column(
                                        children: [
                                          // Red Arrow
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              children: [
                                                Image(
                                                  image: AssetImage(
                                                      'images/redarrow.png'),
                                                  height: 20,
                                                  width: 20,
                                                )
                                              ],
                                            ),
                                          ),

                                          // Percentage figure
                                          Container(
                                            padding:
                                            const EdgeInsets.only(left: 10, top: 5),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    const Padding(
                                                      padding: EdgeInsets.only(right: 5),
                                                      child: Text("Ghc",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors.white)
                                                      ),
                                                    ),

                                                    Text("${snapshot.data?['total_sales'].toString()}.00",
                                                        style: const TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.white)
                                                    ),
                                                  ],
                                                )

                                              ],
                                            ),
                                          ),

                                          // Bar
                                          Container(
                                            margin:
                                            const EdgeInsets.only(top: 20),
                                            width: screenWidth * 0.3,
                                            child: const Image(
                                                image: AssetImage(
                                                    'images/lowbar.png')),
                                          ),

                                          Container(
                                            margin:
                                            const EdgeInsets.only(top: 35),
                                            child: const Text('Total Sales',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white60)),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          border:
                                          Border.all(color: Colors.black),
                                          color: const Color(0xFF540461),
                                          borderRadius:
                                          BorderRadius.circular(5)),
                                      width: screenWidth * 0.30,
                                      height: screenHeight * 0.3,
                                      child: Column(
                                        children: [
                                          // Green Arrow
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              children: [
                                                Image(
                                                  image: AssetImage(
                                                      'images/greenarrow.png'),
                                                  height: 20,
                                                  width: 20,
                                                )
                                              ],
                                            ),
                                          ),

                                          // Percentage figure
                                          Container(
                                            padding:
                                            const EdgeInsets.only(left: 10),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Text("${snapshot.data?['total_failed_orders'].toString()}",
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white)),
                                              ],
                                            ),
                                          ),

                                          // Bar
                                          Container(
                                            margin:
                                            const EdgeInsets.only(top: 20),
                                            width: screenWidth * 0.3,
                                            child: const Image(
                                                image: AssetImage(
                                                    'images/moderatebar.png')),
                                          ),

                                          Container(
                                            margin:
                                            const EdgeInsets.only(top: 35),
                                            child: const Text('Failed Orders',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white60)),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Earnings
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          height: screenHeight * 0.55,
                          width: screenWidth,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEBEBEB),
                            borderRadius: BorderRadius.circular(20),
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
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  if (snapshot.data == null){
                                    showErrorToast("Something went wrong!");
                                  } else {
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
                                              return ShopDetailsPage(shopId: shopId);
                                            }));
                                  }

                                },
                                child: Container(
                                    margin: const EdgeInsets.only(bottom: 0),
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: const Color(0xFF7386EF),
                                    ),
                                    child: const Text("Preview Shop",style: TextStyle(fontSize: 15 ,fontWeight: FontWeight.w500, color: Colors.white))
                                ),
                              ),

                              Container(
                                child: const Row(
                                  children: [
                                    Text(
                                      'Earnings',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ),

                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white),
                                  margin: const EdgeInsets.symmetric(vertical: 5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          const Text("Total Earnings"),
                                          const SizedBox(height: 5),
                                          Text(
                                            'Ghc ${snapshot.data?['total_sales'].toString()}.00',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 50,
                                            width: 50,
                                            decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'images/barchart.png'),
                                                    fit: BoxFit.cover)),
                                          )
                                        ],
                                      )
                                    ],
                                  )),

                              //History
                              Container(
                                child: const Row(
                                  children: [
                                    Text(
                                      'History',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 0),
                                child: Container(
                                  height: screenHeight * 0.26,
                                  width: screenWidth,
                                  // decoration: BoxDecoration(
                                  //   border: Border.all(color: Colors.black),
                                  // ),
                                  child: snapshot.hasData && snapshot.data?['orders'].length != 0 ? ListView.builder(
                                    itemCount: snapshot.data?['orders'].length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        height: screenHeight * 0.07,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(5),
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 5,
                                                  horizontal: 5),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      'Payment from ${snapshot.data?['orders'][index]['customer_name'].toString()}',
                                                      style: const TextStyle(
                                                          color:
                                                          Color(0xFF7386EF),
                                                          fontWeight:
                                                          FontWeight.w500)),
                                                  Text('Friday, 21 March',
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors
                                                              .grey[600])),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(right: 10),
                                              child: Text("Ghc ${snapshot.data?['orders'][index]['payment']['amount'].toString()}"),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ):
                                  const Center(
                                    child: Text('No history available.', style: TextStyle(color: Colors.redAccent)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ]);
              }
            })
    );
  }
}
