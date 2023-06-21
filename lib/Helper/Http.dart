import 'dart:convert';

import 'package:ab_shop/Provider/AuthManager.dart';
import 'package:ab_shop/Provider/UserProvider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Http {
  static const coreUrl = 'https://sm.ecommyanmar.com/api';

  static Future getDate(String url, {String? bearerToken}) async {
    final getUrl = Uri.parse(Http.coreUrl + url);
    final Map<String, String> customHeaders = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (bearerToken != null) {
      customHeaders['Authorization'] = 'Bearer $bearerToken';
    }
    try {
      final data = await http.get(
        getUrl,
        headers: customHeaders,
      );
      return jsonDecode(data.body);
    } catch (err) {
      print(err);
    }
  }
}
