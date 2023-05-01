import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shop/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> list;
  final DateTime time;

  const OrderItem({
    required this.id,
    required this.amount,
    required this.list,
    required this.time,
  });
}

class Orders with ChangeNotifier {
  String token;
  String userId;
  List<OrderItem> _orders = [];
  Orders(this.token, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> getData() async {
    final url =
        "https://flutter-app-58445-default-rtdb.firebaseio.com/userOrders/$userId/.json?auth=$token";
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        _orders = [];
        notifyListeners();
        return;
      }

      List<OrderItem> loadedData = [];

      (extractedData as Map<String, dynamic>).forEach((ordId, ordData) {
        loadedData.add(
          OrderItem(
            id: ordId,
            amount: ordData['amount'],
            list: (ordData['products'] as List<dynamic>)
                .map((cp) => CartItem(
                      id: cp["id"],
                      title: cp["title"],
                      quantity: cp["quantity"],
                      price: cp["price"],
                    ))
                .toList(),
            time: DateTime.parse(ordData['time']),
          ),
        );
      });
      _orders = loadedData.reversed.toList();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addOrder(double amount, ordersList) async {
    final url =
        "https://flutter-app-58445-default-rtdb.firebaseio.com/userOrders/$userId.json?auth=$token";
    final time = DateTime.now();
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'amount': amount,
          'products': ordersList
              .map((cp) => {
                    "id": cp.id,
                    "title": cp.title,
                    "quantity": cp.quantity,
                    "price": cp.price,
                  })
              .toList(),
          'time': time.toString(),
        }),
      );
      _orders.add(
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: amount,
          list: ordersList,
          time: time,
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
