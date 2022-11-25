import 'package:flutter/material.dart';
import 'package:shopelt/src/data/dummy_data.dart';
import 'package:shopelt/src/models/product.dart';

class ProductList with ChangeNotifier {
  List<Product> _items = dummyProducts;

  int get itemsCount => _items.length;

  List<Product> get items => [..._items];

  List<Product> get favItems => _items.where((prod) => prod.isFav).toList();

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }
}

//  bool _showFavoriteOnly = false;

//   List<Product> get items {
//     if (_showFavoriteOnly) {
//       return _items.where((prod) => prod.isFav).toList();
//     } else {
//       return [..._items];
//     }
//   }

//   void showFavoriteOnly() {
//     _showFavoriteOnly = !_showFavoriteOnly;
//     notifyListeners();
//   }