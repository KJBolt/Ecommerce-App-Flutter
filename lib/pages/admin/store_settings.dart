import 'package:flutter/material.dart';
import 'package:shop_app/pages/admin/dashboard_new.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:toastification/toastification.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StoreSettingsPage extends StatefulWidget {
  const StoreSettingsPage({super.key});

  @override
  State<StoreSettingsPage> createState() => _StoreSettingsPageState();
}

class _StoreSettingsPageState extends State<StoreSettingsPage> {

  List<String> shippingArrayValues = [];
  List<String> paymentArrayValues = [];

  // Show dialog when uploading image to firebase
  static void showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false, // set to false if you want to force the user to close the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16.0),
              Text(message),
            ],
          ),
        );
      },
    );
  }

  Map settings = {};
  // Form Key
  final _formkey = GlobalKey<FormState>();
  final _domainkey = GlobalKey<FormState>();
  late int adminId = 0;
  late String displayBanner = '';
  late String displayLogo = '';

  // Input Controllers
  final _locationValue = TextEditingController();

  // final _domainValue = TextEditingController();
  String paymentOption = '';
  String shippingOption = '';
  bool loading = false;

  // Payment Option new settings
  bool isCashonDelivery = false;
  bool isMobileMoney = false;
  bool isCard = false;
  String CashonDelivery = '';
  String MobileMoney = '';
  String Card = '';

  // Shipping Option new settings
  bool isSameDayShipping = false;
  bool isTwoDayShipping = false;
  String SameDayShipping = '';
  String TwoDayShipping = '';

  // Shop logo image url
  late String filePath = "";
  late String imageUrl = '';
  late String fileUploadedName = '';
  late String bannerUrl = '';
  late String bannerUploadedName = '';

  Future<String?> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retrieve the token
    String? token = prefs.getString('token');
    return token;
  }

  Future<String?> retrieveShopName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retrieve the token
    String? shopName = prefs.getString('shop_name');
    return shopName;
  }

  //retrieve name from localstorage
  Future<int>? retrieveId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('admin_id');
    return id!;
  }

  // Fetch products
  Future<void> fetchData() async {
    try{
      String? token = await retrieveToken();
      String? shop_name = await retrieveShopName();

      final apiEndpoint = dotenv.env['API_KEY'];
      final url = '${apiEndpoint}/$shop_name/settings';
      final headers = {'Authorization': 'Bearer $token'};
      final response = await http.get(Uri.parse(url), headers: headers);
      final decodedData = jsonDecode(response.body);
      if (mounted){
        setState(() {
          adminId = decodedData['shop']['user_id'];
        });
      }
      if (decodedData != null && decodedData['status'] == 200) {
        final data = decodedData;
        _locationValue.text = data['shop']['location'];
        //Show check box values and pass data to method
        showCashOnDeliveryCheckBox(data['shop']['paymant_options']);
        showCardCheckBox(data['shop']['paymant_options']);
        showMobileMoneyCheckBox(data['shop']['paymant_options']);
        showSameDayCheckBox(data['shop']['shiping_options']);
        showTwoDayShippingCheckBox(data['shop']['shiping_options']);
        if (mounted){
          setState(() {
            displayBanner = data['shop']['banner'];
            displayLogo = data['shop']['logo'];
            // paymentOption = data['shop']['paymant_options'];
            // shippingOption = data['shop']['shiping_options'];
          });
        }
      } else {
        setState(() {
          settings = {};
        });
      }
    } catch (error) {
      // print('Error from store settngs => ${error}');
    }

  }

  // Redirect to HomePage
  void redirectHomePage() {
    Navigator.push(
        context,
        // MaterialPageRoute(builder: (context) => const ProductDetails()),
        PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(-1.0, 0.0);
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
              return const DashboardNew();
            }));
  }

  // Success Toast Alerts
  void showSuccessToast(msg) {
    toastification.show(
        context: context,
        title: '$msg',
        autoCloseDuration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white);
  }

  // Error Toast Alerts
  void showErrorToast(msg) {
    toastification.show(
        context: context,
        title: '$msg',
        autoCloseDuration: const Duration(seconds: 2),
        backgroundColor: Colors.redAccent[200],
        foregroundColor: Colors.white);
  }

  // Showing Cash on delivery checkbox
  void showCashOnDeliveryCheckBox(data) {
    if (data.contains('Cash on Delivery')){
      paymentArrayValues.add('Cash on Delivery');
      setState(() {
        isCashonDelivery = true;
      });
    } else {
      isCashonDelivery = false;
    }
  }

  // Showing mobile money checkbox
  void showMobileMoneyCheckBox(data) {
    if (data.contains('Mobile Money')){
      paymentArrayValues.add('Mobile Money');
      setState(() {
        isMobileMoney = true;
      });
    } else {
      isMobileMoney = false;
    }
  }

  // Showing card checkbox
  void showCardCheckBox(data) {
    if (data.contains('Card')){
      paymentArrayValues.add('Card');
      setState(() {
        isCard = true;
      });
    } else {
      isCard = false;
    }
  }

  // Showing Same day shipping card checkbox
  void showSameDayCheckBox(data) {
    if (data.contains('Same day shipping')){
      shippingArrayValues.add('Same day shipping');
      setState(() {
        isSameDayShipping = true;
      });
    } else {
      isSameDayShipping = false;
    }
  }

  // Showing Same day shipping card checkbox
  void showTwoDayShippingCheckBox(data) {
    if (data.contains('2-day shipping')){
      shippingArrayValues.add('2-day shipping');
      setState(() {
        isTwoDayShipping = true;
      });
    } else {
      isTwoDayShipping = false;
    }
  }



  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Open image directory
    void openFile() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        PlatformFile file = result.files.first;
        setState(() {
          filePath = file.path.toString();
        });

        showLoadingDialog(context, 'Uploading Image...');

        // Save Image to Firebase Storage
        String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();
        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirImages = referenceRoot.child('images');
        Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);
        try{
          await referenceImageToUpload.putFile(File('${file.path}'));
          // Returns a URL
          imageUrl = await referenceImageToUpload.getDownloadURL();
          print('imageURL => ${imageUrl}');


          if (imageUrl != ''){
            Navigator.of(context, rootNavigator: true).pop('dialog');
          }
          setState(() {
            fileUploadedName = file.name;
          });
        } catch (e) {
          print(e);
        }
        print(file.name);
        print(file.bytes);
        print(file.extension);
        print(file.path);
      } else {
        // User canceled the picker
      }
    }

    // Open banner directory
    void openbannerFile() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        PlatformFile file = result.files.first;
        setState(() {
          filePath = file.path.toString();
        });

        showLoadingDialog(context, 'Uploading Image...');

        // Save Image to Firebase Storage
        String uniqueFileName = DateTime.now().microsecondsSinceEpoch.toString();
        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirImages = referenceRoot.child('images');
        Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);
        try{
          await referenceImageToUpload.putFile(File('${file.path}'));
          // Returns a URL
          bannerUrl = await referenceImageToUpload.getDownloadURL();
          print('bannerURL => ${bannerUrl}');
          setState(() {
            bannerUploadedName = file.name;
          });
          if (bannerUrl != ''){
            Navigator.of(context, rootNavigator: true).pop('dialog');
          }
        } catch (e) {
          print(e);
        }
        print(file.name);
        print(file.bytes);
        print(file.extension);
        print(file.path);
      } else {
        // User canceled the picker
      }
    }

    // Update Shop Details
    Future<void> updateSettings() async {
      setState(() {
        loading = true;
      });
      String? token = await retrieveToken();
      // int? id = await retrieveId();

      final apiEndpoint = dotenv.env['API_KEY'];
      final uri = Uri.parse("${apiEndpoint}/shop/settings");

      try {
          // print('admin_id => ${adminId?.toString()}');
          // print('shop_template => default');
          // print('shop_location => ${_locationValue.text}');
          // print('shop_shipping_options => ${jsonEncode(shippingArrayValues)}');
          // print('shop_payment_options => ${jsonEncode(paymentArrayValues)}');
          // print('logo => ${imageUrl}');
          // print('banner => ${bannerUrl}');
          Map<String, dynamic> bodyData = {
            'user_id': adminId.toString(),
            'shop_template': 'default',
            'shop_location': _locationValue.text,
            'shop_shipping_options': jsonEncode(shippingArrayValues),
            'shop_payment_options': jsonEncode(paymentArrayValues),
            'logo': imageUrl == '' ? displayLogo : imageUrl,
            'banner': bannerUrl == '' ? displayBanner : bannerUrl
          };

          final response = await http.post(
            uri,
            body: bodyData,
            headers: {'Authorization': 'Bearer $token'}
          );

          print('Response => ${response.body}');

          if (response.statusCode == 200) {
            if (mounted){
              setState(() {
                loading = false;
              });
            }
            showSuccessToast('Settings updated successfully');
            Future.delayed(const Duration(milliseconds: 3000), redirectHomePage);
          } else {
            showErrorToast("Failed to update settings");
            if (mounted){
              setState(() {
                loading = false;
              });
            }
          }

      } catch (error) {
        showErrorToast("Updating Settings Failed. Try Again");
        print(error);
        if(mounted){
          setState(() {
            loading = false;
          });
        }
      }
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          title: const Text("Settings", style: TextStyle(fontSize: 18)),
        ),
        body: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Container(
              decoration: BoxDecoration(
                  // border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Template Settings
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Template",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18)),
                      const SizedBox(height: 10),
                      const Text("Select a template for your store"),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        width: 300,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black26),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Default"),
                            Radio(
                                value: "default",
                                groupValue: 'default',
                                onChanged: null)
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Payment Settings
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Payments",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18)),
                      const SizedBox(height: 10),
                      const Text(
                          "Choose the payment methods to be enabled on your store"),
                      const SizedBox(height: 10),
                      Container(
                        height: screenHeight * 0.2,
                        width: screenWidth,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                    value: isCashonDelivery,
                                    onChanged: (bool? newValue){
                                      setState(() {
                                        isCashonDelivery = newValue!;
                                        newValue == true ? paymentArrayValues.add('Cash on Delivery') : paymentArrayValues.remove('Cash on Delivery');
                                      });
                                      print(paymentArrayValues);
                                    }
                                ),
                                const Text('Cash on Delivery'),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                    value: isMobileMoney,
                                    onChanged: (bool? newValue){
                                      setState(() {
                                        isMobileMoney = newValue!;
                                        newValue == true ? paymentArrayValues.add('Mobile Money') : paymentArrayValues.remove('Mobile Money');
                                      });
                                      print(paymentArrayValues);
                                    }
                                ),
                                const Text('Mobile Money'),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                    value: isCard,
                                    onChanged: (bool? newValue){
                                      setState(() {
                                        isCard = newValue!;
                                        newValue == true ? paymentArrayValues.add('Card') : paymentArrayValues.remove('Card');
                                      });
                                      print(paymentArrayValues);
                                    }
                                ),
                                const Text('Card(Visa, Master Card)'),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),


                  // Sipping
                  const Text("Shipping",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 18)),
                  const SizedBox(height: 10),
                  const Text("Select shipping methods your store provides"),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                              value: isSameDayShipping,
                              onChanged: (bool? newValue){
                                setState(() {
                                  isSameDayShipping = newValue!;
                                  newValue == true ? shippingArrayValues.add('Same day shipping') : shippingArrayValues.remove('Same day shipping');
                                });
                                print(shippingArrayValues);
                              }
                          ),
                          const Text('Same day shiping'),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                              value: isTwoDayShipping,
                              onChanged: (bool? newValue){
                                setState(() {
                                  isTwoDayShipping = newValue!;
                                  newValue == true ? shippingArrayValues.add('2-day shipping') : shippingArrayValues.remove('2-day shipping');
                                });
                                print(shippingArrayValues);
                              }
                          ),
                          const Text('2-day shipping'),
                        ],
                      ),

                    ],
                  ),
                  const SizedBox(height: 30),

                  // Shop Logo
                  GestureDetector(
                    onTap: () {
                      openFile();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Add Shop Logo",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18)),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          width: 320,
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black26, width: 1)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 150,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 4),
                                decoration:
                                    const BoxDecoration(color: Color(0xFF7386EF)),
                                child: const Center(
                                  child: Text("Choose file",
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              displayLogo != '' ?
                              Container(
                                height: 50,
                                width: 50,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  image: imageUrl != '' ? DecorationImage(image: NetworkImage(imageUrl),fit: BoxFit.cover) : DecorationImage(image: NetworkImage(displayLogo),fit: BoxFit.cover),

                                ),
                              ) :
                              Text("${fileUploadedName == '' ? 'No file chosen' : fileUploadedName } "),

                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Shop Banner Image
                  GestureDetector(
                    onTap: () {
                      openbannerFile();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Add Shop Banner Image",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18)),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          width: 320,
                          decoration: BoxDecoration(
                              border:
                              Border.all(color: Colors.black26, width: 1)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 150,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 5),
                                decoration:
                                const BoxDecoration(color: Color(0xFF7386EF)),
                                child: const Center(
                                  child: Text("Choose file",
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              displayBanner != '' ?
                              Container(
                                height: 50,
                                width: 50,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  image: bannerUrl != '' ? DecorationImage(image: NetworkImage(bannerUrl),fit: BoxFit.cover) :  DecorationImage(image: NetworkImage(displayBanner),fit: BoxFit.cover),

                                ),
                              ) :
                              Text("${bannerUploadedName == '' ? 'No file chosen' : bannerUploadedName } "),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Shop Location
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Add Shop Location",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18)),
                      const SizedBox(height: 10),
                      Form(
                        key: _formkey,
                        child: TextFormField(
                          controller: _locationValue,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Field is required';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              hintText: 'Enter location here',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black))),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Update Button
                  GestureDetector(
                    onTap: () {
                      // Update Button logic here
                      updateSettings();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 260,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadiusDirectional.circular(10),
                              color: const Color(0xFF7386EF)),
                          child: loading == true ?
                          const Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 4)):
                          const Center(
                            child: Text("Update",
                                style: TextStyle(color: Colors.white)),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
