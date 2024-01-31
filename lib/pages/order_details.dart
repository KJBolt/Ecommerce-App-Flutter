import 'package:flutter/material.dart';
import 'package:shop_app/pages/my_orders.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        scrollDirection: Axis.vertical,
        children:  [
          Column(
            children: [
              // Order Id and Date
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Order No 194703", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
                    Text("02-09-2023")
                  ],
                ),
              ),


              // Tracking Number
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: const Text("Tracking No:"),
                    ),
                    const Text("IW2345545645", style: TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}