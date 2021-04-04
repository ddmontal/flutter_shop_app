import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shop_app/config.dart';
import 'package:shop_app/models/cart_item.dart';
import 'package:shop_app/models/order_item.dart';

import 'package:http/http.dart' as http;

class Orders with ChangeNotifier {
  final String apiPath = '/orders';
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [
      ..._orders
    ];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.https(Config.firebaseDomain, '$apiPath.json');
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    if (extractedData != null) {
      extractedData.forEach((key, value) {
        loadedOrders.add(OrderItem(
          id: key,
          dateTime: DateTime.parse(value['dateTime']),
          ammount: value['ammount'],
          products: (value['products'] as List<dynamic>)
              .map(
                (e) => CartItem(
                  id: e['id'],
                  title: e['title'],
                  quantity: e['quantity'],
                  price: e['price'],
                ),
              )
              .toList(),
        ));
      });

      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.https(Config.firebaseDomain, '$apiPath.json');
    final timestamp = DateTime.now();

    try {
      var response = await http.post(
        url,
        body: json.encode({
          'ammount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map(
                (e) => {
                  'id': e.id,
                  'title': e.title,
                  'quantity': e.quantity,
                  'price': e.price
                },
              )
              .toList(),
        }),
      );

      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          ammount: total,
          dateTime: timestamp,
          products: cartProducts,
        ),
      );
    } catch (e) {
      print(e.toString());
      throw e;
    }

    notifyListeners();
  }
}
