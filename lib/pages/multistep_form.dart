import 'package:flutter/material.dart';
import 'package:shop_app/pages/cart_page.dart';
import 'package:shop_app/pages/checkout_page.dart';
import 'package:shop_app/model/formModel.dart';
import 'package:shop_app/viewModel/formsVM.dart';
import 'package:provider/provider.dart';

class MultiStepForm extends StatefulWidget {
  const MultiStepForm({super.key});

  @override
  State<MultiStepForm> createState() => _MultiStepFormState();
}

class _MultiStepFormState extends State<MultiStepForm> {

  // Form Key
  final _formkey = GlobalKey<FormState>();

  // Input Values
  final _emailValue = TextEditingController();
  final _nameValue = TextEditingController();
  final _phoneValue = TextEditingController();
  final _streetValue = TextEditingController();
  final _countryValue = TextEditingController();

  // Radio button value
  String groupValue = "";


  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    List<Step> getSteps() {
      return <Step>[
        //Contact Info
         Step(
            isActive: true,
            title: const Text("Shipping Information", style: TextStyle(fontWeight: FontWeight.w600,)),
            content: Expanded(
              child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              // Email Input
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Text("Email Address", style: TextStyle(fontWeight: FontWeight.w500)),
                                    ),

                                    TextFormField(
                                      controller: _emailValue,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a valid email address';
                                        }
                                        final bool emailValid = RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(value);
                                        if (!emailValid) {
                                          return 'Please enter a valid email address';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder()
                                      ),
                                    ),

                                  ],
                                ),
                              ),

                              // Name Input
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Text("Name", style: TextStyle(fontWeight: FontWeight.w500)),
                                    ),

                                    TextFormField(
                                      controller: _nameValue,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Name field is required';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder()
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Phone Input
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Text("Phone Number", style: TextStyle(fontWeight: FontWeight.w500)),
                                    ),

                                    TextFormField(
                                      controller: _phoneValue,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Phone No field is required';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(gapPadding: 5)
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Street Name
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Text("Street Name", style: TextStyle(fontWeight: FontWeight.w600)),
                                    ),

                                    TextFormField(
                                      controller: _streetValue,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Street field is required';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder()
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Country / Region
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Text("Country/Region", style: TextStyle(fontWeight: FontWeight.w600)),
                                    ),

                                    TextFormField(
                                      controller: _countryValue,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Country field is required';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder()
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )



                    ],
                  )
            ),
         ),

        // Payment Method
        Step(
          isActive: true,
          title: const Text("Payment Method", style: TextStyle(fontWeight: FontWeight.w600)),
          content: Column(
            children: [
              // Pay on Delivery Input
              Row(
                children: [
                  Radio(
                      value: 'Pay on delivery',
                      groupValue: groupValue,
                      onChanged: (value) {
                        setState(() {
                          groupValue = value!;
                        });
                      }
                  ),
                  const Text("Pay on Delivery")
                ],
              ),

              // Mobile Money Input
              Row(
                children: [
                  Radio(
                      value: 'Mobile Money',
                      groupValue: groupValue,
                      onChanged: (value) {
                        setState(() {
                          groupValue = value!;
                        });
                      }
                  ),
                  const Text("Mobile Money")
                ],
              ),

              // Mobile Money Input
              Row(
                children: [
                  Radio(
                      value: 'Visa Card',
                      groupValue: groupValue,
                      onChanged: (value) {
                        setState(() {
                          groupValue = value!;
                        });
                      }
                  ),
                  const Text("Visa Card")
                ],
              ),


            ],
          )
        )
      ];
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
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
                        return CartPage(productId: 0,);
                      }));
            },
          ),
        ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Stepper(
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() {
                  _currentStep--;
                });
              }
            },
            currentStep: _currentStep,
            onStepContinue: () {
              if(_formkey.currentState!.validate()){
                final _isLastStep = _currentStep == getSteps().length - 1;
                if (_isLastStep) {

                  // Get the form data from the input fields
                  // FormData data = FormData(
                  //   name: _nameValue.text,
                  //   email: _emailValue.text,
                  //   phoneNumber: _phoneValue.text,
                  //   streetName: _streetValue.text,
                  //   country: _countryValue.text,
                  //   paymentMethod: groupValue,
                  // );

                  // Save the form data using the provider
                  // Provider.of<FormDataModel>(context, listen: false)
                  //     .saveFormData(data);
                  Navigator.push(
                      context,
                      // MaterialPageRoute(builder: (context) => const ProductDetails()),
                      PageRouteBuilder(
                          transitionDuration:
                          const Duration(milliseconds: 400),
                          transitionsBuilder: (context, animation,
                              secondaryAnimation, child) {
                            const begin = Offset(-1.0,
                                0.0); // Start off the screen to the left
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
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return const CheckoutPage();
                          }));
                } else {
                  setState(() {
                    _currentStep++;
                  });
                }
              } else {
                print("Fields Required");
              }

            },
            steps: getSteps(),
          ),
        ],
      )


    );
  }
}