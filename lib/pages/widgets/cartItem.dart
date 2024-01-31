import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  const CartItem(
      {Key? key,
      required this.screenSize,
      required this.image,
      required this.itemName,
      required this.price}) //this.del
      : super(key: key);

  final Size screenSize;
  final String image, itemName;
  final double price;
  // final Function del;

  @override
  Widget build(BuildContext context) {
    Color? blueColor = const Color.fromRGBO(144, 202, 249, 1);
    return Container(
      margin: const EdgeInsets.all(10),
      height: screenSize.height * 0.15,
      width: screenSize.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: blueColor.withOpacity(0.3),
                offset: const Offset(0, 0),
                blurRadius: 3,
                spreadRadius: 3)
          ]),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: CachedNetworkImage(
            height: screenSize.height * 0.13,
            width: screenSize.width * 0.3,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            imageUrl: image ?? 'https://picsum.photos/250?image=9',
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            itemName ?? "Item",
            style: const TextStyle(fontSize: 22),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            'Ghc${price ?? 0.00}',
            style: const TextStyle(fontSize: 15),
          ),
        )
      ]),
    );
  }
}
