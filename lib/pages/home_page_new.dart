import 'package:flutter/material.dart';
import 'package:shop_app/components/homecompnew_page.dart';
import 'package:shop_app/pages/admin/dashboard_new.dart';
import 'package:shop_app/pages/admin/messges_page.dart';
import 'package:shop_app/pages/admin/orders_page.dart';
import 'package:shop_app/pages/admin/products_page.dart';
import 'package:shop_app/pages/admin/store_settings.dart';
import 'package:shop_app/pages/cart_page.dart';
import 'package:shop_app/pages/my_orders.dart';
import 'package:shop_app/pages/profile_page.dart';
import 'package:shop_app/pages/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/home_comp.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';


class HomePageNew extends StatefulWidget {
  const HomePageNew({super.key});

  @override
  State<HomePageNew> createState() => _HomePageNewState();
}

class _HomePageNewState extends State<HomePageNew> {

  late String adminSwitch = "";

  // Execute once component is loaded
  @override
  void initState() {
    super.initState();
  }

  //retrieve adminID from localstorage
  Future<String>? retrieveAdminId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('admin_id');
    // print('AdminId from homepagenew => ${id}');
    if(id != null){
      setState(() {
        adminSwitch = id.toString();
      });
    }
    return id!.toString();
  }

  @override
  Widget build(BuildContext context) {
    // Screens
    List<Widget> _userScreens() {
      return [
        const HomeCompNewPage(),
        const CartPage(productId: 0,),
        const MyOrders(),
        const ProfilePage()
      ];
    }

    List<Widget> _adminScreens() {
      return [
        const DashboardNew(),
        const ProductsPage(),
        const OrdersPage(),
        const StoreSettingsPage()
      ];
    }

    // Guest Icons
    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home_outlined),
          title: ("Home"),
          activeColorPrimary: CupertinoColors.white,
          inactiveColorPrimary: CupertinoColors.black,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.shopping_basket_outlined),
          title: ("Cart"),
          activeColorPrimary: CupertinoColors.white,
          inactiveColorPrimary: CupertinoColors.black,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.folder_copy_outlined),
          title: ("Orders"),
          activeColorPrimary: CupertinoColors.white,
          inactiveColorPrimary: CupertinoColors.black,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.person_2_outlined),
          title: ("Profile"),
          activeColorPrimary: CupertinoColors.white,
          inactiveColorPrimary: CupertinoColors.black,
        ),
      ];
    }

    // Admin Icons
    List<PersistentBottomNavBarItem> _adminBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.dashboard),
          title: ("Dashboard"),
          activeColorPrimary: CupertinoColors.white,
          inactiveColorPrimary: CupertinoColors.black,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.shopping_bag),
          title: ("Products"),
          activeColorPrimary: CupertinoColors.white,
          inactiveColorPrimary: CupertinoColors.black,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.bookmark_border_sharp),
          title: ("Orders"),
          activeColorPrimary: CupertinoColors.white,
          inactiveColorPrimary: CupertinoColors.black,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.settings),
          title: ("Settings"),
          activeColorPrimary: CupertinoColors.white,
          inactiveColorPrimary: CupertinoColors.black,
        ),
      ];
    }

    // Persistent Bottom Tab key/controller
    PersistentTabController _controller;
    _controller = PersistentTabController(initialIndex: 0);

    return SafeArea(
      child: FutureBuilder<String>(
              future: retrieveAdminId(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return PersistentTabView(
                    context,
                    controller: _controller,
                    screens: _userScreens(),
                    items: _navBarsItems(),
                    confineInSafeArea: true,
                    backgroundColor: const Color(0xFFED294D), // Default is Colors.white.
                    handleAndroidBackButtonPress: true, // Default is true.
                    resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
                    stateManagement: false, // Default is true.
                    hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
                    decoration: const NavBarDecoration(
                      colorBehindNavBar: Colors.white,
                    ),
                    popAllScreensOnTapOfSelectedTab: true,
                    popActionScreens: PopActionScreensType.all,
                    itemAnimationProperties: const ItemAnimationProperties( // Navigation Bar's items animation properties.
                      duration: Duration(milliseconds: 200),
                      curve: Curves.ease,
                    ),
                    screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
                      animateTabTransition: true,
                      curve: Curves.ease,
                      duration: Duration(milliseconds: 200),
                    ),
                    navBarStyle: NavBarStyle.style6, // Choose the nav bar style with this property.
                  );
                } else {
                  return PersistentTabView(
                    context,
                    controller: _controller,
                    screens:  _adminScreens(),
                    items: _adminBarsItems(),
                    confineInSafeArea: true,
                    backgroundColor: const Color(0xFF7386EF), // Default is Colors.white.
                    handleAndroidBackButtonPress: true, // Default is true.
                    resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
                    stateManagement: false, // Default is true.
                    hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
                    decoration: const NavBarDecoration(
                      colorBehindNavBar: Colors.white,
                    ),
                    popAllScreensOnTapOfSelectedTab: true,
                    popActionScreens: PopActionScreensType.all,
                    itemAnimationProperties: const ItemAnimationProperties( // Navigation Bar's items animation properties.
                      duration: Duration(milliseconds: 200),
                      curve: Curves.ease,
                    ),
                    screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
                      animateTabTransition: true,
                      curve: Curves.ease,
                      duration: Duration(milliseconds: 200),
                    ),
                    navBarStyle: NavBarStyle.style6, // Choose the nav bar style with this property.
                  );
                }
              }
            )
    );

  }
}