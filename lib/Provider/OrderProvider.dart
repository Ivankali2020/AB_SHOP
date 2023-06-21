import 'dart:convert';
import 'dart:io';

import 'package:ab_shop/Helper/Http.dart';
import 'package:ab_shop/Model/Cart.dart' as CartModal;
import 'package:ab_shop/Model/Order.dart';
import 'package:ab_shop/Model/OrderDetail.dart';
import 'package:ab_shop/Model/Payment.dart';
import 'package:ab_shop/Model/Region.dart';
import 'package:ab_shop/Model/Township.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderProvider with ChangeNotifier {
  List<Region> regions = [];
  List<Township> townships = [];
  List<Payment> payments = [];
  List<Order> orders = [];
  Region? region;
  Township? township;
  Payment? payment;
  File? slip;
  bool isLoading = false;

  int coupon_id = 0;
  int coupon_amount = 0;

  void addCouponId(int value) {
    coupon_id = value;
    notifyListeners();
  }

  void addCouponAmount(int value) {
    coupon_amount = value;
    notifyListeners();
  }

  void addSlip(File value) {
    slip = value;
    notifyListeners();
  }

  void addRegion(Region value) {
    region = value;
    notifyListeners();
  }

  void addPayment(Payment value) {
    payment = value;
    notifyListeners();
  }

  void addTownship(Township value) {
    township = value;
    notifyListeners();
  }

  void emptyOrder() {
    slip = null;
    township = null;
    coupon_id = 0;
    notifyListeners();
  }

  Future<Map<String, dynamic>> order(
    List<CartModal.Cart> carts,
    String token,
    Map userData,
  ) async {

    if (township == null) {
      return {'status': false, 'message': 'TOWNSHIP REQUIRED'};
    }

    // first add to cart all data
    final jsonCarts = carts.map((e) => e.toJson()).toList();
    final bool response = await addToCartAllProducts(jsonCarts, token);
    if (!response) {
      return {'status': false, 'message': 'ERROR OCCUR WHEN ADD TO CARTS'};
    }



    isLoading = true;
    notifyListeners();

    // second order api
    final Map<String, String> data = {
      'name': userData['name'],
      'phone': userData['phone'],
      'address': userData['address'],
      'user_id': userData['user_id'].toString(),
      'township_id': township!.townshipId.toString(),
      'coupon_id': coupon_id != 0 ? coupon_id.toString() : '',
      'payment_id': payment != null ? payment!.id.toString() : '',
      'note': 'TESTING'
    };
    final responsFromOrder = await OrderNow(data, token);
    if (!responsFromOrder) {
      return {'status': false, 'message': 'ERROR OCCUR WHEN ORDERING'};
    }

    isLoading = false;
    notifyListeners();
    return {'status': true, 'message': 'Successfully Ordered!'};
  }

  Future<bool> addToCartAllProducts(List jsonCarts, String bearerToken) async {
    final getUrl = Uri.parse('${Http.coreUrl}/cart');
    final Map<String, String> customHeaders = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };

    final carts = jsonEncode({"carts": jsonCarts});
    try {
      final data = await http.post(getUrl, headers: customHeaders, body: carts);

      if (data.statusCode == 200 &&
          jsonDecode(data.body)['status'] == 'success') {
        return true;
      }

      return false;
    } catch (err) {
      return false;
    }
  }

  Future<bool> OrderNow(Map<String, String> data, String bearerToken) async {
    final getUrl = Uri.parse('${Http.coreUrl}/order');
    final Map<String, String> customHeaders = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };

    final orderData = jsonEncode(data);
    try {
      final request = http.MultipartRequest('POST', getUrl);

      request.fields.addAll(data);
      if (!township!.cod) {
        request.files
            .add(await http.MultipartFile.fromPath('slip', slip!.path));
      }
      request.headers.addAll(customHeaders);
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var decodedBody = jsonDecode(responseBody);
      if (response.statusCode == 200 && decodedBody['status'] == 'success') {
        return true;
      }

      return false;
    } catch (err) {
      return false;
    }
  }

  Future<void> fetchTownship() async {
    townships = [];
    final id = region!.regionId;
    final data = await Http.getDate('/region/$id/township');
    if (data == null) return;
    if (data['status']) {
      data['data'].map((e) => townships.add(Township.fromJson(e))).toList();
      notifyListeners();
    }
  }

  Future<void> fetchPayment() async {
    payments = [];
    final data = await Http.getDate('/payments');
    if (data == null) return;
    if (data['status']) {
      data['data'].map((e) => payments.add(Payment.fromJson(e))).toList();
      notifyListeners();
    }
  }

  Future<void> fetchRegions() async {
    final data = await Http.getDate('/regions');
    if (data == null) return;
    if (data['status']) {
      regions = [];
      data['data'].map((e) => regions.add(Region.fromJson(e))).toList();
      notifyListeners();
    }
  }

  late int page = 0;
  late bool isNoOrderAnyMore = false;
  Future<void> getOrdersDatas(String token, {isLoadMore = false}) async {
    if (!isLoadMore) {
      orders = [];
      isNoOrderAnyMore = false;
      page = 1;
    }
    final data = await Http.getDate('/order?page=${page}', bearerToken: token);
    if (data == null) return;
    print(data);
    if (data['status'] == 'success') {
      if ((data['data'] as List).isEmpty) {
        isNoOrderAnyMore = true;
        notifyListeners();
        return;
      }
      data['data'].map((e) => orders.add(Order.fromJson(e))).toList();
      page++;
      notifyListeners();
    }
  }

  late OrderDetail orderDetail;

  Future<bool> fetchorderProducts(String id, String token) async {
    final data = await Http.getDate('/order/$id', bearerToken: token);
    if (data == null) return false;
    print(data);
    if (data['status'] == 'success') {
      orderDetail = OrderDetail.fromJson(data['data'][0]);
      notifyListeners();
    }

    return true;
  }
}
