import 'package:ab_shop/Model/Coupon.dart';
import 'package:ab_shop/Provider/OrderProvider.dart';
import 'package:coupon_uikit/coupon_uikit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CouponItem extends StatelessWidget {
  final Coupon coupon;
  late bool isCheckoutScreen = false;
  CouponItem({Key? key, required this.coupon, this.isCheckoutScreen = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color.fromARGB(255, 255, 255, 255);
    const Color secondaryColor = Color(0xffd88c9a);

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: CouponCard(
        height: 150,
        backgroundColor: primaryColor,
        curveAxis: Axis.vertical,
        firstChild: Container(
          decoration: const BoxDecoration(
            color: secondaryColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          '${coupon.amount} ks',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(color: Colors.white54, height: 0),
              Expanded(
                child: Center(
                  child: Text(
                    coupon.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        secondChild: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        'Coupon Code',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  isCheckoutScreen
                      ? Consumer<OrderProvider>(
                          builder: (context, orderValue, child) {
                            return Radio(
                                value: coupon.id,
                                groupValue: orderValue.coupon_id,
                                onChanged: (value) {
                                  orderValue.addCouponAmount(coupon.amount);
                                  orderValue.addCouponId(value!);
                                });
                          },
                        )
                      : coupon.isUsed
                          ? const Icon(
                              Icons.error,
                              color: Colors.redAccent,
                            )
                          : const Icon(
                              Icons.check,
                              color: Colors.greenAccent,
                            ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                coupon.code,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  color: secondaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                'Valid Till - ${coupon.expireDate}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
