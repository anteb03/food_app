import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final int ID;
  final String name;
  final String pictureURL;
  final double price;

  Product({
    required this.ID,
    required this.name,
    required this.pictureURL,
    required this.price,
  });
}

Future<Map<String, List<Product>>> getAllProducts() async {
  Map<String, List<Product>> productsMap = {};

  QuerySnapshot fruitsSnapshot =
      await FirebaseFirestore.instance.collection('fruits').get();
  QuerySnapshot vegetablesSnapshot =
      await FirebaseFirestore.instance.collection('vegetables').get();
  QuerySnapshot othersSnapshot =
      await FirebaseFirestore.instance.collection('others').get();

  productsMap['fruits'] = _mapQuerySnapshotToProducts(fruitsSnapshot);
  productsMap['vegetables'] = _mapQuerySnapshotToProducts(vegetablesSnapshot);
  productsMap['others'] = _mapQuerySnapshotToProducts(othersSnapshot);

  return productsMap;
}

List<Product> _mapQuerySnapshotToProducts(QuerySnapshot snapshot) {
  return snapshot.docs.map((doc) {
    int ID = doc['ID'];
    String name = doc['name'];
    String pictureURL = doc['pictureURL'];
    double price = doc['price'].toDouble();

    return Product(
      ID: ID,
      name: name,
      pictureURL: pictureURL,
      price: price,
    );
  }).toList();
}
