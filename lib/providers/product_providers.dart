import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  String authToken;
  String userId;
  List<Product> _products;
  Products(this.authToken, this.userId, this._products);

  Product findById(String id) {
    return _products.firstWhere(
      (product) => product.id == id,
    );
  }

  List<Product> get products {
    return [..._products];
  }

  List<Product> get favoriteProducts {
    return _products.where((element) => element.isFavorite).toList();
  }

  Future<void> getData() async {
    var url =
        "https://flutter-app-58445-default-rtdb.firebaseio.com/products.json?auth=$authToken";
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body);

      if (extractedData == null) {
        _products = [];
        notifyListeners();
        return;
      }
      url =
          "https://flutter-app-58445-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken";
      final favoriteResponse = await http.get(Uri.parse(url));
      final favoriteData = jsonDecode(favoriteResponse.body);
      List<Product> loadedData = [];
      (extractedData as Map<String, dynamic>).forEach((prodId, prodData) {
        loadedData.add(
          Product(
            id: prodId,
            title: prodData["title"],
            description: prodData["description"],
            imageUrl: prodData["imageUrl"],
            price: prodData["price"],
            isFavorite: favoriteData == null || favoriteData[prodId] == null
                ? false
                : favoriteData[prodId],
          ),
        );
      });
      _products = loadedData;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        "https://flutter-app-58445-default-rtdb.firebaseio.com/products.json?auth=$authToken";
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': product.title,
          "description": product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          "isFavorite": product.isFavorite,
        }),
      );
      _products.add(
        Product(
            id: json.decode(response.body)['name'],
            title: product.title,
            description: product.description,
            imageUrl: product.imageUrl,
            price: product.price),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> editProduct(Product product) async {
    final index = _products.indexWhere((prod) => prod.id == product.id);
    if (index >= 0) {
      final url =
          "https://flutter-app-58445-default-rtdb.firebaseio.com/products/${product.id}.json?auth=$authToken";

      try {
        await http.patch(
          Uri.parse(url),
          body: json.encode({
            "title": product.title,
            "price": product.price,
            "imageUrl": product.imageUrl,
            "description": product.description,
          }),
        );
        _products[index] = product;
      } catch (error) {
        rethrow;
      }
    }
    notifyListeners();
  }

  Future<void> removeProduct(String id) async {
    final url =
        "https://flutter-app-58445-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken";
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode < 400) {
      _products.removeWhere((prod) => prod.id == id);
    } else {
      throw const HttpException("We catch an error");
    }

    notifyListeners();
  }
}
