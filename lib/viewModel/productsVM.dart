import 'package:flutter/widgets.dart';
import 'package:shop_app/model/productModel.dart';

class ProductsVM with ChangeNotifier {
  List<Products> lst = [];

  add(int id, String image, String name, double price) {
    lst.add(Products(id: id, image: image, name: name, price: price));
    notifyListeners();
  }

  del(int index) {
    lst.removeAt(index);
    notifyListeners();
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'list': lst
  //   };
  // }
}
