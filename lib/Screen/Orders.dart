import 'package:ab_shop/Helper/PageTranstion.dart';
import 'package:ab_shop/Provider/UserProvider.dart';
import 'package:ab_shop/Screen/Auth/Login.dart';
import 'package:ab_shop/Screen/OrderDetail.dart';
import 'package:ab_shop/Screen/Search.dart';
import 'package:ab_shop/Utlis/CouponItem.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../Provider/OrderProvider.dart';
// import '../Screen/OrderDetailScreen.dart';
// import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Order extends StatefulWidget {
  const Order({super.key});
  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  // Future? isInit;

  // Future<void> fetchOrders() async {
  //   final token = Provider.of<UserProvider>(context).token;
  //   // if (token == '') {
  //   //   Navigator.of(context).push(FadeRightPageRoute(
  //   //       builder: (context) => Login(name: '', password: '')));
  //   // }
  //   // ;
  //   Provider.of<OrderProvider>(context, listen: false).getOrdersDatas(token!);
  // }

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // isInit = fetchOrders();
    // TODO: implement initState
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('load');
        loadMore();
      }
    });
  }

  Future<void> loadMore() async {
    final token = Provider.of<UserProvider>(context, listen: false).token;
    Provider.of<OrderProvider>(context, listen: false)
        .getOrdersDatas(token!, isLoadMore: true);
  }

  Future<void> orderDetailPage(String orderId, String token) async {
    final bool response =
        await Provider.of<OrderProvider>(context, listen: false)
            .fetchorderProducts(orderId, token);

    if (response) {
      Navigator.of(context).push(
        FadeRightPageRoute(builder: (context) => OrderDetailScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final token = Provider.of<UserProvider>(context, listen: false).token;
    final NumberFormate = NumberFormat.currency(locale: 'en_US', name: 'MMK ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: FutureBuilder(
        future: Provider.of<OrderProvider>(context, listen: false)
            .getOrdersDatas(token!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            final orderProvider = Provider.of<OrderProvider>(context);
            final orders = orderProvider.orders;
            return Center(
              child: orders.isEmpty
                  ? const Center(
                      child: Text('No Orders Found!'),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: orders.length + 1,
                      itemBuilder: (context, i) {
                        if (i == orders.length) {
                          return orderProvider.isNoOrderAnyMore
                              ? const Center(
                                  child: Text('Catch All Orders!'),
                                )
                              : orders.length >= 6
                                  ? const ProductLoadingBox()
                                  : Container();
                        }
                        return  Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(Icons.shopping_bag_outlined),
                                    Text(
                                      'Order No : ${orders[i].orderId.toString()}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  NumberFormate.format(
                                      orders[i].orderData.totalPrice),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () => orderDetailPage(
                                          orders[i].orderId, token),
                                      child: Container(
                                        width: 80,
                                        height: 30,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                color: Colors.black45,
                                                width: 0.5)),
                                        child: const Text('Detail'),
                                      ),
                                    ),
                                    Text(orders[i].orderData.date),
                                  ],
                                ),
                              ],
                            ),
                        );
                      },
                    ),
            );
          }
        },
      ),
    );
  }
}

class ProductLoadingBox extends StatelessWidget {
  const ProductLoadingBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 239, 238, 238)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LoadingBox(width: 40, height: 20),
              LoadingBox(width: 100, height: 20),
            ],
          ),
          Center(
            child: LoadingBox(
              height: 20,
              width: 120,
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            LoadingBox(width: 80, height: 20),
            LoadingBox(width: 50, height: 20),
          ])
        ],
      ),
    );
  }
}

