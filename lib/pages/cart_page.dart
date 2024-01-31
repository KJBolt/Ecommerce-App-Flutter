import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shop_app/pages/quick_email.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/pages/shipping_form.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/database/db_helper.dart';
import 'package:shop_app/model/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key, required this.productId});
  final int productId;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  DBHelper? dbHelper = DBHelper();
  List<bool> tapped = [];
  dynamic id;
  dynamic userName;
  dynamic userEmail;
  @override
  void initState() {
    super.initState();
    context.read<CartProvider>().getData();
    retrieveData();
  }

  //retrieve id from localstorage
  Future<int?> retrieveId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');
    if (id != null){
      return id;
    }
    return id;
  }

  void retrieveData() async {
    id = await retrieveId();
    userName = await retrieveName();
    userEmail = await retrieveEmail();
  }

  //retrieve name from localstorage
  Future<String?> retrieveName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('name');
    if (name != null){
      return name;
    }
  }

  //retrieve email from localstorage
  Future<String?> retrieveEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    if (email != null){
      return email;
    }

  }

  //save token to localstorage
  Future<void> saveTotalPrice(int val) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('totalPrice', val);
  }

  @override
  Widget build(BuildContext context) {
    // var screenSize = MediaQuery.of(context).size;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final cart = Provider.of<CartProvider>(context);
    dynamic prodId = widget.productId;

    return Consumer<CartProvider>(
      builder: (BuildContext context, provider, widget) => Scaffold(
        body: Container(
                height: screenHeight,
                width: screenWidth,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  // border: Border.all(color: Colors.black)
                ),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    // Empty Cart
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4DFE2),
                        border: Border.all(color: Colors.grey),
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
                      ),
                      height: screenHeight,
                      width: screenWidth,
                      child:  provider.cart.isEmpty?
                          Center(
                            child: Container(
                              width: screenWidth,
                              height: screenHeight * 0.5,
                              child: const Column(
                                children: [
                                  SizedBox(height: 50),
                                  Image(image: AssetImage('images/empty.png')),
                                  SizedBox(height: 20),
                                  Text('Your Cart is empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                                  SizedBox(height: 20),
                                  Text('Add products while you shop, so \nthey’ll be ready for checkout later.',
                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ),

                          )

                          :
                          SizedBox(
                            height: screenHeight * 0.44,
                            child: Column(
                              children: [
                                Container(
                                  height: screenHeight * 0.75,
                                  child:  Container(
                                    child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: provider.cart.length,
                                      itemBuilder: (context, index) {
                                        return Slidable(
                                            startActionPane: const ActionPane(
                                              extentRatio: 0.3,
                                              motion: StretchMotion(),
                                              children: [
                                                SlidableAction(
                                                    onPressed: null,
                                                    backgroundColor: Colors.redAccent,
                                                    icon: Icons.delete,
                                                    label: "Delete")
                                              ],
                                            ),
                                            child: Container(
                                              height: 95,
                                              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF2F2F2),
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

                                              // Card
                                              child: Row(
                                                children: [
                                                  // Images
                                                  Container(
                                                    // child: Image.network(provider.cart[index].image!, width: 120,),
                                                    width: 120,
                                                    decoration: BoxDecoration(
                                                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                                                        image: DecorationImage(
                                                            image: provider.cart[index].image != null ? NetworkImage(provider.cart[index].image!) : const NetworkImage('https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg?w=900'),
                                                            fit: BoxFit.cover)),
                                                  ),

                                                  // Middle Content
                                                  Container(
                                                    width: 120,
                                                    padding: const EdgeInsets.only(left: 10),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Text(
                                                          provider.cart[index].productName!,
                                                          style: const TextStyle(
                                                              fontSize: 18,
                                                              fontWeight: FontWeight.w600),
                                                        ),
                                                        // Text("GHC ${value.lst[index].price.toString()}", style: const TextStyle(fontSize: 12),)
                                                        Container(
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: Colors.black),
                                                              borderRadius:
                                                              BorderRadius.circular(20)),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.center,
                                                            children: [
                                                              ValueListenableBuilder<int>(
                                                                  valueListenable: provider
                                                                      .cart[index].quantity!,
                                                                  builder:
                                                                      (context, val, child) {
                                                                    return PlusMinusButtons(
                                                                      addQuantity: () {
                                                                        cart.addQuantity(
                                                                            provider
                                                                                .cart[index]
                                                                                .id!);
                                                                        dbHelper!
                                                                            .updateQuantity(
                                                                            Cart(
                                                                                // id: index,
                                                                                productId:
                                                                                index
                                                                                    .toString(),
                                                                                productName: provider
                                                                                    .cart[
                                                                                index]
                                                                                    .productName,
                                                                                initialPrice: provider
                                                                                    .cart[
                                                                                index]
                                                                                    .initialPrice,
                                                                                productPrice: provider
                                                                                    .cart[
                                                                                index]
                                                                                    .productPrice,
                                                                                quantity: ValueNotifier(provider
                                                                                    .cart[
                                                                                index]
                                                                                    .quantity!
                                                                                    .value),
                                                                                // unitTag: provider
                                                                                //     .cart[index].unitTag,
                                                                                image: provider
                                                                                    .cart[
                                                                                index]
                                                                                    .image))
                                                                            .then((value) {
                                                                          setState(() {
                                                                            cart.addTotalPrice(
                                                                                double.parse(provider
                                                                                    .cart[
                                                                                index]
                                                                                    .productPrice
                                                                                    .toString()));
                                                                          });
                                                                        });
                                                                      },
                                                                      deleteQuantity: () {
                                                                        cart.deleteQuantity(
                                                                            provider
                                                                                .cart[index]
                                                                                .id!);
                                                                        cart.removeTotalPrice(
                                                                            double.parse(provider
                                                                                .cart[index]
                                                                                .productPrice
                                                                                .toString()));
                                                                      },
                                                                      text: val.toString(),
                                                                    );
                                                                  }),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),

                                                  // Right Content
                                                  Container(
                                                    width: 100,
                                                    padding: const EdgeInsets.only(
                                                        top: 20, right: 10),
                                                    // decoration: BoxDecoration(
                                                    //     border: Border.all(color: Colors.black),
                                                    // ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          'GHc${provider.cart[index].productPrice!}',
                                                          style: const TextStyle(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w500,
                                                              color: Color(0xFFED294D)
                                                          ),
                                                        ),
                                                        IconButton(
                                                            onPressed: () {
                                                              dbHelper!.deleteCartItem(
                                                                  provider.cart[index].id!);
                                                              provider.removeItem(
                                                                  provider.cart[index].id!);
                                                              provider.removeCounter();
                                                            },
                                                            icon: const Icon(
                                                              Icons.delete_outline,
                                                              color: Colors.red,
                                                            ))
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ));
                                      },
                                    ),
                                  ),

                                ),

                                // Sub total
                                Consumer<CartProvider>(
                                   builder: (BuildContext context, value, Widget? child) {
                                     final ValueNotifier<int?> totalPrice =
                                         ValueNotifier(null);
                                     for (var element in value.cart) {
                                       totalPrice.value = (element.productPrice! *
                                               element.quantity!.value) +
                                           (totalPrice.value ?? 0);
                                     }
                                     return Column(
                                       children: [
                                         ValueListenableBuilder<int?>(
                                             valueListenable: totalPrice,
                                             builder: (context, val, child) {
                                               // Store total price in local storage
                                               saveTotalPrice(val!);
                                               // print("Total Value => $val");
                                               return ReusableWidget(
                                                   title: 'Sub-Total',
                                                   value: r'GHc' +
                                                       (val?.toStringAsFixed(2) ?? '0'));
                                             }),
                                       ],
                                     );
                                   },
                                 ),

                                // Proceed Btn
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
                                              return id != null
                                                  ? ShippingFormPage(
                                                  useremail: userEmail,
                                                  username: userName)
                                                  : QuickEmailPage(
                                                prodId: prodId,
                                              );
                                            }));
                                  },
                                  child: Container(
                                      width: screenWidth,
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 10, bottom: 0),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 20),
                                      decoration: BoxDecoration(
                                          color: const Color(0xFFED294D),
                                          borderRadius: BorderRadius.circular(10)),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('Proceed to checkout',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(color: Colors.white)),
                                        ],
                                      )),
                                )

                              ],
                            ),
                          ),

                    ),

                    // Grid Items
                    // Container(
                    //   padding: const EdgeInsets.symmetric(vertical: 10),
                    //   decoration: const BoxDecoration(
                    //       color: Color(0xFFF4DFE2),
                    //       borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                    //   ),
                    //   height: screenHeight * 0.63,
                    //   width: screenWidth,
                    //   child: Column(
                    //     children: [
                    //        Column(
                    //         children: [
                    //            const Row(
                    //             children: [
                    //               Padding(
                    //                 padding: EdgeInsets.only(left: 25, right: 10),
                    //                 child: Text("Favourite shops", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                    //               ),
                    //               Icon(Icons.arrow_circle_right_sharp, color: Colors.black),
                    //             ],
                    //           ),
                    //
                    //           Container(
                    //             decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(20)
                    //             ),
                    //             margin: const EdgeInsets.all(10),
                    //             height: screenHeight * 0.09,
                    //             child:  ListView.builder(
                    //               scrollDirection: Axis.horizontal,
                    //               itemCount: 3,
                    //               itemBuilder: (context, index) {
                    //                 return Container(
                    //                   width: screenWidth * 0.32,
                    //                   decoration: BoxDecoration(
                    //                     borderRadius: BorderRadius.circular(15),
                    //                   ),
                    //                   child: Stack(
                    //                       children: [
                    //                         ColorFiltered(
                    //                           colorFilter: ColorFilter.mode(Colors.black38.withOpacity(0.6), BlendMode.srcOver),
                    //                           child:  Container(
                    //                             margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    //                             decoration: const BoxDecoration(
                    //                               image: DecorationImage(image: AssetImage('images/shopbanner.png'), fit: BoxFit.cover),
                    //                             ),
                    //                           ),
                    //                         ),
                    //                         const Center(child: Text('Bolt Shop', style: TextStyle(color: Colors.white)),)
                    //                       ],
                    //                     ),
                    //                 );
                    //               },
                    //             ),
                    //           )
                    //
                    //         ],
                    //       ),
                    //
                    //
                    //       const SizedBox(height: 8),
                    //       Container(
                    //         child: Column(
                    //           children: [
                    //             const SizedBox(height: 20),
                    //             const Row(
                    //               children: [
                    //                 Padding(
                    //                   padding: EdgeInsets.symmetric(horizontal: 25),
                    //                   child: Text("Dive into a category", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                    //                 ),
                    //               ],
                    //             ),
                    //
                    //             const SizedBox(height: 15),
                    //             Container(
                    //                 height: screenHeight * 0.26,
                    //                 child:  Column(
                    //                   children: [
                    //                     Row(
                    //                       mainAxisAlignment: MainAxisAlignment.center,
                    //                       children: [
                    //                         // Computers
                    //                         Container(
                    //                           margin: const EdgeInsets.only(right: 10),
                    //                           height: screenHeight * 0.12,
                    //                           width: screenWidth * 0.43,
                    //                           decoration: BoxDecoration(
                    //                               borderRadius: BorderRadius.circular(20),
                    //                               color: const Color(0xFF2C8915)
                    //                           ),
                    //                           child: const Stack(
                    //                             children: [
                    //                               Positioned(
                    //                                   child: Padding(
                    //                                       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    //                                       child: Text('Computers', style: TextStyle(fontSize: 15, color: Colors.white),)
                    //                                   )
                    //
                    //                               ),
                    //                               Positioned(
                    //                                   bottom: 0,
                    //                                   right: 0,
                    //                                   child: Image(image: AssetImage('images/computer.png'))
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         ),
                    //
                    //                         // Clothing
                    //                         Container(
                    //                           height: screenHeight * 0.12,
                    //                           width: screenWidth * 0.43,
                    //                           decoration: BoxDecoration(
                    //                               borderRadius: BorderRadius.circular(20),
                    //                               color: const Color(0xFFD2D60C)
                    //                           ),
                    //                           child: const Stack(
                    //                             children: [
                    //                               Positioned(
                    //                                   child: Padding(
                    //                                       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    //                                       child: Text("Women's\n Clothing", style: TextStyle(fontSize: 15, color: Colors.white),)
                    //                                   )
                    //
                    //                               ),
                    //                               Positioned(
                    //                                   bottom: 0,
                    //                                   right: 0,
                    //                                   child: Image(image: AssetImage('images/clothing.png'))
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //
                    //                     const SizedBox(height: 10),
                    //                     Row(
                    //                       mainAxisAlignment: MainAxisAlignment.center,
                    //                       children: [
                    //                         // Home Appliances
                    //                         Container(
                    //                           margin: const EdgeInsets.only(right: 10),
                    //                           height: screenHeight * 0.12,
                    //                           width: screenWidth * 0.43,
                    //                           decoration: BoxDecoration(
                    //                               borderRadius: BorderRadius.circular(20),
                    //                               color: const Color(0xFFF91111)
                    //                           ),
                    //                           child: const Stack(
                    //                             children: [
                    //                               Positioned(
                    //                                   child: Padding(
                    //                                       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    //                                       child: Text('Home Appliances', style: TextStyle(fontSize: 15, color: Colors.white),)
                    //                                   )
                    //
                    //                               ),
                    //                               Positioned(
                    //                                   bottom: 0,
                    //                                   right: 0,
                    //                                   child: Image(image: AssetImage('images/iron.png'))
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         ),
                    //
                    //                         // Clothing
                    //                         Container(
                    //                           height: screenHeight * 0.12,
                    //                           width: screenWidth * 0.43,
                    //                           decoration: BoxDecoration(
                    //                               borderRadius: BorderRadius.circular(20),
                    //                               color: const Color(0xFF7386EF)
                    //                           ),
                    //                           child: const Stack(
                    //                             children: [
                    //                               Positioned(
                    //                                   child: Padding(
                    //                                       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    //                                       child: Text("Home\n Decor", style: TextStyle(fontSize: 15, color: Colors.white),)
                    //                                   )
                    //
                    //                               ),
                    //                               Positioned(
                    //                                   bottom: 0,
                    //                                   right: 0,
                    //                                   child: Image(image: AssetImage('images/paint.png'))
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ],
                    //                 )
                    //             )
                    //
                    //           ],
                    //         ),
                    //       ),
                    //     ],
                    //   )
                    //
                    // ),
                  ],
                )
            ),
      ),
    );
  }
}

class PlusMinusButtons extends StatelessWidget {
  final VoidCallback deleteQuantity;
  final VoidCallback addQuantity;
  final String text;
  const PlusMinusButtons(
      {Key? key,
      required this.addQuantity,
      required this.deleteQuantity,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: deleteQuantity, icon: const Icon(Icons.remove)),
        Text(text),
        IconButton(onPressed: addQuantity, icon: const Icon(Icons.add)),
      ],
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget({Key? key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ],
      ),
    );
  }
}
