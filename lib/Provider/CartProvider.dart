import 'dart:convert';

import 'package:ab_shop/Helper/Http.dart';
import 'package:ab_shop/Model/Product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Model/Cart.dart' as MCart;

class CartProvider with ChangeNotifier {
  List<Cart> _carts = [];
  List<Cart> get carts {
    return [..._carts];
  }

  late int total = 0;

  void emptyCart() {
    _carts = [];
    totalCalculate();
    notifyListeners();
  }

  // Future<void> fetchCarts(String token, {bool isReload = false}) async {
  //   if (isReload) {
  //     _carts = [];
  //   }
  //   final data = await Http.getDate('/cart', bearerToken: token);

  //   if (data['status'] == 'success') {
  //     final listChange = data['data'] as List;

  //     listChange
  //         .map((e) => _carts.add(
  //             Cart(e['id'], e['quantity'], Product.fromJson(e['product']))))
  //         .toList();
  //     totalCalculate();
  //     notifyListeners();
  //   }
  // }

  Future<Map<String, dynamic>> addToCart(
      Product product, int quantity, String token) async {
    if (_carts.isNotEmpty) {
      final findProduct =
          _carts.where((element) => element.product.id == product.id).toList();

      if (findProduct.isNotEmpty) {
        updateCart(product, true, token);
        return {'status': true, 'message': 'SUCCESFULLY UPDATED'};
      }
    }

    _carts.add(Cart(quantity, product));


    // final jsonCarts = [
    //   MCart.Cart(
    //       productId: product.id,
    //       quantity: quantity,
    //       bannerId: product.banner != null ? product.banner!.id.toString() : '')
    // ];

    // final bool response = await addToCartAllProducts(jsonCarts, token);
    // if (!response) {
    //   print(response);
    //   return {'status': false, 'message': 'ERROR OCCUR WHEN ADD TO CARTS'};
    // }

    // await fetchCarts(token);
    totalCalculate();
    notifyListeners();
    return {'status': true, 'message': 'SUCCESFULLY ADDED'};
  }

  // Future<bool> addToCartAllProducts(
  //   List<MCart.Cart> jsonCarts,
  //   String bearerToken,
  // ) async {
  //   final getUrl = Uri.parse('${Http.coreUrl}/cart');
  //   final carts = jsonEncode({"carts": jsonCarts});

  //   Map<String, String> customHeaders = Header(bearerToken);

  //   try {
  //     final data = await http.post(getUrl, headers: customHeaders, body: carts);
  //     if (data.statusCode == 200 &&
  //         jsonDecode(data.body)['status'] == 'success') {
  //       return true;
  //     }

  //     return false;
  //   } catch (err) {
  //     return false;
  //   }
  // }

  // Future<bool> serverUpdateCart(
  //   int quantity,
  //   int product_id,
  //   String bearerToken,
  // ) async {
  //   final getUrl = Uri.parse('${Http.coreUrl}/cart');

  //   Map<String, String> customHeaders = Header(bearerToken);

  //   try {
  //     final body = {'quantity': quantity};

  //     final data = await http.patch(getUrl, headers: customHeaders, body: body);
  //     if (data.statusCode == 200 &&
  //         jsonDecode(data.body)['status'] == 'success') {
  //       return true;
  //     }

  //     return false;
  //   } catch (err) {
  //     return false;
  //   }
  // }

  Map<String, String> Header(String bearerToken) {
    final Map<String, String> customHeaders = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $bearerToken'
    };
    return customHeaders;
  }

  void totalCalculate() {
    total = 0;
    _carts.map((e) {
      if (e.product.discountPrice == 0) {
        total += (e.product.price * e.quantity);
      } else {
        total += (e.product.discountPrice * e.quantity);
      }
    }).toList();
    notifyListeners();
  }

  Future<void> updateCart(
      Product product, bool isIncrease, String token) async {
    if (isIncrease) {
      _carts = _carts.map((e) {
        if (e.product.id == product.id) {
          e.increase();
          // serverUpdateCart(e.quantity,e.id,token);
        }
        return e;
      }).toList();
    } else {
      final findProduct =
          _carts.firstWhere((element) => element.product.id == product.id);

      if (findProduct.quantity == 1) {
        // will delete product //
        _carts.removeWhere((element) => element.product.id == product.id);
      } else {
        _carts = _carts.map((e) {
          if (e.product.id == product.id) {
            e.descrease();
          }
          return e;
        }).toList();
        notifyListeners();
      }
    }
    totalCalculate();
    notifyListeners();
  }
}

class Cart {
  // late int id;
  late int quantity = 1;
  final Product product;

  Cart(this.quantity, this.product);

  void increase() {
    quantity = quantity + 1;
  }

  void descrease() {
    quantity = quantity - 1;
  }
}
