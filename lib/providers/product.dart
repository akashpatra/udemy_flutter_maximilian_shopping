import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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

  void _setFavStatus(bool status) {
    isFavorite = status;
    notifyListeners();
  }

  void toggleFavoriteStatus() async {
    var oldStatus = isFavorite;
    _setFavStatus(!isFavorite);

    final url = 'https://flutter-shopping-7fef5.firebaseio.com/products/$id.json';
    try {
      final response = await http.patch(url,
          body: json.encode({
            'isFavorite': isFavorite,
          }));
      if (response.statusCode >= 400) {
        // Revert the status
        _setFavStatus(oldStatus);
      }
    } catch (error) {
      print("Error: $error");

      // Revert the status
      _setFavStatus(oldStatus);
    }
  }
}
