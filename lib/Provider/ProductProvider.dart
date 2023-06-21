import 'package:ab_shop/Helper/Http.dart';
import 'package:ab_shop/Model/Meta.dart';
import 'package:ab_shop/Model/Product.dart';
import 'package:ab_shop/Provider/AuthManager.dart';
import 'package:ab_shop/Provider/UserProvider.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  late Meta? productMeta;
  late String token = '';

  ProductProvider(this.token);


  List<Product> _products = [];
  List<Product> _searchProducts = [];
  List<Product> get products {
    return [..._products];
  }

  List<Product> get searchProducts {
    return [..._searchProducts];
  }

  late bool isNotDataProducts = false;
  late bool isLoadingProducts = false;
  late int activeProductPage = 0;
  late int? brandId = 0;

  late Meta? discountProductMeta;

  List<Product> _discountProducts = [];
  List<Product> get discountProducts {
    return [..._discountProducts];
  }

  Future<Map<String, dynamic>> favourite(Product product, String token) async {
    // TypeNo 1 is just for u 2 is discount 3 is search

    _products = _products.map((e) {
      if (e.id == product.id) {
        e.favouriteToggle();
      }
      return e;
    }).toList();

    _discountProducts = _discountProducts.map((e) {
      if (e.id == product.id) {
        e.favouriteToggle();
      }
      return e;
    }).toList();

    _searchProducts = _searchProducts.map((e) {
      if (e.id == product.id) {
        e.favouriteToggle();
      }
      return e;
    }).toList();

    final response =
        await Http.getDate('/wish/list/${product.id}', bearerToken: token);

    notifyListeners();

    if (response['status'] == 'success') {
      return {'status': true, 'message': response['data']};
    } else {
      return {'status': false, 'message': "SOMETHING WAS WRONG"};
    }
  }

  void addSearchProduct(bool isDiscount) {
    brandId = null;
    activeProductPage = 2;
    isNotDataProducts = false;
    if (isDiscount) {
      _searchProducts = discountProducts;
    } else {
      _searchProducts = products;
    }
    notifyListeners();
  }

  Future<void> addBrandId(int id) async {
    brandId = id;
    _searchProducts = [];
    searchFetchingProducts(isInit: true, brand_id: id);
  }

  Future<void> searchFetchingProducts({
    String? keyword,
    int? brand_id,
    bool isLoadMore = false,
    bool isInit = false,
  }) async {
    if (keyword != '' || isInit) {
      activeProductPage = 0;
    }
    if (!isLoadMore) {
      isLoadingProducts = true;
      notifyListeners();
    }

    final url =
        '/product?keyword=${keyword ?? ""}&page=${activeProductPage++}&brand_id=${brand_id ?? brandId ?? ""}';
    final data = await Http.getDate(url, bearerToken: token);
    // if (_searchProducts.isNotEmpty && !isLoadMore) {
    //   print('not fetch');
    //   notifyListeners();
    //   return;
    // }

    if (data['status'] == 'success') {
      final products = data['data'] as List;
      if (!isLoadMore || keyword!.isNotEmpty) {
        _searchProducts = [];
      }
      if (products.isNotEmpty) {
        products.map((e) => _searchProducts.add(Product.fromJson(e))).toList();
        productMeta = Meta.fromJson(data['meta']);
        isNotDataProducts = false;

        notifyListeners();
      } else {
        isNotDataProducts = true;
        notifyListeners();
      }

      isLoadingProducts = false;
    } else {
      throw data['message'];
    }
  }

  Future<void> fetchProducts({
    bool isLoadMore = false,
    String? keyword,
  }) async {
    if (keyword != '') {
      activeProductPage = 0;
    }

    final data = await Http.getDate('/product', bearerToken: token);

    // if (_products.isNotEmpty && !isLoadMore) {
    //   notifyListeners();
    //   return;
    // }

    isLoadingProducts = true;
    notifyListeners();

    if (data['status'] == 'success') {
      final products = data['data'] as List;
      if (!isLoadMore) {
        _products = [];
      }
      if (products.isNotEmpty) {
        products.map((e) => _products.add(Product.fromJson(e))).toList();
        productMeta = Meta.fromJson(data['meta']);
        notifyListeners();
      } else {
        isNotDataProducts = true;
        notifyListeners();
      }

      isLoadingProducts = false;
    } else {
      throw data['message'];
    }
  }

  Future<void> fetchDiscoutProducts() async {
    final data = await Http.getDate('/discount/products', bearerToken: token);
    // if (_discountProducts.isNotEmpty) {
    //   notifyListeners();
    //   return;
    // }
    if (data['status'] == 'success') {
      final dataList = data['data'] as List;
      if (dataList.isNotEmpty) {
        _discountProducts = [];
        dataList
            .map((e) => _discountProducts.add(Product.fromJson(e)))
            .toList();
        discountProductMeta = Meta.fromJson(data['meta']);
        notifyListeners();
      }
    } else {
      throw data['message'];
    }
  }
}
