import 'package:ab_shop/Helper/Http.dart';
import 'package:ab_shop/Model/Product.dart';
import 'package:ab_shop/Model/Banner.dart' as B;
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class DiscountProvider with ChangeNotifier {
  List<Product> _products = [];
  B.Banner? banner;

  List<Product> get products {
    return [..._products];
  }

  Future<void> fetchProductsWithBannerId(int bannerId) async {
    _products = [];
    banner = null;

    final json = await Http.getDate('/banner?banner_id=$bannerId');

    if (json['status'] == 'success') {
      final data = json['data'][0]['products'] as List;
      data.map((e) => _products.add(Product.fromJson(e))).toList();

      // //for banner
      banner = B.Banner(
        id: json['data'][0]['id'],
        name: json['data'][0]['name'],
        discountPrice: json['data'][0]['discount_price'],
        discountPercentage: json['data'][0]['discount_percentage'],
        photo: json['data'][0]['photo'],
      );
      notifyListeners();
    }
  }
}
