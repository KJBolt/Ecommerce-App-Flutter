import 'package:flutter/material.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage({super.key});

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final _formkey = GlobalKey<FormState>();

  // Input Controllers
  final _holdersName = TextEditingController();
  final _cardNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF545D68)),
          onPressed: () {},
        ),
      ),
      body: ListView(
        children: [
          Container(
            height: screenHeight * 0.35,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('images/creditcard.png'))
            ),
          ),

          Container(
            padding: const EdgeInsets.all(10),
            child:  Form(
                key: _formkey,
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Card Holders Name",
                            style: TextStyle(fontSize: 15),
                            textAlign: TextAlign.start
                        ),
                      ],
                    ),

                    Container(
                      child: Column(
                        children: [
                          const SizedBox(height: 8),
                          // Card Holder Name Input
                          TextFormField(
                            controller: _holdersName,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Name is required';
                              }
                              return null;
                            },
                            decoration:  InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(30)
                              ),
                            ),

                          ),
                          const SizedBox(height: 20),


                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Card Number",
                                  style: TextStyle(fontSize: 15),
                                  textAlign: TextAlign.start
                              ),
                            ],
                          ),

                          // Card Number Input
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _cardNumber,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your card number';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                border: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(30)
                                )
                            ),
                          ),
                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: screenWidth * 0.45,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Expiry Date"),
                                    TextFormField(
                                      controller: _cardNumber,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your card number';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                          border: OutlineInputBorder(
                                              borderSide: const BorderSide(color: Colors.black),
                                              borderRadius: BorderRadius.circular(30)
                                          )
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              Container(
                                width: screenWidth * 0.45,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("CCV"),
                                    TextFormField(
                                      controller: _cardNumber,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your card number';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                          border: OutlineInputBorder(
                                              borderSide: const BorderSide(color: Colors.black),
                                              borderRadius: BorderRadius.circular(30)
                                          )
                                      ),
                                    )
                                  ],
                                ),
                              ),

                            ],
                          ),

                          const SizedBox(height: 25),
                          GestureDetector(
                            onTap: () {

                            },
                            child:  Container(
                              width: screenWidth * 0.9,
                              height: screenHeight * 0.06,
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: const Color(0xFFED294D)
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Add Card", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 15))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ),
          )

        ],
      ),

    );
  }
}