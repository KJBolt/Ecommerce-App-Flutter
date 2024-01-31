import 'package:flutter/material.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  // Form Key
  final _formkey = GlobalKey<FormState>();

  // Search Input Value
  final _searchValue = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: const Text("Messages", style: TextStyle(fontSize: 18)),
      ),

      body: ListView(
        scrollDirection: Axis.vertical,
        children: [

          // Search Field
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey[300],
            ),
            margin: const EdgeInsets.only(bottom: 15, left: 20, right: 20),
            width: screenWidth,
            child: Form(
                key: _formkey,
                child: TextFormField(
                  controller: _searchValue,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Search field cannot be empty';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      prefixIcon: IconButton(
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {

                            } else {
                              print("Search field cannot be empty");
                            }
                          },
                          icon: const Icon(Icons.search)
                      ),
                      hintText: 'Search',
                      border: InputBorder.none,
                  ),
                )
            ),
          ),

          // Avatars
          Container(
            height: screenHeight * 0.2,
            width: screenWidth,
            child:  ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      width: screenWidth * 0.33,
                      height: screenHeight * 0.35,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: const Image(
                              image: AssetImage('images/bolt.png'),
                              fit: BoxFit.cover,
                            ),
                          ),

                          const SizedBox(height: 2,),
                          const Text("John Doe", style: TextStyle(fontWeight: FontWeight.w500),)
                        ],
                      )
                    )
                  ],
                );
              },
            ),
          ),

          // Messages
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            // decoration: BoxDecoration(
            //   border: Border.all(color: Colors.black)
            // ),
            height: screenHeight * 0.55,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: 6,
              itemBuilder: (context, index) {
                return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: const Image(
                                    image: AssetImage('images/bolt.png'),
                                    fit: BoxFit.cover,
                                    height: 50,
                                    width: 50,
                                  ),
                                ),
                              )

                            ],
                          ),

                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("John Doe", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                              Text("Hello admin, i would like to request some \n groceries", textAlign: TextAlign.justify, style: TextStyle(fontSize: 12))
                            ],
                          )
                        ],
                      ),
                      const Divider(
                        color: Colors.black,
                        height: 20, // adjust the height of the line
                        thickness: 0.9, // adjust the thickness of the line
                      ),

                    ],
                  )
                );

              },
            ),
          )




        ],
      ),

    );
  }
}