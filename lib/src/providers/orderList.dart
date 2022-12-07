import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopelt/src/providers/Cart.dart';
import 'package:shopelt/src/models/Order.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shopelt/src/models/cartItem.dart';

class OrderList with ChangeNotifier {
  final String _token;
  final String _uid;

  List<Order> _items = [];

  List<Order> get items => [..._items];

  OrderList([this._token = '', this._uid = '', this._items = const []]);

  int get itemsCount => _items.length;

  final _baseUrl = dotenv.env['FIREBASE_REALTIME_DB'];

  Future<void> loadOrders() async {
    _items.clear();
    final response = await http
        .get(Uri.parse('$_baseUrl/users/$_uid/orders.json?auth=$_token'));
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((orderID, orderData) {
      _items.add(Order(
          id: orderID,
          total: orderData['totalAmount'],
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                    id: item['id'],
                    productID: item['productID'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price'],
                    imageUrl: item['imageUrl'],
                  ))
              .toList(),
          date: DateTime.parse(orderData['date'])));
    });
    _items = _items.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(Cart cart) async {
    final dateAdded = DateTime.now();
    final repsonse = await http.post(
        Uri.parse('$_baseUrl/users/$_uid/orders.json?auth=$_token'),
        body: jsonEncode({
          "totalAmount": cart.totalAmount,
          "date": dateAdded.toIso8601String(),
          "products": cart.items.values
              .map((item) => {
                    "id": item.id,
                    "productID": item.productID,
                    "title": item.title,
                    "quantity": item.quantity,
                    "price": item.price,
                    "imageUrl": item.imageUrl
                  })
              .toList(),
        }));

    final idOrder = jsonDecode(repsonse.body)['name'];

    _items.insert(
      0,
      Order(
        id: idOrder,
        total: cart.totalAmount,
        date: dateAdded,
        products: cart.items.values.toList(),
      ),
    );
    notifyListeners();
  }
}
