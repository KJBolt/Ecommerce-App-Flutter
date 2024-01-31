import 'package:flutter/material.dart';
// import 'package:shop_app/pages/admin/admin_login.dart';
import 'package:shop_app/pages/admin/dashboard_new.dart';
import 'package:shop_app/pages/admin/onboarding/location_onboard.dart';
import 'package:shop_app/pages/admin/onboarding/shipping_onboard.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/pages/home_page_new.dart';

class CongratsOnboardPage extends StatefulWidget {
  const CongratsOnboardPage(
      {super.key,
      required this.shippingOption,
      required this.paymentMethod,
      required this.location});
  final List<String> shippingOption;
  final List<String> paymentMethod;
  final String location;

  @override
  State<CongratsOnboardPage> createState() => _CongratsOnboardPageState();
}

class _CongratsOnboardPageState extends State<CongratsOnboardPage> {

  bool loading = false;
  void redirectHomePage() {
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
              return const HomePageNew();
            }));
  }
  //save AdminOnboard to localstorage
  Future<void> saveAdminOnboardToLocal(int id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('admin_onboard', id);
  }

  //retrieve token
  Future<String?> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retrieve the token
    String? token = prefs.getString('token');
    return token;
  }

  //retrieve name from localstorage
  Future<int>? retrieveId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('admin_id');
    return id!;
  }

  Future<void> saveShopDetails() async {
    setState(() {
      loading = true;
    });
    final apiEndpoint = dotenv.env['API_KEY'];
    final apiUrl = '${apiEndpoint}/shop/update-on-boarding';
    String? token = await retrieveToken();
    final int? id = await retrieveId();

    Map<String, dynamic> requestData = {
      'user_id': id,
      'shop_shipping_options': '${widget.shippingOption}',
      'shop_payment_options': '${widget.paymentMethod}',
      'shop_location': widget.location,
    };
    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: json.encode(requestData));
      final data = jsonDecode(response.body);
      print('Response => ${data}');
      if (data['status'] == 200) {
        setState(() {
          loading = false;
        });
        saveAdminOnboardToLocal(1);
        Future.delayed(const Duration(milliseconds: 3000), redirectHomePage);
      } else {
        print(data['error']);
        setState(() {
          loading = false;
        });
      }
    } catch (error) {
      print(error);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print(widget.shippingOption);
    print(widget.paymentMethod);
    print(widget.location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF545D68)),
          onPressed: () {
            Navigator.push(
                context,
                // MaterialPageRoute(builder: (context) => const ProductDetails()),
                PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 400),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin =
                          Offset(-1.0, 0.0); // Start off the screen to the left
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
                      return LocatioOnboardPage(
                        shippingOption: widget.shippingOption,
                        paymentMethod: widget.paymentMethod,
                      );
                    }));
          },
        ),
      ),
      body: Container(
        color: Colors.blue[300],
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            height: 400,
            width: 340,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Step 4",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: const Text("Congratulations",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.w500)),
                    ),
                    const Icon(Icons.emoji_emotions_outlined, color: Colors.green)
                  ],
                ),
                const SizedBox(height: 10),
                const Text("You have successfully setup your store",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54)),
                const SizedBox(height: 30),
                GestureDetector(
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
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return const ShippingOnboardPage();
                            }));
                  },
                  child: GestureDetector(
                    onTap: () {
                      saveShopDetails();
                    },
                    child: Container(
                      width: 200,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                      ),
                      child:  loading == true ?
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)),
                      )
                          :
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Dashboard",style: TextStyle(color: Colors.white)),
                          Icon(Icons.arrow_forward_rounded, color: Colors.white)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )

    );
  }
}
