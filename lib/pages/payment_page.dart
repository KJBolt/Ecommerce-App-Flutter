import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shop_app/paystack/paystack_auth_response.dart';
import 'package:shop_app/model/transaction.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/api_key.dart';

import 'package:shop_app/pages/success_page.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({
    super.key,
    required this.amount,
    required this.email,
    required this.reference,
    required this.name,
    required this.phoneNumber,
    required this.streetName,
    required this.country,
    required this.paymentMethod,
    required this.quantity,
    required this.shopId,
    required this.shopLocation,
    required this.shippingOption,
  });

  final String amount;
  final String email;
  final String reference;
  final String name;
  final String phoneNumber;
  final String streetName;
  final String country;
  final String paymentMethod;
  final String quantity;
  final dynamic shopId;
  final dynamic shopLocation;
  final dynamic shippingOption;

  @override
  State<PaymentPage> createState() => _PaymentPage();
}

class _PaymentPage extends State<PaymentPage> {
  // final _webViewKey = UniqueKey();
  // late WebViewController _webViewController;

  late String authorizationUrl = "";

  @override
  void initState() {
    super.initState();
    initializeTransaction();

    // print('Amount => ${widget.amount}');
    // print('Email => ${widget.email}');
    // print('Reference => ${widget.reference}');
    // print('Name => ${widget.name}');
    // print('Phone Number => ${widget.phoneNumber}');
    // print('Street Name => ${widget.reference}');
    // print('Country => ${widget.country}');
    // print('Payment Method => ${widget.paymentMethod}');
    // print('Quantity => ${widget.quantity}');
    // print('ShopId => ${widget.shopId}');
    // print('Shop Location => ${widget.shopLocation}');
    // print('Shop Option => ${widget.shippingOption}');
  }

  Future<PayStackAuthResponse> createTransaction(Transaction transaction) async {
    const String url = 'https://api.paystack.co/transaction/initialize';
    final data = transaction.toJson();
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${ApiKey.secretKey}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        print(response.body);
        // Payment initialization successful
        final responseData = jsonDecode(response.body);
        return PayStackAuthResponse.fromJson(responseData['data']);
      } else {
        throw 'Payment unsuceesful';
      }
    } on Exception {
      throw 'Payment Unsuceesful';
    }
  }

  Future<String> initializeTransaction() async {
    try {
      print('Widget Amount => ${widget.amount}');
      print('Widget Reference => ${widget.reference}');
      print('Widget Email => ${widget.email}');
      final price = double.parse(widget.amount);
      final transaction = Transaction(
        amount: (price * 100).toString(),
        reference: widget.reference,
        currency: 'GHS',
        email: widget.email,
      );

      final authResponse = await createTransaction(transaction);
      print(authResponse.authorization_url);
      setState(() {
        authorizationUrl = authResponse.authorization_url;
      });
      return authResponse.authorization_url;
    } catch (e) {
      print('Error initializing transaction: $e');
      return e.toString();
    }
  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:  authorizationUrl != "" ?
          SafeArea(
              child: WebViewWidget(
                controller: WebViewController()
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..setBackgroundColor(const Color(0x00000000))
                  ..setNavigationDelegate(
                    NavigationDelegate(
                      onProgress: (int progress) {
                        // Update loading bar.
                        const Center(
                          child: Text("Loading.."),
                        );
                      },
                      onPageStarted: (String url) {},
                      onPageFinished: (String url) {},
                      onWebResourceError: (WebResourceError error) {},
                      onNavigationRequest: (NavigationRequest request) {
                        if (request.url.startsWith(
                            'https://9ecb-154-160-6-24.ngrok-free.app')) {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SuccessPage(
                                name: widget.name,
                                amount: widget.amount,
                                email: widget.email,
                                reference: widget.reference,
                                phoneNumber: widget.phoneNumber,
                                paymentMethod: widget.paymentMethod,
                                country: widget.country,
                                quantity: widget.quantity,
                                streetName: widget.streetName,
                                shopLocation: widget.shopLocation,
                                shopId: widget.shopId,
                                shippingOption: widget.shippingOption,
                              )));
                          return NavigationDecision.prevent;
                        }
                        return NavigationDecision.navigate;
                      },
                    ),
                  )
                  ..loadRequest(Uri.parse(authorizationUrl)),
              )
          )

          :
         Container(
           color: Colors.white,
          child: const Center(child: Text("Payment Loading...")),
        )


    );

  }
}
