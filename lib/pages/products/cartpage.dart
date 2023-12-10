import 'package:flutter/material.dart';
import 'package:aplikacija2/pages/products/products.dart';
import 'package:aplikacija2/pages/products/maincartpage.dart';

class CartPage extends StatefulWidget {
  final Product selectedProduct;

  const CartPage({Key? key, required this.selectedProduct}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int quantity = 1;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSizeCoefficient = screenHeight / 700;
    final paddingCoefficient = screenHeight / 100;
    return Scaffold(
      extendBodyBehindAppBar: true,
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
      backgroundColor: Colors.white.withOpacity(0.8),
      body: Stack(children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: paddingCoefficient * 2,
            vertical: paddingCoefficient * 4.5,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black12, width: 2.0),
                        borderRadius: BorderRadius.circular(15)),
                    child: Image.network(
                      widget.selectedProduct.pictureURL,
                      height: fontSizeCoefficient * 100,
                      width: fontSizeCoefficient * 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(width: fontSizeCoefficient * 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.selectedProduct.name,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: fontSizeCoefficient * 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: fontSizeCoefficient * 7),
                      Text(
                        'ID: ${widget.selectedProduct.ID.toString()}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: fontSizeCoefficient * 14,
                        ),
                      ),
                      SizedBox(height: fontSizeCoefficient * 7),
                      Text(
                        '${widget.selectedProduct.price.toString()} €',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: fontSizeCoefficient * 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: fontSizeCoefficient * 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 45 * fontSizeCoefficient,
                    height: 35 * fontSizeCoefficient,
                    child: ElevatedButton(
                      onPressed: quantity == 1
                          ? null
                          : () {
                              setState(() {
                                quantity -= 1;
                              });
                            },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>((states) {
                          if (states.contains(MaterialState.disabled)) {
                            return Colors.grey;
                          }
                          return Colors.red;
                        }),
                      ),
                      child: Center(
                        child: Text(
                          '-',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: fontSizeCoefficient * 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: fontSizeCoefficient * 10),
                  Text(
                    '$quantity',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: fontSizeCoefficient * 20),
                  ),
                  SizedBox(width: fontSizeCoefficient * 10),
                  SizedBox(
                    width: 45 * fontSizeCoefficient,
                    height: 35 * fontSizeCoefficient,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (states) {
                            if (states.contains(MaterialState.disabled)) {
                              return Colors.grey;
                            }
                            return Colors.green;
                          }),
                        ),
                        onPressed: quantity == 10
                            ? null
                            : () {
                                setState(() {
                                  quantity += 1;
                                });
                              },
                        child: Center(
                          child: Text(
                            '+',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: fontSizeCoefficient * 12),
                          ),
                        )),
                  )
                ],
              ),
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(vertical: paddingCoefficient * 3),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: fontSizeCoefficient * 60,
                width: fontSizeCoefficient * 250,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Colors.blue.withOpacity(0.35)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Cart.addToCart(widget.selectedProduct, quantity);
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(fontSizeCoefficient * 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Add to cart",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: fontSizeCoefficient * 20),
                        ),
                        SizedBox(width: fontSizeCoefficient * 5),
                        Icon(
                          Icons.shopping_cart,
                          size: fontSizeCoefficient * 20,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ))
      ]),
    );
  }
}
