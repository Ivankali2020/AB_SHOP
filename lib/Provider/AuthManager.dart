import 'dart:convert';

import 'package:ab_shop/Model/User.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthManager with ChangeNotifier {
  static const String _user_key = 'user_key';
  static const String _token_key = 'token_key';

  static Future<Map<String, dynamic>?> getUserAndToken() async {
    final prefs = await SharedPreferences.getInstance();
    final json = await prefs.getString(_user_key);
    final token = await prefs.getString(_token_key);
    if (json != null) {
      final jsondecode = jsonDecode(json);
      final user = User.fromJson(jsondecode);

      return {'user': user, 'token': token};
    }

    return null;
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_token_key);

    return token;
  }

  static Future<void> setUserAndToken(String token, User user) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonUser = jsonEncode(user);
    await prefs.setString(_user_key, jsonUser);
    await prefs.setString(_token_key, token);
  }

  static Future<void> removeUserAndToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_user_key);
    await prefs.remove(_token_key);
  }
}
