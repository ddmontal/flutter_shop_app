import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/Config.dart';
import 'package:shop_app/errors/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavValue(bool value) {
    isFavorite = value;
  }

  Future<void> toggleFavoriteStatus() async {
    final url = Uri.https(Config.firebaseDomain, '/products/$id.json');
    final oldStatus = isFavorite;

    this.isFavorite = !this.isFavorite;

    try {
      var response = await http.patch(
        url,
        body: json.encode({
          'isFavorite': this.isFavorite,
        }),
      );

      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (e) {
      _setFavValue(oldStatus);
    }

    notifyListeners();
  }
}
