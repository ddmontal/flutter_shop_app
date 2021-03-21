import 'package:flutter/foundation.dart';
import 'package:shop_app/models/cart_item.dart';

class OrderItem {
  final String id;
  final double ammount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.ammount,
    @required this.dateTime,
    @required this.id,
    @required this.products,
  });
}
