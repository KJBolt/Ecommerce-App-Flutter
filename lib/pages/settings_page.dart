import 'package:flutter/material.dart';
import 'package:shop_app/pages/profile_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    void _showBottomSheet(BuildContext context) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 300,
            padding: const EdgeInsets.all(20),
            // Your bottom sheet content here
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Email Address Input
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        hintText: 'Email Address',
                        border: UnderlineInputBorder(borderSide:BorderSide(color: Colors.black))),
                  ),
                ),

                // Old Password Input
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        hintText: 'Old Password',
                        border: UnderlineInputBorder(borderSide:BorderSide(color: Colors.black))),
                  ),
                ),

                // New Password Input
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        hintText: 'New Password',
                        border: UnderlineInputBorder(borderSide:BorderSide(color: Colors.black))),
                  ),
                ),

                // Submit Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueAccent,
                      ),
                      child: TextButton(onPressed: () {}, child: const Text("Submit", style: TextStyle(color: Colors.white),)),
                    )
                  ],
                ),

              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: const Text("Settings", style: TextStyle(fontSize: 18)),
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
      ),

      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            //  Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     const Text("Personal Info", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            //     TextButton(
            //         onPressed: () {
            //           _showBottomSheet(context);
            //         },
            //         child: const Text("Edit", style: TextStyle(color: Colors.redAccent, fontSize: 15)))
            //   ],
            // ),

            // Notifications

            // Notification
            Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: screenWidth,
              child: Row(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    child: const Image(image: AssetImage('images/bigbell.png'),),
                  ),

                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Notification Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      Text('Cutomize your notifications', style: TextStyle(fontSize: 12))
                    ],
                  )
                ],
              )
            ),
            const Divider(),

            // Payment Methods
            Container(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: screenWidth,
                child: Row(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      child: const Image(image: AssetImage('images/card.png'),),
                    ),

                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Payment Methods', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        Text('Manage payments', style: TextStyle(fontSize: 12))
                      ],
                    )
                  ],
                )
            ),
            const Divider(),

            // Password
            Container(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: screenWidth,
                child: Row(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      child: const Image(image: AssetImage('images/card.png'),),
                    ),

                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Password Manager', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        Text('Configure password details', style: TextStyle(fontSize: 12))
                      ],
                    )
                  ],
                )
            ),
            const Divider(),

            // Help Center
            Container(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: screenWidth,
                child: Row(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      child: const Image(image: AssetImage('images/roundcircle.png'),),
                    ),

                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Help Center', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        Text('Need assistance', style: TextStyle(fontSize: 12))
                      ],
                    )
                  ],
                )
            ),
            const Divider(),

            // Privacy Policy
            Container(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: screenWidth,
                child: Row(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      child: const Image(image: AssetImage('images/screw.png'),),
                    ),

                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Privacy Policy', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        Text('Terms and agreements', style: TextStyle(fontSize: 12))
                      ],
                    )
                  ],
                )
            ),
            const Divider(),

            // Delete
            Container(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                margin: const EdgeInsets.symmetric(vertical: 10),
                width: screenWidth,
                child: Row(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      child: const Image(image: AssetImage('images/bin.png'),),
                    ),

                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Delete Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        Text('Move to trash', style: TextStyle(fontSize: 12))
                      ],
                    )
                  ],
                )
            ),
            const Divider(),


          ],
        ),
      ),
    );
  }
}