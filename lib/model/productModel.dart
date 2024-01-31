class Products {
  Products({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
  });

  int id;
  String name;
  String image;
  double price;

  Map<String, dynamic> toJson() => {
        "id":id,
        "image": image,
        "name": name,
        "price": price,
      };
}
