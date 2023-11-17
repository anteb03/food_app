import 'package:flutter/material.dart';
import 'package:aplikacija2/pages/products/products.dart';

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
      backgroundColor: Colors.white70,
      body: Padding(
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
                  ),
                  child: Image.network(
                    widget.selectedProduct.pictureURL,
                    height: fontSizeCoefficient * 150,
                    width: fontSizeCoefficient * 150,
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
                        fontSize: fontSizeCoefficient * 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: fontSizeCoefficient * 7),
                    Text(
                      'ID: ${widget.selectedProduct.ID.toString()}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: fontSizeCoefficient * 15,
                      ),
                    ),
                    SizedBox(height: fontSizeCoefficient * 7),
                    Text(
                      '${widget.selectedProduct.price.toString()} €',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: fontSizeCoefficient * 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: quantity == 1
                            ? null
                            : () {
                                setState(() {
                                  quantity -= 1;
                                });
                              },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (states) {
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
                      SizedBox(width: fontSizeCoefficient),
                      Text(
                        '$quantity',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: fontSizeCoefficient * 12),
                      ),
                      SizedBox(width: fontSizeCoefficient),
                      ElevatedButton(
                          onPressed: () {
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
                          ))
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
