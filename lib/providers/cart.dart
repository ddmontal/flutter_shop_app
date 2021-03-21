import 'package:flutter/foundation.dart';
import 'package:shop_app/models/cart_item.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {
      ..._items
    };
  }

  int get itemCount => _items.length;
  double get totalAmmount {
    double total = 0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addItem({
    String productId,
    double price,
    String title,
    int quantity = 1,
  }) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (value) => CartItem(
                id: value.id,
                title: value.title,
                quantity: value.quantity + quantity,
                price: value.price,
              ));
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: quantity,
        ),
      );
    }

    notifyListeners();
  }

  void removeItem(String id) {
    this._items.remove(id);
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
