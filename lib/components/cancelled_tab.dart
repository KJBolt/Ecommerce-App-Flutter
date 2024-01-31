import 'package:flutter/material.dart';

class CancelledTab extends StatefulWidget {
  const CancelledTab({super.key});

  @override
  State<CancelledTab> createState() => _CancelledTabState();
}

class _CancelledTabState extends State<CancelledTab> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        scrollDirection: Axis.vertical,
        children: [
          Column(
            children: [
              // Order Details 1
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
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


                    // Quantity and Amount
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: const Text("Quantity:"),
                              ),
                              const Text("3", style: TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: const Text("Total Amount:"),
                              ),
                              const Text("\$320", style: TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          )
                        ],
                      ),
                    ),


                    // Details & Delivered
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(20)),
                            child: const Text("Details")
                        ),

                        const Text("Cancelled", style: TextStyle(color: Colors.red))
                      ],
                    )
                  ],
                ),
              ),

              // Order Details 2
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
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


                    // Quantity and Amount
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: const Text("Quantity:"),
                              ),
                              const Text("3", style: TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: const Text("Total Amount:"),
                              ),
                              const Text("\$320", style: TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          )
                        ],
                      ),
                    ),


                    // Details & Delivered
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(20)),
                            child: const Text("Details")
                        ),

                        const Text("Cancelled", style: TextStyle(color: Colors.red))
                      ],
                    )
                  ],
                ),
              ),

              // Order Details 3
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
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


                    // Quantity and Amount
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: const Text("Quantity:"),
                              ),
                              const Text("3", style: TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: const Text("Total Amount:"),
                              ),
                              const Text("\$320", style: TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          )
                        ],
                      ),
                    ),


                    // Details & Delivered
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(20)),
                            child: const Text("Details")
                        ),

                        const Text("Cancelled", style: TextStyle(color: Colors.red))
                      ],
                    )
                  ],
                ),
              ),

              // Order Details 4
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
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


                    // Quantity and Amount
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: const Text("Quantity:"),
                              ),
                              const Text("3", style: TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: const Text("Total Amount:"),
                              ),
                              const Text("\$320", style: TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          )
                        ],
                      ),
                    ),


                    // Details & Delivered
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(20)),
                            child: const Text("Details")
                        ),

                        const Text("Cancelled", style: TextStyle(color: Colors.red))
                      ],
                    )
                  ],
                ),
              ),

              // Order Details 5
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
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


                    // Quantity and Amount
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: const Text("Quantity:"),
                              ),
                              const Text("3", style: TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: const Text("Total Amount:"),
                              ),
                              const Text("\$320", style: TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          )
                        ],
                      ),
                    ),


                    // Details & Delivered
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(20)),
                            child: const Text("Details")
                        ),

                        const Text("Cancelled", style: TextStyle(color: Colors.red))
                      ],
                    )
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