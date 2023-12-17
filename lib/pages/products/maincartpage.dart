import 'package:aplikacija2/map/gmap.dart';
import 'package:flutter/material.dart';
import 'products.dart';
import 'package:flutter/services.dart';

class Cart extends StatefulWidget {
  final Map<Product, int>? items;

  const Cart({Key? key, this.items}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();

  static List<ProductQuantity> cartItems = [];
  static String deliveryAdress = "";

  static void addToCart(Product product, int quantity) {
    final existingIndex = cartItems.indexWhere(
      (item) => item.product.ID == product.ID,
    );

    if (existingIndex != -1) {
      cartItems[existingIndex].quantity += quantity;
    } else {
      cartItems.add(ProductQuantity(product: product, quantity: quantity));
    }
  }

  static void removeFromCart(ProductQuantity product) {
    cartItems.remove(product);
  }

  static double calculateProductPrice() {
    double total = 0;
    for (var item in cartItems) {
      total += item.product.price * item.quantity;
    }
    return total;
  }

  static double calculateTotalPrice() {
    double total = 0;
    double shippingFee = 4.99;
    for (var item in cartItems) {
      total += item.product.price * item.quantity;
    }
    total += shippingFee;
    return total;
  }

  static void getAdress(String adress) {
    deliveryAdress = adress;
  }
}

class ProductQuantity {
  final Product product;
  int quantity;

  ProductQuantity({
    required this.product,
    required this.quantity,
  });
}

class _CartState extends State<Cart> {
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    addressController.text = Cart.deliveryAdress;
  }

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSizeCoefficient = screenHeight / 700;
    final paddingCoefficient = screenHeight / 100;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
          child: SizedBox(
            height: 10,
            width: 10,
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: fontSizeCoefficient * 20,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.grey.withOpacity(0.9),
      body: Cart.cartItems.isEmpty
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Cart is empty, add products!",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: fontSizeCoefficient * 14,
                  ),
                ),
              ],
            )
          : Stack(
              fit: StackFit.expand,
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: paddingCoefficient * 2,
                    ),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 280,
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return SizedBox(height: fontSizeCoefficient * 7);
                        },
                        shrinkWrap: true,
                        itemCount: Cart.cartItems.length,
                        itemBuilder: (context, index) {
                          final entry = Cart.cartItems[index];
                          return Container(
                            width: double.infinity,
                            height: fontSizeCoefficient * 130,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                fontSizeCoefficient * 16,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(
                                15 * fontSizeCoefficient,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Image.network(
                                      entry.product.pictureURL,
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10 * fontSizeCoefficient,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                entry.product.name,
                                                style: TextStyle(
                                                  fontSize:
                                                      13 * fontSizeCoefficient,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      Cart.removeFromCart(
                                                          entry);
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: Colors.black,
                                                    size: fontSizeCoefficient *
                                                        20,
                                                  ))
                                            ]),
                                        SizedBox(
                                          height: fontSizeCoefficient * 2,
                                        ),
                                        Text(
                                          "ID: ${entry.product.ID.toString()}",
                                          style: TextStyle(
                                            fontSize: 13 * fontSizeCoefficient,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: fontSizeCoefficient * 2,
                                        ),
                                        Text(
                                          "Price: ${entry.product.price.toString()} €",
                                          style: TextStyle(
                                            fontSize: 13 * fontSizeCoefficient,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Quantity: ",
                                                style: TextStyle(
                                                  fontSize:
                                                      13 * fontSizeCoefficient,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      width:
                                                          fontSizeCoefficient *
                                                              20,
                                                      height:
                                                          fontSizeCoefficient *
                                                              20,
                                                      decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                              color:
                                                                  Colors.black,
                                                              width: 1 *
                                                                  fontSizeCoefficient)),
                                                      child: Material(
                                                        color:
                                                            Colors.transparent,
                                                        shape:
                                                            const CircleBorder(),
                                                        child: InkWell(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  fontSizeCoefficient *
                                                                      15),
                                                          onTap: () {
                                                            setState(() {
                                                              if (entry
                                                                      .quantity >
                                                                  1) {
                                                                entry.quantity -=
                                                                    1;
                                                              }
                                                            });
                                                          },
                                                          child: Center(
                                                            child: Icon(
                                                              Icons.remove,
                                                              color:
                                                                  Colors.white,
                                                              size:
                                                                  fontSizeCoefficient *
                                                                      17,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          fontSizeCoefficient *
                                                              7,
                                                    ),
                                                    Text(
                                                      entry.quantity.toString(),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize:
                                                              fontSizeCoefficient *
                                                                  13),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          fontSizeCoefficient *
                                                              7,
                                                    ),
                                                    Container(
                                                      width:
                                                          fontSizeCoefficient *
                                                              20,
                                                      height:
                                                          fontSizeCoefficient *
                                                              20,
                                                      decoration: BoxDecoration(
                                                          color: Colors.black,
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                              color:
                                                                  Colors.black,
                                                              width: 1 *
                                                                  fontSizeCoefficient)),
                                                      child: Material(
                                                        color:
                                                            Colors.transparent,
                                                        shape:
                                                            const CircleBorder(),
                                                        child: InkWell(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  fontSizeCoefficient *
                                                                      15),
                                                          onTap: () {
                                                            setState(() {
                                                              entry.quantity +=
                                                                  1;
                                                            });
                                                          },
                                                          child: Center(
                                                            child: Icon(
                                                              Icons.add,
                                                              color:
                                                                  Colors.white,
                                                              size:
                                                                  fontSizeCoefficient *
                                                                      17,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ])
                                            ]),
                                        SizedBox(
                                          height: fontSizeCoefficient * 2,
                                        ),
                                        Text(
                                          'Total: ${(entry.product.price * entry.quantity).toStringAsFixed(2)} €',
                                          style: TextStyle(
                                            fontSize: 13 * fontSizeCoefficient,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: paddingCoefficient * 2,
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: fontSizeCoefficient * 140,
                      width: fontSizeCoefficient * 310,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 0),
                            ),
                          ],
                          borderRadius:
                              BorderRadius.circular(fontSizeCoefficient * 12)),
                      child: Center(
                        child: SizedBox(
                          height: fontSizeCoefficient * 115,
                          width: fontSizeCoefficient * 275,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Icon(
                                  Icons.local_shipping_sharp,
                                  color: Colors.black,
                                  size: fontSizeCoefficient * 17,
                                ),
                                SizedBox(
                                  width: fontSizeCoefficient * 5,
                                ),
                                Text(
                                  "Shipping fee: 4.99 €",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: fontSizeCoefficient * 14),
                                ),
                              ]),
                              SizedBox(
                                height: fontSizeCoefficient * 8,
                              ),
                              Row(children: [
                                Icon(
                                  Icons.payments,
                                  color: Colors.black,
                                  size: fontSizeCoefficient * 17,
                                ),
                                SizedBox(
                                  width: fontSizeCoefficient * 5,
                                ),
                                Text(
                                  "Products cost: ${Cart.calculateProductPrice().toStringAsFixed(2)} €",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: fontSizeCoefficient * 14),
                                ),
                              ]),
                              SizedBox(
                                height: fontSizeCoefficient * 10,
                              ),
                              InkWell(
                                onTap: () {
                                  showAdress(context);
                                },
                                child: SizedBox(
                                    width: double.infinity,
                                    height: fontSizeCoefficient * 60,
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.blue.withOpacity(0.6),
                                            borderRadius: BorderRadius.circular(
                                                fontSizeCoefficient * 16)),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  20 * fontSizeCoefficient),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Order for ${Cart.calculateTotalPrice().toStringAsFixed(2)} €",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        fontSizeCoefficient *
                                                            18),
                                              ),
                                              Container(
                                                height: 50,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius: BorderRadius
                                                        .circular(12 *
                                                            fontSizeCoefficient)),
                                                child: Icon(
                                                  Icons.arrow_upward,
                                                  color: Colors.white,
                                                  size:
                                                      fontSizeCoefficient * 21,
                                                ),
                                              )
                                            ],
                                          ),
                                        ))),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void showAdress(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSizeCoefficient = screenHeight / 700;
    final paddingCoefficient = screenHeight / 100;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
            ),
            height: MediaQuery.of(context).size.height * 0.45,
            child: Padding(
              padding: EdgeInsets.all(paddingCoefficient * 2),
              child: Column(
                children: [
                  Container(
                    height: 5 * fontSizeCoefficient,
                    width: 30 * fontSizeCoefficient,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius:
                            BorderRadius.circular(fontSizeCoefficient * 30)),
                  ),
                  SizedBox(height: fontSizeCoefficient * 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50 * fontSizeCoefficient,
                    child: TextField(
                      controller: addressController,
                      readOnly: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GMap(),
                          ),
                        ).then((value) {
                          setState(() {
                            addressController.text = Cart.deliveryAdress;
                          });
                        });
                      },
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black54,
                                width: 1 * fontSizeCoefficient),
                            borderRadius: BorderRadius.circular(
                                10.0 * fontSizeCoefficient),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black54,
                                width: 1 * fontSizeCoefficient),
                            borderRadius: BorderRadius.circular(
                                10.0 * fontSizeCoefficient),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                10.0 * fontSizeCoefficient),
                          ),
                          hintText: "Enter address to deliver",
                          hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: fontSizeCoefficient * 13),
                          prefixIcon: Icon(
                            Icons.location_pin,
                            color: Colors.black,
                            size: fontSizeCoefficient * 22,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: fontSizeCoefficient * 10,
                  ),
                  SizedBox(
                    height: 130 * fontSizeCoefficient,
                    width: double.infinity,
                    child: TextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                      ],
                      cursorColor: Colors.black,
                      maxLines: 6,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.black54,
                              width: 1 * fontSizeCoefficient),
                          borderRadius:
                              BorderRadius.circular(10.0 * fontSizeCoefficient),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.black54,
                              width: 1 * fontSizeCoefficient),
                          borderRadius:
                              BorderRadius.circular(10.0 * fontSizeCoefficient),
                        ),
                        hintText: "Note for delivery",
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: fontSizeCoefficient * 13,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: fontSizeCoefficient * 10,
                  ),
                  Container(
                      height: fontSizeCoefficient * 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.9), width: 1),
                        borderRadius:
                            BorderRadius.circular(fontSizeCoefficient * 15),
                        color: Colors.blue.withOpacity(0.7),
                      ),
                      child: Center(
                          child: Text(
                        "Confirm delivery !",
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.85),
                            fontSize: fontSizeCoefficient * 16),
                      )))
                ],
              ),
            ),
          );
        });
  }
}
