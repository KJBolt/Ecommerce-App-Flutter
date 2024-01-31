import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/pages/admin/orders_page.dart';
import 'package:shop_app/pages/admin/products_page.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:toastification/toastification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  late String filePath = "";
  bool loading = false;
  late String imageUrl = '';

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

  // static void hideLoadingDialog(BuildContext context) {
  //   Navigator.of(context).pop();
  // }

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();



  // Input Controllers
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _price = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _formkey = GlobalKey<FormState>();

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

  // Redirect to HomePage Function
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
              return const ProductsPage();
            }));
  }

      //retrieve token
  Future<String?> retrieveToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retrieve the token
    String? token = prefs.getString('token');
    return token;
  }


    Future<void> addProduct() async {
    // Set loading to true
    setState(() {
      loading = true;
    });
    String? token = await retrieveToken();
      final apiEndpoint = dotenv.env['API_KEY'];
      final uri = Uri.parse("${apiEndpoint}/product/store");
      try {
        // Response
          final request = http.MultipartRequest('POST',uri)
            ..headers['Authorization'] = 'Bearer $token'
            ..fields['name'] = _name.text
            ..fields['description'] = _description.text
            ..fields['price'] = _price.text
            ..fields['image_url'] = imageUrl;
          // ..files.add(await http.MultipartFile.fromPath('featured_image', imageUrl));

          final response = await request.send();

          // final data = jsonDecode(response.body);
          // print("Response => ${data}");
          if (response.statusCode == 200) {

            // Set loading to false
            setState(() {
              loading = false;
            });
            // Clear Input values
            _name.clear();
            _description.clear();
            _price.clear();

            showSuccessToast('Product added successfully');
            Future.delayed(const Duration(milliseconds: 3000), redirectHomePage);


        } else {
          showErrorToast("Failed to add product");
        }
      } catch (error) {
        print(error);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: const Text("Add Product", style: TextStyle(fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF545D68)),
          onPressed: () {
            Navigator.push(
                context,
                // MaterialPageRoute(builder: (context) => const ProductDetails()),
                PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 400),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin =
                          Offset(-1.0, 0.0); // Start off the screen to the left
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
                      return const ProductsPage();
                    }));
          },
        ),
      ),
      body: ListView(
        children: [
          Container(
            height: 600,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.grey.withOpacity(0.3),
              //     spreadRadius: 1,
              //     blurRadius: 2,
              //     offset: const Offset(0, 1),
              //   ),
              // ],
            ),
            child: ListView(
              children: [
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      // Product Name
                      TextFormField(
                        controller: _name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Product name field required';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            hintText: 'Product Name',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                      ),
                      const SizedBox(height: 20),

                      // Product Desc
                      TextFormField(
                        controller: _description,
                        maxLines: 4,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Description field required';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            hintText: 'Product Description',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                      ),
                      const SizedBox(height: 20),

                      // Product Price
                      TextFormField(
                        controller: _price,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Price field required';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            hintText: 'Price',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                      ),
                      const SizedBox(height: 20),

                      // Image
                      GestureDetector(
                        onTap: () {
                          openFile();
                        },
                        child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              border: Border.all(color: Colors.white30),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              children: [
                                filePath != ""
                                    ? Image.file(
                                  File(filePath),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                )
                                    : Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.blueGrey),
                                ),
                                const Center(
                                  child: Icon(Icons.camera_alt_outlined,
                                      size: 30, color: Colors.white),
                                ),
                                // Positioned(
                                //     right: 10,
                                //     top: 5,
                                //     child: filePath != ""
                                //         ? Container(
                                //       padding: const EdgeInsets.all(2),
                                //       decoration: BoxDecoration(
                                //           color: Colors.white30,
                                //           borderRadius:
                                //           BorderRadius.circular(20)),
                                //       child: const Icon(Icons.close,
                                //           color: Colors.black),
                                //     )
                                //         : const Text(""))
                              ],
                            )
                        ),
                      ),

                      // Button

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (_formkey.currentState!.validate()) {
                                addProduct();
                              } else {
                                print("Not validated");
                              }
                            },
                            child: Container(
                                margin: const EdgeInsets.only(top: 20),
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                height: 50,
                                width: 150,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10)),
                                child: loading == true ?
                                const Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 4)):
                                const Center(
                                  child: Text("Add Product",
                                      style: TextStyle(color: Colors.white)),
                                )
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),

    );
  }
}
