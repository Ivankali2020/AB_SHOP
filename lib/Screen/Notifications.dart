import 'package:ab_shop/Helper/PageTranstion.dart';
import 'package:ab_shop/Provider/OrderProvider.dart';
import 'package:ab_shop/Provider/UserProvider.dart';
import 'package:ab_shop/Screen/OrderDetail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: FutureBuilder(
          future: Provider.of<UserProvider>(context, listen: false)
              .fetchNotifications(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              final notis = Provider.of<UserProvider>(context).notifications;
              final token = Provider.of<UserProvider>(context).token;
              return notis.isEmpty
                  ? const Center(
                      child: Text('Empty Notifications'),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: notis.length,
                      itemBuilder: (context, i) {
                        final noti = notis[i];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => orderDetailPage(
                                noti.orderUniqueId,token!
                              ),
                            child: Container(

                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    noti.message,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        noti.date,
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
            }

            return const Center(
              child: Text('SOMETHING WAS WRONG!'),
            );
          }),
    );
  }
}
