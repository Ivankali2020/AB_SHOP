import 'package:ab_shop/Screen/Cart.dart';
import 'package:ab_shop/Screen/Discount.dart';
import 'package:ab_shop/Screen/Home.dart';
import 'package:ab_shop/Screen/Search.dart';
import 'package:ab_shop/Screen/User.dart';
import 'package:flutter/material.dart';

class NavProvider with ChangeNotifier {
  final List<Map<String, dynamic>> pages = [
    {
      'name': 'Home',
      'page': const Home(),
      'icon': Icons.home_outlined,
      'active_icon': Icons.home_filled
    },
    {
      'name': 'Search',
      'page':const SearchScreen(),
      'icon': Icons.search_outlined,
      'active_icon': Icons.search_sharp
    },
    {
      'name': 'Cart',
      'page':const Cart(),
      'icon': Icons.shopping_cart_outlined,
      'active_icon': Icons.shopping_cart_sharp
    },
    {
      'name': 'User',
      'page': User(),
      'icon': Icons.person_outline,
      'active_icon': Icons.person_sharp
    },
  ];

  late int activeIndex = 0;

  void changeIndex(int index) {
    activeIndex = index;
    notifyListeners();
  }
}
