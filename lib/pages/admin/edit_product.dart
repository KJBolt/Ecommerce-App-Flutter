import 'package:flutter/material.dart';
import 'package:shop_app/pages/admin/products_page.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:toastification/toastification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProductPage extends StatefulWidget {
  const EditProductPage({super.key, required this.id});
  final int id;


  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late int productId;
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  late String imageUrl = '';
  late String imagePreview = '';
  bool galleryOpened = false;

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

  // Input Controllers
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _price = TextEditingController();

  //get shop details
  Future<void> fetchData(int? id) async {
    try {
      final apiEndpoint = dotenv.env['API_KEY'];
      final url = '${apiEndpoint}/product';
      final response = await http.get(Uri.parse('$url/$id'));
      final data = jsonDecode(response.body);

      if (data['status'] == 200) {
        print(data['products']['image_url']);
        setState(() {
          imagePreview = data['products']['image_url'];
        });
        _name.text = data['products']['name'] ?? "";
        _description.text = data['products']['description'] ?? "";
        _price.text = data['products']['price'] ?? "";
        productId = data['products']['id'] ?? " ";
      } else {}
    } catch (error) {
      print(error);
    }

  }

  @override
  void initState() {
    super.initState();
    fetchData(widget.id);
  }

  late String filePath = "";
  @override
  Widget build(BuildContext context) {
    void openFile() async {
      setState(() {
        galleryOpened = true;
      });
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
        // print(file.name);
        // print(file.bytes);
        // print(file.extension);
        // print(file.path);
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

    Future<void> updateProduct() async {
      setState(() {
        loading = true;
      });
        String? token = await retrieveToken();
        // Map<String, dynamic> bodyData = {
        //   'name': _name.text,
        //   'description': _description.text,
        //   'price': _price.text,
        //   'featured_image': filePath,
        // };
        final apiEndpoint = dotenv.env['API_KEY'];
        final uri = Uri.parse("${apiEndpoint}/product/${productId}");

        try {
          // Response
          final request = http.MultipartRequest('POST', uri)
            ..headers['Authorization'] = 'Bearer $token'
            ..fields['name'] = _name.text
            ..fields['description'] = _description.text
            ..fields['price'] = _price.text
            ..fields['image_url'] = imageUrl == '' ? imagePreview : imageUrl;
          // if (imageUrl.isNotEmpty) {
          //  request.files.add(
          //    await http.MultipartFile.fromPath('featured_image', filePath));
          // }


          final response = await request.send();
          print(response);

          // final data = jsonDecode(response.body);
          // print("Response => ${data}");
          if (response.statusCode == 200) {

            // Clear Input values
            _name.clear();
            _description.clear();
            _price.clear();
            setState(() {
              loading = false;
            });

            showSuccessToast('Product updated successfully');
            Future.delayed(const Duration(milliseconds: 3000), redirectHomePage);
          } else {
            showErrorToast("Failed to update product");
            setState(() {
              loading = false;
            });
          }
        } catch (error) {
          showErrorToast("Updating Product Failed. Try Again");
          setState(() {
            loading = false;
          });
        }
    }

    // Future<void> updateProductNew() async {
    //   String? token = await retrieveToken();
    //   Map<String, dynamic> bodyData = {
    //     'name': _name.text,
    //     'description': _description.text,
    //     'price': _price.text,
    //   };
    //   final apiEndpoint = dotenv.env['API_KEY'];
    //   final uri = Uri.parse("${apiEndpoint}/product/${widget.id}");
    //   final headers = {'Authorization': 'Bearer $token'};
    //   final response = await http.put(uri, headers: headers, body:bodyData);
    //   print(response.body);
    // }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        title: const Text("Edit Product", style: TextStyle(fontSize: 18)),
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
        scrollDirection: Axis.vertical,
        children: [
          Container(
            height: 900,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            margin: const EdgeInsets.symmetric(horizontal: 15,),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView(
              children: [
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      // Product Name
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Product Name',  style: TextStyle(fontSize: 15)),
                        ],
                      ),
                      const SizedBox(height: 5),

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
                      const SizedBox(height: 15),

                      // Product Price
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Product Price (GHC)', style: TextStyle(fontSize: 15)),
                        ],
                      ),
                      const SizedBox(height: 5),
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
                      const SizedBox(height: 15),

                      // Product Desc
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Product Description', style: TextStyle(fontSize: 15)),
                        ],
                      ),
                      const SizedBox(height: 5),
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
                      const SizedBox(height: 15),



                      // Image
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Product Image', style: TextStyle(fontSize: 15)),
                        ],
                      ),
                      const SizedBox(height: 5),
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
                                        decoration: BoxDecoration(
                                            image: DecorationImage(image: NetworkImage(imagePreview), fit: BoxFit.cover),
                                        ),
                                      ),
                                const Center(
                                  child: Icon(Icons.camera_alt_outlined,
                                      size: 30, color: Colors.white),
                                ),
                                Positioned(
                                    right: 10,
                                    top: 5,
                                    child: filePath != ""
                                        ? Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                                color: Colors.white30,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: const Icon(Icons.close,
                                                color: Colors.black),
                                          )
                                        : const Text(""))
                              ],
                            )),
                      ),

                      // Button

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          galleryOpened && imageUrl == '' ? GestureDetector(
                            child: Container(
                                margin: const EdgeInsets.only(top: 20),
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                height: 50,
                                width: 150,
                                decoration: BoxDecoration(
                                    color:Colors.blueAccent.shade100,
                                    borderRadius: BorderRadius.circular(10)),
                                child: loading == true ?
                                const Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 4)):
                                const Center(
                                  child:  Text("Loading...",
                                      style: TextStyle(color: Colors.white)
                                  ),
                                )
                            ),
                          ) :
                          GestureDetector(
                            onTap: () {
                              if (_formkey.currentState!.validate()) {
                                // Edit Product Logic here
                                updateProduct();
                              } else {
                                print("Not validated");
                              }
                            },
                            child: Container(
                                margin: const EdgeInsets.only(top: 10),
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                height: 50,
                                width: 150,
                                decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(10)),
                                child: loading == true ?
                                const Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 4)):
                                const Center(
                                  child:  Text("Update",
                                      style: TextStyle(color: Colors.white)
                                  ),
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
