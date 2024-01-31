import 'package:flutter/material.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({super.key});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: const Text("Payment Methods", style: TextStyle(fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF545D68)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            height: screenHeight * 0.18,
            child:  Column(
              children: [
                // Credit Card title
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Text("Credit Card & Debit Card", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                    )

                  ],
                ),
                const SizedBox(height: 10),

                // Add Card
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: const Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Image(image: AssetImage('images/card.png'))
                      ),
                      Text("Add Card", style: TextStyle(fontSize: 15),)
                    ],
                  ),
                )


              ],
            ),
          ),

          Container(
            margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            height: screenHeight * 0.53,
            child:  Column(
              children: [
                // Credit Card title
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Text("More Payment Methods", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                    )
                  ],
                ),
                const SizedBox(height: 10),

                Expanded(
                  child:  ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                          ),
                          height: screenHeight * 0.08,
                          child: const Center(child: Text("Paypal", style: TextStyle(fontSize: 15))),
                        );
                      }
                  ),
                ),

                // Add Card
                // Container(
                //   padding: const EdgeInsets.symmetric(vertical: 10),
                //   decoration: BoxDecoration(
                //       border: Border.all(color: Colors.black),
                //       borderRadius: BorderRadius.circular(10)
                //   ),
                //   child: const Row(
                //     children: [
                //       Padding(
                //           padding: EdgeInsets.symmetric(horizontal: 15),
                //           child: Image(image: AssetImage('images/card.png'))
                //       ),
                //       Text("Add Card", style: TextStyle(fontSize: 15),)
                //     ],
                //   ),
                // )


              ],
            ),
          )
        ],
      ),

    );
  }
}