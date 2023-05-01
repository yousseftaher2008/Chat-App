import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  const CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int? get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double sum = 0;
    _items
        .forEach((_, cardItem) => sum += (cardItem.price * cardItem.quantity));
    return sum;
  }

  void addItem(String id, String title, double price) {
    if (_items.containsKey(id)) {
      _items.update(
          id,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                price: existingCartItem.price,
                quantity: (existingCartItem.quantity + 1),
              ));
    } else {
      _items.putIfAbsent(
          id,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                price: price,
                quantity: 1,
              ));
      notifyListeners();
    }
  }

  void removeItem(productId) {
    _items.remove(productId);
  }

  void removeSingleItem(productId) {
    if (!_items.containsKey(productId)) {
      return;
    } else if (_items[productId]!.quantity > 1) {
      _items.update(
          productId,
          (curProd) => CartItem(
                id: curProd.id,
                title: curProd.title,
                quantity: curProd.quantity - 1,
                price: curProd.price,
              ));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
