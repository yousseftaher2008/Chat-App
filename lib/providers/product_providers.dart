import 'package:flutter/material.dart';

import 'product.dart';

class Products with ChangeNotifier {
  final List<Product> _products = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
        id: 'p2',
        title: 'Trousers',
        description: 'A nice pair of trousers.',
        price: 59.99,
        imageUrl:
            'https://th.bing.com/th/id/OIP.QgtLpJF4-lFqltBe0NT7-gHaHa?pid=ImgDet&rs=1'),
  ];

  Product findById(String id) {
    return _products.firstWhere(
      (product) => product.id == id,
    );
  }

  List<Product> get products {
    return [..._products];
  }
}
