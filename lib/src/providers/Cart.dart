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
          id: 'item-${Random().nextInt(9999999).toString()}',
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

  void removeSingleItem(String productID) {
    if (!_items.containsKey(productID)) {
      return;
    }
    if (_items[productID]?.quantity == 1) {
      _items.remove(productID);
    } else {
      _items.update(
          productID,
          (item) => CartItem(
                id: item.id,
                productID: item.productID,
                title: item.title,
                quantity: item.quantity - 1,
                price: item.price,
                imageUrl: item.imageUrl,
              ));
    }
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
