import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shopelt/src/models/cartItem.dart';
import 'package:shopelt/src/models/product.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemsCount => _items.length;

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
          product.id,
          (item) => CartItem(
                id: item.id,
                productID: item.productID,
                title: item.title,
                quantity: item.quantity + 1,
                price: item.price,
                imageUrl: item.imageUrl,
              ));
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          id: Random().nextDouble().toString(),
          productID: product.id,
          title: product.title,
          quantity: 1,
          price: product.price,
          imageUrl: product.imageUrl,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productID) {
    _items.remove(productID);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  double get totalAmount {
    double total = 0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });

    return total;
  }
}
