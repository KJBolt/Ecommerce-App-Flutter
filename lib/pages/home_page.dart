// import 'package:flutter/material.dart';
// import 'package:shop_app/pages/admin/dashboard_page.dart';
// import 'package:shop_app/pages/admin/orders_page.dart';
// import 'package:shop_app/pages/admin/products_page.dart';
// import 'package:shop_app/pages/admin/store_settings.dart';
// import 'package:shop_app/pages/cart_page.dart';
// import 'package:shop_app/pages/my_orders.dart';
// import 'package:shop_app/pages/profile_page.dart';
// import 'package:shop_app/pages/settings_page.dart';
// import '../components/home_comp.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   late String adminSwitch = "";
//
//   // Execute once component is loaded
//   @override
//   void initState() {
//     super.initState();
//     retrieveAdminId();
//   }
//
//
//   //retrieve name from localstorage
//   Future<String>? retrieveAdminId() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     int? id = prefs.getInt('admin_id');
//     print("AdminID => ${id}");
//     setState(() {
//       adminSwitch = id.toString();
//     });
//     return id!.toString();
//   }
//
//   // //-------------- Variables defined here----------
//   // int _selectedIndex = 0;
//   //
//   // List<Widget> body = const [
//   //   HomeComp(),
//   //   CartPage(),
//   //   MyOrders(),
//   //   ProfilePage(),
//   // ];
//   //
//   // //--------- Methods are defined here-------------
//   // void _onItemTapped(int index) {
//   //   setState(() {
//   //     _selectedIndex = index;
//   //   });
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     // return Scaffold(
//     //   body: body[_selectedIndex],
//     //
//     //   bottomNavigationBar: BottomNavigationBar(
//     //     items: const <BottomNavigationBarItem>[
//     //       BottomNavigationBarItem(icon: Icon(Icons.home_outlined), backgroundColor: Colors.white, label: "Home", ),
//     //       BottomNavigationBarItem(icon: Icon(Icons.shopping_basket_outlined), backgroundColor: Colors.white, label: "Cart"),
//     //       BottomNavigationBarItem(icon: Icon(Icons.folder_copy_outlined), backgroundColor: Colors.white, label: "Orders"),
//     //       BottomNavigationBarItem(icon: Icon(Icons.person_2_outlined), backgroundColor: Colors.white, label: "Profile"),
//     //     ],
//     //     currentIndex: _selectedIndex,
//     //     selectedItemColor: Colors.black,
//     //     unselectedItemColor: Colors.grey[500],
//     //     onTap: _onItemTapped,
//     //
//     //   ),
//     // );
//     return FutureBuilder<String>(
//         future: retrieveAdminId(),
//         builder: (context, snapshot) {
//           if (snapshot.data == null) {
//             return CupertinoTabScaffold(
//                 tabBar: CupertinoTabBar(
//                   items:  const <BottomNavigationBarItem>[
//                     BottomNavigationBarItem(icon: Icon(Icons.home)),
//                     BottomNavigationBarItem(icon: Icon(Icons.shopping_basket_outlined)),
//                     BottomNavigationBarItem(icon: Icon(Icons.folder_copy_outlined)),
//                     BottomNavigationBarItem(icon: Icon(Icons.person_2_outlined)),
//                   ],
//                 ),
//                 tabBuilder: (context, index) {
//                   switch(index){
//                     case 0:
//                       return CupertinoTabView(builder: (context) {
//                         return  const CupertinoPageScaffold(
//                           child: HomeComp(),
//                         );
//                       });
//
//                     case 1:
//                       return CupertinoTabView(builder: (context) {
//                         return const CupertinoPageScaffold(
//                           child: CartPage(),
//                         );
//                       });
//
//                     case 2:
//                       return CupertinoTabView(builder: (context) {
//                         return const CupertinoPageScaffold(
//                           child: MyOrders(),
//                         );
//                       });
//
//                     case 3:
//                       return CupertinoTabView(builder: (context) {
//                         return const CupertinoPageScaffold(
//                           child: ProfilePage(),
//                         );
//                       });
//
//                     default:
//                       return CupertinoTabView(builder: (context) {
//                         return const CupertinoPageScaffold(
//                           child:  HomeComp(),
//                         );
//                       });
//                   }
//                 }
//             );
//           } else {
//             return CupertinoTabScaffold(
//                 tabBar: CupertinoTabBar(
//                   items:  const <BottomNavigationBarItem>[
//                     BottomNavigationBarItem(icon: Icon(Icons.dashboard)),
//                     BottomNavigationBarItem(icon: Icon(Icons.shopping_bag)),
//                     BottomNavigationBarItem(icon: Icon(Icons.bookmark_border_sharp)),
//                     BottomNavigationBarItem(icon: Icon(Icons.settings)),
//                   ],
//                 ),
//                 tabBuilder: (context, index) {
//                   switch(index){
//                     case 0:
//                       return CupertinoTabView(builder: (context) {
//                         return  const CupertinoPageScaffold(
//                           child: DashboardPage(),
//                         );
//                       });
//
//                     case 1:
//                       return CupertinoTabView(builder: (context) {
//                         return const CupertinoPageScaffold(
//                           child: ProductsPage(),
//                         );
//                       });
//
//                     case 2:
//                       return CupertinoTabView(builder: (context) {
//                         return const CupertinoPageScaffold(
//                           child: OrdersPage(),
//                         );
//                       });
//
//                     case 3:
//                       return CupertinoTabView(builder: (context) {
//                         return const CupertinoPageScaffold(
//                           child: StoreSettingsPage(),
//                         );
//                       });
//
//                     default:
//                       return CupertinoTabView(builder: (context) {
//                         return const CupertinoPageScaffold(
//                           child: DashboardPage(),
//                         );
//                       });
//                   }
//                 }
//             );
//           }
//         });
//
//     return Scaffold(
//       body: CupertinoTabScaffold(
//           tabBar: adminSwitch != "1" ?
//           CupertinoTabBar(
//             items:  const <BottomNavigationBarItem>[
//               BottomNavigationBarItem(icon: Icon(Icons.home)),
//               BottomNavigationBarItem(icon: Icon(Icons.shopping_basket_outlined)),
//               BottomNavigationBarItem(icon: Icon(Icons.folder_copy_outlined)),
//               BottomNavigationBarItem(icon: Icon(Icons.person_2_outlined)),
//             ],
//           ) :
//           CupertinoTabBar(
//             items:  const <BottomNavigationBarItem>[
//               BottomNavigationBarItem(icon: Icon(Icons.dashboard)),
//               BottomNavigationBarItem(icon: Icon(Icons.shopping_bag)),
//               BottomNavigationBarItem(icon: Icon(Icons.bookmark_border_sharp)),
//               BottomNavigationBarItem(icon: Icon(Icons.settings)),
//             ],
//           ),
//           tabBuilder: adminSwitch != "1" ?
//               (context, index) {
//             switch(index){
//               case 0:
//                 return CupertinoTabView(builder: (context) {
//                   return  const CupertinoPageScaffold(
//                     child: HomeComp(),
//                   );
//                 });
//
//               case 1:
//                 return CupertinoTabView(builder: (context) {
//                   return const CupertinoPageScaffold(
//                     child: CartPage(),
//                   );
//                 });
//
//               case 2:
//                 return CupertinoTabView(builder: (context) {
//                   return const CupertinoPageScaffold(
//                     child: MyOrders(),
//                   );
//                 });
//
//               case 3:
//                 return CupertinoTabView(builder: (context) {
//                   return const CupertinoPageScaffold(
//                     child: ProfilePage(),
//                   );
//                 });
//
//               default:
//                 return CupertinoTabView(builder: (context) {
//                   return const CupertinoPageScaffold(
//                     child:  HomeComp(),
//                   );
//                 });
//             }
//           } :
//               (context, index) {
//             switch(index){
//               case 0:
//                 return CupertinoTabView(builder: (context) {
//                   return  const CupertinoPageScaffold(
//                     child: DashboardPage(),
//                   );
//                 });
//
//               case 1:
//                 return CupertinoTabView(builder: (context) {
//                   return const CupertinoPageScaffold(
//                     child: ProductsPage(),
//                   );
//                 });
//
//               case 2:
//                 return CupertinoTabView(builder: (context) {
//                   return const CupertinoPageScaffold(
//                     child: OrdersPage(),
//                   );
//                 });
//
//               case 3:
//                 return CupertinoTabView(builder: (context) {
//                   return const CupertinoPageScaffold(
//                     child: StoreSettingsPage(),
//                   );
//                 });
//
//               default:
//                 return CupertinoTabView(builder: (context) {
//                   return const CupertinoPageScaffold(
//                     child: DashboardPage(),
//                   );
//                 });
//             }
//           }
//       ),
//     );
//
//   }
// }