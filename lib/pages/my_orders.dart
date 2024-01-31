import 'package:flutter/material.dart';
import 'package:shop_app/components/cancelled_tab.dart';
import 'package:shop_app/components/delivered_tab.dart';
import 'package:shop_app/components/processing_tab.dart';
import 'package:shop_app/pages/profile_page.dart';


class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: const Padding(
          padding: EdgeInsets.only(top: 10, left: 15),
          child: Text('Orders', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
        ),
        leadingWidth: 100,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF545D68)),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        height: screenHeight * 0.85,
        width: screenWidth,
        child: const DeliveredTab()
      )
    );
  }
}