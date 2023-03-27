import 'package:flutter/cupertino.dart';

class Product with ChangeNotifier {
  final String id, title, description, imageUrl;
  final double price;
  final bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isFavorite = false,
  });
}
