import 'package:aplikacija2/help/authentification.dart';
import 'package:aplikacija2/help/help.dart';
import 'package:aplikacija2/pages/products/cartpage.dart';
import 'package:aplikacija2/pages/products/products.dart';
import 'package:aplikacija2/pages/verification/verification1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aplikacija2/help/displaygreetings.dart';
import 'package:aplikacija2/help/loadingskeleton.dart';

class Display1 extends StatefulWidget {
  const Display1({super.key});

  @override
  State<Display1> createState() => _Display1State();
}

class _Display1State extends State<Display1> {
  AuthService authService = AuthService();
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  bool isEmailVerified = false;
  String username = "";
  bool isFruits = false;
  bool isVegetables = false;
  bool isOthers = false;
  bool isAll = true;
  bool isSearching = false;
  List<Product> allProducts = [];
  List<Product> fruits = [];
  List<Product> vegetables = [];
  List<Product> others = [];
  List<Product> selectedProduct = [];

  @override
  void initState() {
    super.initState();
    checkIsEmailVerified();
    getUserData();
  }

  getUserData() async {
    await Helpfunction.getUserNameSf().then((val) {
      setState(() {
        username = val!;
      });
    });
  }

  void checkIsEmailVerified() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isVerified = prefs.getBool('isEmailVerified');
    if (isVerified != null && isVerified) {
      setState(() {
        isEmailVerified = true;
      });
    }
    if (!isEmailVerified) {
      checkEmailVerification();
    }
  }

  Future checkEmailVerification() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isEmailVerified', isEmailVerified);
  }

  Future<void> loadProducts() async {
    Map<String, List<Product>> productsMap = await getAllProducts();
    allProducts = [];
    allProducts.addAll(productsMap['fruits'] ?? []);
    allProducts.addAll(productsMap['vegetables'] ?? []);
    allProducts.addAll(productsMap['others'] ?? []);
    fruits = productsMap['fruits'] ?? [];
    vegetables = productsMap['vegetables'] ?? [];
    others = productsMap['others'] ?? [];
  }

  void addToCart(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartPage(selectedProduct: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSizeCoefficient = screenHeight / 700;
    final paddingCoefficient = screenHeight / 100;
    return Scaffold(
        body: !isEmailVerified
            ? Center(
                child: Scaffold(
                  backgroundColor: Colors.white70,
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_rounded,
                        size: fontSizeCoefficient * 40,
                        color: Colors.black,
                      ),
                      SizedBox(
                        height: fontSizeCoefficient * 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Verify your account to order.",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: fontSizeCoefficient * 14,
                            ),
                          ),
                          SizedBox(
                            width: fontSizeCoefficient * 5,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Verification1(),
                                ),
                              );
                            },
                            child: Text(
                              "Verify there!",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: fontSizeCoefficient * 14,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            : Scaffold(
                backgroundColor: Colors.white70,
                body: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: paddingCoefficient * 2,
                    vertical: paddingCoefficient * 4.5,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const DisplayGreetings(),
                          Text(
                            username,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: fontSizeCoefficient * 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: fontSizeCoefficient * 20,
                      ),
                      TextField(
                        onTap: () {
                          setState(() {
                            isSearching = true;
                            isAll = true;
                          });
                        },
                        cursorColor: Colors.black,
                        controller: searchController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey,
                          hintText: "Search products for example: Apple ",
                          hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: fontSizeCoefficient * 12),
                          prefixIcon: Icon(Icons.search,
                              size: fontSizeCoefficient * 20,
                              color: Colors.black),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: fontSizeCoefficient * 13,
                            horizontal: fontSizeCoefficient * 15,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius:
                                BorderRadius.circular(30 * fontSizeCoefficient),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius:
                                BorderRadius.circular(fontSizeCoefficient * 30),
                          ),
                        ),
                        onChanged: (query) {
                          setState(() {
                            searchQuery = query;
                            isSearching = query.isNotEmpty;
                            isFruits = false;
                            isVegetables = false;
                            isOthers = false;
                          });
                        },
                      ),
                      SizedBox(
                        height: fontSizeCoefficient * 20,
                      ),
                      if (isSearching)
                        Expanded(
                          child: FutureBuilder(
                            future: loadProducts(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return buildProductList();
                              } else if (snapshot.hasError) {
                                return Text(
                                  'Error loading products: ${snapshot.error}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: fontSizeCoefficient * 14,
                                  ),
                                );
                              } else {
                                return LoadingSkeleton();
                              }
                            },
                          ),
                        )
                      else
                        Expanded(
                          child: Column(children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: fontSizeCoefficient * 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      setState(() {
                                        isAll = true;
                                        isFruits = false;
                                        isVegetables = false;
                                        isOthers = false;
                                      });
                                    },
                                    child: Text(
                                      "All",
                                      style: TextStyle(
                                        color:
                                            isAll ? Colors.blue : Colors.black,
                                        fontSize: fontSizeCoefficient * 12,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: fontSizeCoefficient * 30),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      setState(() {
                                        isAll = false;
                                        isFruits = true;
                                        isVegetables = false;
                                        isOthers = false;
                                      });
                                    },
                                    child: Text(
                                      "Fruits",
                                      style: TextStyle(
                                        color: isFruits
                                            ? Colors.blue
                                            : Colors.black,
                                        fontSize: fontSizeCoefficient * 12,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: fontSizeCoefficient * 30),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      setState(() {
                                        isAll = false;
                                        isFruits = false;
                                        isVegetables = true;
                                        isOthers = false;
                                      });
                                    },
                                    child: Text(
                                      "Vegetables",
                                      style: TextStyle(
                                        color: isVegetables
                                            ? Colors.blue
                                            : Colors.black,
                                        fontSize: fontSizeCoefficient * 12,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: fontSizeCoefficient * 30),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      setState(() {
                                        isAll = false;
                                        isFruits = false;
                                        isVegetables = false;
                                        isOthers = true;
                                      });
                                    },
                                    child: Text(
                                      "Others",
                                      style: TextStyle(
                                        color: isOthers
                                            ? Colors.blue
                                            : Colors.black,
                                        fontSize: fontSizeCoefficient * 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: fontSizeCoefficient * 10),
                            Expanded(
                              child: FutureBuilder(
                                future: loadProducts(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return buildProductList();
                                  } else if (snapshot.hasError) {
                                    return Text(
                                      'Error loading products: ${snapshot.error}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: fontSizeCoefficient * 14,
                                      ),
                                    );
                                  } else {
                                    return LoadingSkeleton();
                                  }
                                },
                              ),
                            ),
                          ]),
                        ),
                    ],
                  ),
                ),
              ));
  }

  Widget buildProductList() {
    List<dynamic>? products;
    if (isAll) {
      products = allProducts
          .where((product) =>
              product.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    } else if (isFruits) {
      products = fruits;
    } else if (isVegetables) {
      products = vegetables;
    } else if (isOthers) {
      products = others;
    }

    return ListView.builder(
      itemCount: (products!.length / 2).ceil(),
      itemBuilder: (context, index) {
        final firstProductIndex = index * 2;
        final secondProductIndex = index * 2 + 1;

        return Row(
          children: [
            if (firstProductIndex < products!.length)
              Expanded(
                child: buildProductCard(products[firstProductIndex]),
              ),
            if (secondProductIndex < products.length)
              Expanded(
                child: buildProductCard(products[secondProductIndex]),
              ),
          ],
        );
      },
    );
  }

  Widget buildProductCard(dynamic product) {
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSizeCoefficient = screenHeight / 700;
    return InkWell(
      onTap: () {
        addToCart(product);
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: Colors.black.withOpacity(0.2), width: 1)),
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: Image.network(
                product.pictureURL,
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
            ListTile(
              title: Text(
                product.name,
                style: TextStyle(
                    fontSize: fontSizeCoefficient * 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'ID: ${product.ID.toString()}',
                    style: TextStyle(
                        fontSize: fontSizeCoefficient * 12,
                        color: Colors.black),
                  ),
                  Text(
                    '${product.price.toString()} €',
                    style: TextStyle(
                        fontSize: fontSizeCoefficient * 12,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
