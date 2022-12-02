import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shopelt/src/exceptions/authException.dart';

class Auth with ChangeNotifier {
  final _apiKey = dotenv.env['FIREBASE_API_WEB_KEY'];

  String? _token;
  String? _email;
  String? _uid;
  DateTime? _expiresTokenIn;

  bool get isAuthenticated {
    final isValid = _expiresTokenIn?.isAfter(DateTime.now()) ?? false;
    return isValid && _token != null;
  }

  String? get token => isAuthenticated ? _token : null;

  String? get email => isAuthenticated ? _email : null;

  String? get uid => isAuthenticated ? _uid : null;

  Future<void> _authenticate(
      String email, String password, String typeSign) async {
    final _bodyAuth = {
      "email": email,
      "password": password,
      "returnSecureToken": true
    };
    final _urlAuth =
        'https://identitytoolkit.googleapis.com/v1/accounts:$typeSign?key=$_apiKey';
    final response =
        await http.post(Uri.parse(_urlAuth), body: jsonEncode(_bodyAuth));
    final responseAuth = jsonDecode(response.body);
    if (responseAuth['error'] != null) {
      throw AuthException(responseAuth['error']['message']);
    } else {
      _token = responseAuth['idToken'];
      _email = responseAuth['email'];
      _uid = responseAuth['localId'];
      _expiresTokenIn = DateTime.now().add(
        Duration(seconds: int.parse(responseAuth['expiresIn'])),
      );
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
