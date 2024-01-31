class FormData {
  String name;
  String email;
  String phoneNumber;
  String streetName;
  String country;
  String paymentMethod;
  String shippingOption;
  double deliveryFee;

  FormData(
      {required this.name,
      required this.email,
      required this.phoneNumber,
      required this.streetName,
      required this.country,
      required this.paymentMethod,
      required this.shippingOption,
      required this.deliveryFee});
}
