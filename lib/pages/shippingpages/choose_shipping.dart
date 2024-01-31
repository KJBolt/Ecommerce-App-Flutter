import 'package:flutter/material.dart';
import 'package:shop_app/pages/buyerorseller_page.dart';

class ChooseShippingPage extends StatefulWidget {
  const ChooseShippingPage({super.key});

  @override
  State<ChooseShippingPage> createState() => _ChooseShippingPageState();
}

class _ChooseShippingPageState extends State<ChooseShippingPage> {

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    String selectedOption = 'Option 1';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: const Text("Choose Shipping", style: TextStyle(fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF545D68)),
          onPressed: () {},
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // Local Delivery
          Container(
            height: screenHeight * 0.1,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Image(image: AssetImage('images/localdelivery.png')),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Local Delivery", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                    Text("Estimated arrival 22nd March 2024", style: TextStyle(fontSize: 12))
                  ],
                ),
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
          ),
          const SizedBox(height: 10),

          // In Land Delivery
          Container(
            height: screenHeight * 0.1,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Image(image: AssetImage('images/deliverycar.png')),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("InLand Delivery", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                    Text("Estimated arrival 22nd March 2024", style: TextStyle(fontSize: 12))
                  ],
                ),
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
          ),
          const SizedBox(height: 10),

          // Flight Delivery
          Container(
            height: screenHeight * 0.1,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Image(image: AssetImage('images/airplanedelivery.png')),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Air Freight Delivery", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                    Text("Estimated arrival 22nd March 2024", style: TextStyle(fontSize: 12))
                  ],
                ),
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
          ),
          const SizedBox(height: 10),

          // Ship Delivery
          Container(
            height: screenHeight * 0.1,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Image(image: AssetImage('images/shipdelivery.png')),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Ship Cargo Delivery", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                    Text("Estimated arrival 22nd March 2024", style: TextStyle(fontSize: 12))
                  ],
                ),
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
          ),
          const SizedBox(height: 50),

          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  // MaterialPageRoute(builder: (context) => const ProductDetails()),
                  PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 400),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = 0.0;
                        const end = 1.0;
                        const curve = Curves.easeInOut;
                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                        var opacityAnimation = animation.drive(tween);
                        var scaleAnimation = animation.drive(Tween(begin: 0.5, end: 1.0).chain(CurveTween(curve: curve)));
                        return FadeTransition(
                          opacity: opacityAnimation,
                          child: Transform.scale(
                            scale: scaleAnimation.value,
                            child: child,
                          ),
                        );
                      },
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const BuyerOrSellerPage();
                      }));
            },
            child: Container(
              width: screenWidth,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFFED294D)
              ),
              child: const Text("Apply", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 15)),
            ),
          ),

        ],
      )

    );
  }
}