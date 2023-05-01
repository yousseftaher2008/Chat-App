import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:shop/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token = "";
  String _userId = "";
  DateTime _expiryDate = DateTime.now();
  final Timer _authTimer = Timer(const Duration(seconds: 0), () {});
  bool get isAuth {
    return token != "";
  }

  dynamic get token {
    if (_token != "" && _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return "";
  }

  dynamic get userId {
    if (_userId != "") return _userId;
    return "";
  }

  Future<void> _authenticate(String email, String password, String url) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            "email": email,
            "password": password,
            "returnSecureToken": true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']["message"]);
      }
      _token = responseData["idToken"];
      _userId = responseData["localId"];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData["expiresIn"]) * 72));
      _autoLogout();

      notifyListeners();
      final preferences = await SharedPreferences.getInstance();
      final userData = json.encode({
        "token": _token,
        "userId": _userId,
        "expiryDate": _expiryDate.toString(),
      });
      preferences.setString("userData", userData);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signup(String email, String password) async {
    const String url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyD8QM-FKAtPD55WsyTVeP8uTwtT0oG_nv0";
    return _authenticate(email, password, url);
  }

  Future<void> login(String email, String password) async {
    const String url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyD8QM-FKAtPD55WsyTVeP8uTwtT0oG_nv0";
    return _authenticate(email, password, url);
  }

  Future<bool> autoLogin() async {
    final preferences = await SharedPreferences.getInstance();
    if (!preferences.containsKey("userData")) {
      return false;
    }

    final userData = json.decode(preferences.getString("userData").toString())
        as Map<String, dynamic>;
    final extractedExpiry = DateTime.parse(userData["expiryDate"].toString());

    if (extractedExpiry.isBefore(DateTime.now())) {
      return false;
    }
    _token = userData["token"].toString();
    _userId = userData["userId"].toString();
    _expiryDate = extractedExpiry;
    notifyListeners();
    _autoLogout();
    return true;
  }

  void logout() async {
    _token = "";
    _userId = "";
    _expiryDate = DateTime.now();
    _authTimer.cancel();
    notifyListeners();
    final preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }

  void _autoLogout() {
    _authTimer.cancel;
    Timer(
      Duration(seconds: _expiryDate.difference(DateTime.now()).inSeconds),
      logout,
    );
  }
}
