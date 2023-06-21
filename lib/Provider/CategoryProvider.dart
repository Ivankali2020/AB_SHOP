import 'package:ab_shop/Helper/Http.dart';
import 'package:ab_shop/Model/Category.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  late List<Category> _catgories = [];
  late List<Brands> brands = [];

  List<Category> get catgories {
    return [..._catgories];
  }

  List getBrands() {
    if(brands.isEmpty){
      _catgories.map((e) => brands.addAll(e.brands)).toList();
    }
    return brands;
  }

  Future<void> fetchCategories() async {
    final data = await Http.getDate('/category');
    if (_catgories.isNotEmpty) {
      notifyListeners();
      return;
    }
    if (data['status'] == 'success') {
      final catgories = data['data'] as List;
      if (catgories.isNotEmpty) {
        _catgories = [];
        catgories.map((e) => _catgories.add(Category.fromJson(e))).toList();
        notifyListeners();
      }
    } else {
      throw data['message'];
    }
  }
}
