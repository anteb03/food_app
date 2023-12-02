import 'package:flutter/material.dart';
import 'products.dart';

class Cart extends StatefulWidget {
  final Map<Product, int>? items;

  const Cart({Key? key, this.items}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();

  static List<ProductQuantity> cartItems = [];

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

  static double calculateTotalPrice() {
    double total = 0;
    for (var item in cartItems) {
      total += item.product.price * item.quantity;
    }
    return total;
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
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSizeCoefficient = screenHeight / 700;
    final paddingCoefficient = screenHeight / 100;

    return Scaffold(
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
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: paddingCoefficient * 2,
                    ),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 100,
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
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                fontSizeCoefficient * 16,
                              ),
                              border: Border.all(
                                color: Colors.black.withOpacity(0.7),
                                width: 1.0,
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
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black.withOpacity(0.2),
                                        ),
                                      ),
                                      child: Image.network(
                                        entry.product.pictureURL,
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.contain,
                                      ),
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
                                        SizedBox(
                                          height: fontSizeCoefficient * 2,
                                        ),
                                        Text(
                                          "Quantity: ${entry.quantity.toString()}",
                                          style: TextStyle(
                                            fontSize: 13 * fontSizeCoefficient,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          height: fontSizeCoefficient * 2,
                                        ),
                                        Text(
                                          'Total price: ${(entry.product.price * entry.quantity).toStringAsFixed(2)} €',
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
                    vertical: paddingCoefficient * 3,
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: fontSizeCoefficient * 60,
                      width: fontSizeCoefficient * 250,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.blue.withAlpha(120),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                        ),
                        onPressed: () {},
                        child: Padding(
                          padding: EdgeInsets.all(
                            fontSizeCoefficient * 20,
                          ),
                          child: Center(
                            child: Text(
                              "Order for ${Cart.calculateTotalPrice().toStringAsFixed(2)} €",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: fontSizeCoefficient * 20,
                              ),
                            ),
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
}
