import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Product with ChangeNotifier {
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isFavorite = false,
  });

  final String id, title, description, imageUrl;
  bool isFavorite;
  final double price;

  Future<void> favorite(String token, String userId) async {
    final url =
        "https://flutter-app-58445-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token";
    try {
      final response = await http.put(
        Uri.parse(url),
        body: json.encode(
          !isFavorite,
        ),
      );
      if (response.statusCode < 400) {
        isFavorite = !isFavorite;
        notifyListeners();
      } else {
        throw const HttpException("Catch an error");
      }
    } catch (e) {
      rethrow;
    }
  }
}
