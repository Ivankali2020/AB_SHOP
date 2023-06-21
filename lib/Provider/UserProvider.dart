import 'dart:convert';
import 'dart:io';

import 'package:ab_shop/Helper/Http.dart';
import 'package:ab_shop/Model/Cerror.dart';
import 'package:ab_shop/Model/Coupon.dart';
import 'package:ab_shop/Model/Notification.dart' as Noti;
import 'package:ab_shop/Model/User.dart';
import 'package:ab_shop/Provider/AuthManager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  User? userData;
  late String? token = '';
  late bool isLoading = false;
  List<Coupon> coupons = [];
  List<Noti.Notification> notifications = [];
  static const String _user_key = 'user_key';
  static const String _token_key = 'token_key';

  UserProvider(Map? data){
    if(data != null){
    userData = data['user'];
    token = data['token'];
    notifyListeners();
    }
  }

  Future<void> changeTokenAndUser(User user, String tokenData) async {

  }

  Future<void> fetchCoupons() async {
    coupons = [];
    if (token == '') {
      return;
    }
    final response = await Http.getDate('/coupon', bearerToken: token!);

    if (response['status'] == 'success') {
      final data = response['data'] as List;
      if (data.isEmpty) return;
      data.map((e) => coupons.add(Coupon.fromJson(e))).toList();
      notifyListeners();
    }
  }

  Future<void> fetchNotifications() async {
    notifications = [];
    if (token == '') {
      return;
    }
    final response = await Http.getDate('/notifications', bearerToken: token!);

    if (response['status'] == 'success') {
      final data = response['data'] as List;
      print(data);
      if (data.isEmpty) return;
      data
          .map((e) => notifications.add(Noti.Notification.fromJson(e)))
          .toList();
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> Register(Map<String, dynamic> data) async {
    final getUrl = Uri.parse('${Http.coreUrl}/register');
    final Map<String, String> customHeaders = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    isLoading = true;

    final user = jsonEncode(data);
    try {
      final data = await http.post(getUrl, headers: customHeaders, body: user);
      print(data.body);

      if (data.statusCode == 200 &&
          jsonDecode(data.body)['status'] == 'success') {
        final json = jsonDecode(data.body);
        isLoading = false;
        return {
          'status': true,
          'message': 'Login Now',
        };
      }

      isLoading = false;
      final error = Cerror.fromJson(jsonDecode(data.body));

      return {'status': false, 'message': error.data.credentials[0]};
    } catch (err) {
      isLoading = false;
      return {'status': false, 'message': err.toString()};
    }
  }

  Future<Map<String, dynamic>> Login(Map<String, dynamic> data) async {
    final getUrl = Uri.parse('${Http.coreUrl}/login');
    final Map<String, String> customHeaders = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    isLoading = true;

    final user = jsonEncode(data);
    try {
      final data = await http.post(getUrl, headers: customHeaders, body: user);

      if (data.statusCode == 200 &&
          jsonDecode(data.body)['status'] == 'success') {
        final json = jsonDecode(data.body);
        userData = User.fromJson(json['user']);
        token = json['token'];
        isLoading = false;

        //store on local
        AuthManager.setUserAndToken(json['token'], User.fromJson(json['user']));

        return {
          'status': true,
          'message': 'Successfully Login',
        };
      }

      isLoading = false;
      final error = Cerror.fromJson(jsonDecode(data.body));

      return {'status': false, 'message': error.data.credentials[0]};
    } catch (err) {
      isLoading = false;
      return {'status': false, 'message': err.toString()};
    }
  }

  Future<Map<String, dynamic>> profileUpdate(Map rawData) async {
    final Map<String, String> customHeaders = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final url = Uri.parse(Http.coreUrl + "/change/profile");
    final data = jsonEncode(rawData);
    final response = await http.post(url, headers: customHeaders, body: data);
    final json = jsonDecode(response.body);

    if (json['status'] == 'success') {
      userData!.name = rawData['name'];
      userData!.credentials = rawData['credentials'];
      notifyListeners();
      return {'status': true, 'message': json['message']};
    }

    return {'status': false, 'message': 'FAILED!'};
  }

  Future<Map<String, dynamic>> changeImage(File image) async {
    final Map<String, String> customHeaders = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final url = Uri.parse(Http.coreUrl + "/change/profile");

    final request = http.MultipartRequest('POST', url);

    request.files.add(await http.MultipartFile.fromPath('photo', image.path));

    request.headers.addAll(customHeaders);
    final send = await request.send();
    final response = await send.stream.bytesToString();

    final json = jsonDecode(response);
    if (json['status'] == 'success') {
      userData!.photo = json['data']['photo'];
      notifyListeners();
      return {'status': true, 'message': json['message']};
    }

    return {'status': false, 'message': 'FAILED!'};
  }

  Future<Map<String, dynamic>> logOut() async {
    final Map<String, String> customHeaders = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    final url = Uri.parse(Http.coreUrl + "/logout");
    final response = await http.post(url, headers: customHeaders);
    final json = jsonDecode(response.body);

    if (json['status'] == 'success') {
      token = '';
      userData = null;

      AuthManager.removeUserAndToken();
      notifyListeners();
      return {'status': true, 'message': json['data']};
    }

    return {'status': false, 'message': 'FAILED!'};
  }
}
