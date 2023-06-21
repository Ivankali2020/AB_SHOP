import 'package:ab_shop/Helper/PageTranstion.dart';
import 'package:ab_shop/Widgets/BannerWidget.dart';
import 'package:ab_shop/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class CheckoutSuccess extends StatelessWidget {
  const CheckoutSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                FadeRightPageRoute(
                  builder: (context) => const Main(title: 'WELCOM'),
                ),
                (route) => false
              );
            },
            child: const Icon(Icons.home)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Center(
                child: CachedNetworkImage(
                  imageUrl:
                      'https://cdn3d.iconscout.com/3d/premium/thumb/delivery-person-going-to-order-delivery-location-5130364-4298165.png',
                  fit: BoxFit.contain,
                  width: 300,
                  placeholder: (context, i) {
                    return Container(
                      alignment: Alignment.center,
                      height: 300,
                      width: 200,
                      child: const CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              Shimmer.fromColors(
                enabled: true,
                baseColor: Color.fromARGB(255, 242, 180, 180),
                highlightColor: Color.fromARGB(255, 237, 101, 101),
                child: Center(
                  child: Text(
                    'Thanks for shopping with us',
                    textAlign: TextAlign.center,
                    style:
                        GoogleFonts.bebasNeue(fontSize: 15, letterSpacing: 3),
                  ),
                ),
              ),
            ],
          ),
          const Loading('The fastest way to delivery to your location',
              double.infinity, 40, 13)
        ],
      ),
    );
  }
}
