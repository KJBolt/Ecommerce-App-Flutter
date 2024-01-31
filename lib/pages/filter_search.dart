import 'package:flutter/material.dart';

class FilterSearchPage extends StatefulWidget {
  const FilterSearchPage({super.key});

  @override
  State<FilterSearchPage> createState() => _FilterSearchPageState();
}

class _FilterSearchPageState extends State<FilterSearchPage> {
  RangeValues _currentRangeValues = const RangeValues(0, 125);
  String selectedOption = 'Option 1';


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: const Text("Filter Search", style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF545D68)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        height: screenHeight,
        width: screenWidth,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            // Brands
            const Text("Brands", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            Container(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: const Center(child: Text("Sony", style: TextStyle(color: Colors.black),)),
                  );
                },
              ),
            ),
            const Divider(),

            // Country
            const SizedBox(height: 5),
            const Text("Country", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            Container(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: const Center(child: Text("Ghana", style: TextStyle(color: Colors.black),)),
                  );
                },
              ),
            ),
            const Divider(),

            // Sort By
            const SizedBox(height: 5),
            const Text("Sort By", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            Container(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: const Center(child: Text("Most Recent", style: TextStyle(color: Colors.black),)),
                  );
                },
              ),
            ),
            const Divider(),

            // Price Range
            const SizedBox(height: 5),
            const Text("Price Range", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            RangeSlider(
              values: _currentRangeValues,
              max: 500,
              divisions: 4,
              activeColor: const Color(0xFFED294D),
              labels: RangeLabels(
                _currentRangeValues.start.round().toString(),
                _currentRangeValues.end.round().toString(),
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  _currentRangeValues = values;
                });
              },
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('\$0',style: TextStyle(fontWeight: FontWeight.w500)),
                  Text('\$125',style: TextStyle(fontWeight: FontWeight.w500)),
                  Text('\$250',style: TextStyle(fontWeight: FontWeight.w500)),
                  Text('\$375',style: TextStyle(fontWeight: FontWeight.w500)),
                  Text('\$500',style: TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const Divider(),

            // Reviews
            const SizedBox(height: 15),
            const Text("Reviews", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            Container(
              child: Column(
                children: [
                  // First rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Stars
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: const Image(image: AssetImage('images/star.png')),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: const Image(image: AssetImage('images/star.png')),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: const Image(image: AssetImage('images/star.png')),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: const Image(image: AssetImage('images/star.png')),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: const Image(image: AssetImage('images/star.png')),
                            ),
                          ],
                        ),

                      // Text
                        const Text("4.5 and above"),

                      // Radio Button
                      Radio(
                        value: 'Option 1',
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value.toString();
                          });
                        },
                      ),
                    ],
                  ),

                  // Second rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Stars
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: const Image(image: AssetImage('images/star.png')),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: const Image(image: AssetImage('images/star.png')),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: const Image(image: AssetImage('images/star.png')),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: const Image(image: AssetImage('images/star.png')),
                          ),
                        ],
                      ),

                      // Text
                      const Text("3.5 - 4.0"),

                      // Radio Button
                      Radio(
                        value: 'Option 1',
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value.toString();
                          });
                        },
                      ),
                    ],
                  ),

                  // Third rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Stars
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: const Image(image: AssetImage('images/star.png')),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: const Image(image: AssetImage('images/star.png')),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: const Image(image: AssetImage('images/star.png')),
                          ),
                        ],
                      ),

                      // Text
                      const Text("2.5 - 3.0"),

                      // Radio Button
                      Radio(
                        value: 'Option 1',
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value.toString();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: screenWidth * 0.4,
                    child: TextButton(onPressed: (){},
                      style: TextButton.styleFrom(
                          backgroundColor: Color(0xFFED294D),
                          primary: Colors.white// This sets the text color
                      ),
                      child: const Text("Reset Filter"),),
                  ),
                  Container(
                    width: screenWidth * 0.4,
                    child: TextButton(onPressed: (){},
                      style: TextButton.styleFrom(
                          backgroundColor: Color(0xFFD9D9D9),
                          primary: Colors.black// This sets the text color
                      ),
                      child: const Text("Apply"),),
                  ),

                ],
              ),
            )

          ],
        ),
      ),

    );
  }
}