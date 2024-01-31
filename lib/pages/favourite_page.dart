import 'package:flutter/material.dart';
import 'package:shop_app/pages/profile_page.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: const Text("Favourites", style: TextStyle(fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF545D68)),
          onPressed: () {
            Navigator.push(
                context,
                // MaterialPageRoute(builder: (context) => const ProductDetails()),
                PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 400),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(-1.0, 0.0); // Start off the screen to the left
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
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return const ProfilePage();
                    }
                )
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF545D68)),
            onPressed: () {},
          ),
        ],
      ),

      body: ListView(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [

                // Product 1
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  height: 100,
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        decoration: const BoxDecoration(
                          image: DecorationImage(image: AssetImage('images/bag.jpg'), fit: BoxFit.cover)
                        ),
                      ),

                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Container(
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Shopping Bag", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                    IconButton(onPressed: null, icon: Icon(Icons.close), iconSize: 20,)
                                  ],
                                ),
                              ),

                              const Text("\$ 20.00"),
                            ],
                          ),
                        )

                      )
                    ],
                  )
                ),

                // Product 2
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    height: 100,
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          decoration: const BoxDecoration(
                              image: DecorationImage(image: AssetImage('images/technology.jpg'), fit: BoxFit.cover)
                          ),
                        ),

                        Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header
                                  Container(
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Galaxy S22", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                        IconButton(onPressed: null, icon: Icon(Icons.close), iconSize: 20,)
                                      ],
                                    ),
                                  ),

                                  const Text("\$ 20.00"),
                                ],
                              ),
                            )

                        )
                      ],
                    )
                ),

                // Product 3
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    height: 100,
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          decoration: const BoxDecoration(
                              image: DecorationImage(image: AssetImage('images/laptop.jpg'), fit: BoxFit.cover)
                          ),
                        ),

                        Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header
                                  Container(
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Laptop", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                        IconButton(onPressed: null, icon: Icon(Icons.close), iconSize: 20,)
                                      ],
                                    ),
                                  ),

                                  const Text("\$ 20.00"),
                                ],
                              ),
                            )

                        )
                      ],
                    )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}