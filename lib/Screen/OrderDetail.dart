import 'package:flutter/material.dart';
import '../Model/OrderDetail.dart';
import '../Provider/OrderProvider.dart';
// import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    // final id = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Detail'),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, value, child) {
          final detail = value.orderDetail;
          return Column(
            children: [
              Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "User Info",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(
                            "Date : ${detail.date}",
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Name'),
                          Text(
                            " ${detail.deliveryName} ",
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Phone'),
                          Text(
                            " ${detail.deliveryPhone} ",
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Address'),
                          Text(
                            " ${detail.shippingAddress} ",
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              detail.products.isEmpty
                  ? const Center(
                      child: Text('No Products Found'),
                    )
                  : Expanded(
                      child: ListView.builder(
                          itemCount: detail.products.length,
                          itemBuilder: (context, i) {
                            return Container(
                              margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black26, width: 0.5),
                                  borderRadius: BorderRadius.circular(8)),
                              child: ListTile(
                                title: Text(detail.products[i].name),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    detail.products[i].discountPrice == 0
                                        ? Text(
                                            'Price : ${(detail.products[i].price).toString()} ks',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          )
                                        : Text(
                                            'Price : ${(detail.products[i].discountPrice).toString()} ks',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                    Text(
                                      'Category : ${detail.products[i].category}',
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                trailing: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                  Text(
                                            'Total : ${detail.products[i].totalPrice.toString()} Ks'),
                                    Text(
                                        "x ${detail.products[i].quantity.toString()} qty"),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
              Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          "Order Summary",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal'),
                          Text(
                            " ${detail.totalPrice} Ks",
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Delivery'),
                          Text(
                            " ${detail.deliveryFees} Ks",
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                       detail.couponAmount != 0 ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Coupoon Amount'),
                          Text(
                            "- ${detail.couponAmount} Ks",
                            style: TextStyle(color: Theme.of(context).colorScheme.primary),
                          )
                        ],
                      ) : Container(),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(
                            " ${detail.totalPrice} Ks",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
