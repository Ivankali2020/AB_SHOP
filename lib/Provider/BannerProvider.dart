import 'package:ab_shop/Helper/Http.dart';
import 'package:ab_shop/Model/Banner.dart' as B;
import 'package:flutter/material.dart';

class BannerProvider with ChangeNotifier {
  late List<B.Banner> _banners = [];

  List<B.Banner> get banners {
    return [..._banners];
  }

  Future<void> fetchBanners() async {
    final data = await Http.getDate('/banner');
    if (_banners.isNotEmpty) {
      notifyListeners();
      return;
    }
    if (data['status'] == 'success') {
      final banners = data['data'] as List;
      if (banners.isNotEmpty) {
        _banners = [];
        banners.map((e) => _banners.add(B.Banner.fromJson(e))).toList();
        notifyListeners();
      }
    }
  }
}
