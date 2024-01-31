import 'package:flutter/material.dart';
import 'package:flutter_cart/model/cart_model.dart';
import 'package:shop_app/pages/cart_page.dart';
import 'package:shop_app/pages/login_page.dart';
import 'package:shop_app/pages/shop_details.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:shop_app/pages/splash_screen.dart';
import 'package:shop_app/viewModel/productsVM.dart';
// import 'package:shop_app/pages/widgets/cartCounter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:badges/badges.dart' as badges;
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/database/db_helper.dart';
// import 'package:shop_app/model/item_model.dart';
import 'package:shop_app/model/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetails extends StatefulWidget {
  final int productId;
  const ProductDetails({super.key, required this.productId});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Map productDetails = {};
  bool productLiked = false;
  DBHelper dbHelper = DBHelper();
  bool isLoggedIn = false;
  bool likeSwitch = false;
  late BuildContext myContext;

  void showToastMessage(msg) => Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black45,
      textColor: Colors.white,
      fontSize: 12.0);

  // Navigate to login page when not logged in
  void navigateToAnotherPage() {
    // Use the saved context to navigate to another page
    Navigator.push(
      myContext,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  // Like product function
  Future<String?> likeProduct(int? productId) async {
    // Get the user id
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');
    print('UserId => ${id}');

    if (id != null) {
      String? token = await retrieveToken();
      final headers = {'Authorization': 'Bearer $token'};
      final apiEndpoint = dotenv.env['API_KEY'];
      final url = '${apiEndpoint}/products/${productId}/like';
      final response = await http.post(Uri.parse(url), headers: headers);
      final data = response.body;
      setState(() {
        productLiked = true;
        likeSwitch = true;
      });
    } else {
      navigateToAnotherPage();
    }
  }

  // Unlike product function
  Future<String?> unlikeProduct(int? productId) async {
    // Get the user id
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');
    print('UserId => ${id}');

    if (id != null) {
      String? token = await retrieveToken();
      final headers = {'Authorization': 'Bearer $token'};
      final apiEndpoint = dotenv.env['API_KEY'];
      final url = '${apiEndpoint}/products/${productId}/unlike';
      final response = await http.delete(Uri.parse(url), headers: headers);
      final data = response.body;
      setState(() {
        productLiked = false;
        likeSwitch = false;
      });
    } else {
      navigateToAnotherPage();
    }

  }

  @override
  void initState() {
    super.initState();
    fetchData(widget.productId);
    // Call the fetchData function when the page loads
  }

  // Retrieve token
  Future<String?> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retrieve the token
    String? token = prefs.getString('token');
    return token;
  }

  //save important shop datails into localstorage
  Future<void> saveShopIdToLocal(shopId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('shopId', shopId);
  }

  //get single shop
  Future<void> fetchData(int? id) async {
    final apiEndpoint = dotenv.env['API_KEY'];
    final url = '${apiEndpoint}/product';
    final response = await http.get(Uri.parse('$url/$id'));
    final data = jsonDecode(response.body);

    if (data['status'] == 200) {
      setState(() {
        productDetails = data['products'];
      });
      saveShopIdToLocal(data['products']['shop_id']);
    } else {
      setState(() {
        productDetails = {};
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    myContext = context;
    final cart = Provider.of<CartProvider>(context);
    void saveData(int index) {
      var convertPrice = double.parse(productDetails['price']);
      print("Convert Price => ${convertPrice}");
      Cart cartItem = Cart(
        productId: index.toString(),
        productName: productDetails['name'],
        initialPrice: convertPrice.toInt(),
        productPrice: convertPrice.toInt(),
        quantity: ValueNotifier(1),
        image: productDetails['image_url'], //productDetails['image']
      );
      cartItem.addProductToCart(cartItem);
  
      dbHelper.insert(cartItem).then((value) {
        cart.addTotalPrice(double.parse(productDetails['price']));
        cart.addCounter();
        // Show toast messageX
        showToastMessage('Added to cart');
      }).onError((error, stackTrace) {
        showToastMessage('Item not added. Please try again');
      });
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text(productDetails['name'] ?? "",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF545D68)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            badges.Badge(
              badgeContent: Consumer<CartProvider>(
                builder: (context, provider, child) {
                  print(provider.counter);
                  return Text(
                    provider.getCounter().toString(),
                    // provider.cart.length.toString(),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  );
                },
              ),
              position: const badges.BadgePosition(start: 30, bottom: 30),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CartPage(
                                productId: productDetails['shop_id'],
                              )));
                },
                icon: const Icon(Icons.shopping_cart),
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
          ],
        ),

        // If condition to render widgets
        body: productDetails.isNotEmpty
            ? Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white
                ),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(image: productDetails['image_url'] != null ? NetworkImage('${productDetails['image_url']}') : const NetworkImage('https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg?w=900'),
                                fit: BoxFit.cover
                            ),
                          ),
                          // child: Image.network(productDetails['media'][0]['original_url'],height: 380,),
                          height: 380,
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(productDetails['name'],
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.w500)),
                              Text("GHC ${productDetails['price']}",
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              productDetails['description'],
                              textAlign: TextAlign.justify,
                            )),
                        const SizedBox(height: 20),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Consumer<ProductsVM>(
                              Container(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFED294D),
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  height: 50,
                                  width: screenWidth * 0.85,
                                  child: TextButton(
                                      onPressed: () {
                                        saveData(productDetails['id']);
                                      },
                                      child: const Text(
                                        "Add to Cart",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ),
                              ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )

            : Container(
              color: Colors.white,
              child: const Center(child: CircularProgressIndicator())),
            );

  }
}
