import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFav;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFav = false,
  });

  final _baseUrl = dotenv.env['FIREBASE_REALTIME_DB'];

  void _toggleFav() {
    isFav = !isFav;
    notifyListeners();
  }

  Future<void> toggleFav(String token, String uid) async {
    try {
      _toggleFav();
      final response = await http.put(
          Uri.parse('$_baseUrl/users/$uid/favorites/$id.json?auth=$token'),
          body: jsonEncode(isFav));
      if (response.statusCode >= 400) _toggleFav();
    } catch (_) {
      _toggleFav();
    }
  }
}
