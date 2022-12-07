import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shopelt/src/exceptions/authException.dart';
import 'package:shopelt/src/utils/store/store.dart';

class Auth with ChangeNotifier {
  final _apiKey = dotenv.env['FIREBASE_API_WEB_KEY'];

  String? _token;
  String? _email;
  String? _uid;
  DateTime? _expiresTokenIn;
  Timer? _logoutTimer;

  bool get isAuthenticated {
    final isValid = _expiresTokenIn?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get token => isAuthenticated ? _token : null;

  String? get email => isAuthenticated ? _email : null;

  String? get uid => isAuthenticated ? _uid : null;

  Future<void> _authenticate(
      String email, String password, String typeSign) async {
    final bodyAuth = {
      "email": email,
      "password": password,
      "returnSecureToken": true
    };
    final urlAuth =
        'https://identitytoolkit.googleapis.com/v1/accounts:$typeSign?key=$_apiKey';
    final response =
        await http.post(Uri.parse(urlAuth), body: jsonEncode(bodyAuth));
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

      Store.saveMap('userData', {
        'token': _token,
        'email': _email,
        'uid': _uid,
        'expiresDate': _expiresTokenIn!.toIso8601String(),
      });

      _autoLogout();
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> autoLogin() async {
    if (isAuthenticated) return;
    final userData = await Store.getMap('userData');
    if (userData.isEmpty) return;
    final expiresDate = DateTime.parse(userData['expiresDate']);

    if (expiresDate.isBefore(DateTime.now())) return;

    _token = userData['token'];
    _email = userData['email'];
    _uid = userData['uid'];
    _expiresTokenIn = expiresDate;
    _autoLogout();
    notifyListeners();
  }

  void logout() {
    _token = null;
    _email = null;
    _uid = null;
    _expiresTokenIn = null;
    _clearLogoutTimer();
    Store.remove('userData').then((_) {
      notifyListeners();
    });
  }

  void _clearLogoutTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = null;
  }

  void _autoLogout() {
    _clearLogoutTimer();
    final timeToLogout = _expiresTokenIn?.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(Duration(seconds: timeToLogout ?? 0), logout);
  }
}
