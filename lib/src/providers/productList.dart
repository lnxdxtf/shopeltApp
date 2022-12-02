import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopelt/src/exceptions/httpException.dart';
import 'package:shopelt/src/models/product.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductList with ChangeNotifier {
  final _baseUrl = dotenv.env['FIREBASE_REALTIME_DB'];

  final String _token;
  final String _uid;

  List<Product> _items = [];

  int get itemsCount => _items.length;

  List<Product> get items => [..._items];

  ProductList([
    this._token = '',
    this._uid = '',
    this._items = const [],
  ]);

  List<Product> get favItems => _items.where((prod) => prod.isFav).toList();

  Future<void> loadProducts() async {
    _items.clear();
    final response =
        await http.get(Uri.parse('$_baseUrl/products.json?auth=$_token'));
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);

    final favResponse = await http
        .get(Uri.parse('$_baseUrl/users/$_uid/favorites.json?auth=$_token'));
    Map<String, dynamic> favData =
        favResponse.body == 'null' ? {} : jsonDecode(favResponse.body);

    data.forEach((productId, productData) {
      _items.add(Product(
        id: productId,
        title: productData['title'],
        description: productData['description'],
        price: productData['price'],
        imageUrl: productData['imageUrl'],
        isFav: favData[productId] ?? false,
      ));
    });
    notifyListeners();
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final newProduct = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      title: data['title'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );

    return hasId ? updateProduct(newProduct) : addProduct(newProduct);
  }

  Future<void> addProduct(Product product) async {
    final response =
        await http.post(Uri.parse('$_baseUrl/products.json?auth=$_token'),
            body: jsonEncode({
              "title": product.title,
              "description": product.description,
              "price": product.price,
              "imageUrl": product.imageUrl,
            }));

    final String id = jsonDecode(response.body)['name'];
    _items.add(Product(
      id: id,
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    ));
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    int index = _items.indexWhere((element) => element.id == product.id);
    if (index >= 0) {
      await http.patch(
          Uri.parse('$_baseUrl/products/${product.id}.json?auth=$_token'),
          body: jsonEncode({
            "title": product.title,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageUrl,
          }));
      _items[index] = product;
      notifyListeners();
    }
    return Future.value();
  }

  Future<void> removeProduct(Product product) async {
    int indexToRemove =
        _items.indexWhere((element) => element.id == product.id);
    if (indexToRemove >= 0) {
      final product = _items[indexToRemove];
      _items.remove(product);
      notifyListeners();
      final response = await http.delete(
          Uri.parse('$_baseUrl/products/${product.id}.json?auth=$_token'));
      if (response.statusCode >= 400) {
        _items.insert(indexToRemove, product);
        throw HttpException(
            message: 'Error on delete product ${product.title}',
            statusCode: response.statusCode);
      }
      notifyListeners();
    }
  }
}
