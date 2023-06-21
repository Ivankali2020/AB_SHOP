import 'package:ab_shop/Helper/PageTranstion.dart';
import 'package:ab_shop/Provider/AuthManager.dart';
import 'package:ab_shop/Provider/ProductProvider.dart';
import 'package:ab_shop/Provider/UserProvider.dart';
import 'package:ab_shop/Screen/Search.dart';
import 'package:ab_shop/Widgets/BannerWidget.dart';
import 'package:ab_shop/Widgets/CategoryMain.dart';
import 'package:ab_shop/Widgets/ProductWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }




  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const BannerWidget(),
            const SizedBox(
              height: 20,
            ),
            const CategoryMain(),
            const SizedBox(
              height: 20,
            ),
            const HomeSubWidget(
              title: 'Latest Products',
              SeeMore: SearchScreen(),
              isDiscount: false,
            ),
            const SizedBox(
              height: 12,
            ),
            FutureBuilder(
              future: Provider.of<ProductProvider>(context, listen: false)
                  .fetchProducts(),
              builder: (context, snapShot) {
                if (snapShot.connectionState == ConnectionState.waiting) {
                  return const Loading('Loading', double.infinity, 270, 20);
                }
                if (snapShot.connectionState == ConnectionState.done) {
                  final products =
                      Provider.of<ProductProvider>(context).products;

                  return products.isEmpty
                      ? Center(
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: 200,
                            child: const Text('Empty Products'),
                          ),
                        )
                      : ProductWidget(
                          height: 270,
                          products: products,
                        );
                }

                return const Center(
                  child: Text('Empty Products'),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const HomeSubWidget(
              title: 'Discount For You',
              SeeMore: SearchScreen(),
              isDiscount: true,
            ),
            const SizedBox(
              height: 12,
            ),
            FutureBuilder(
              future: Provider.of<ProductProvider>(context, listen: false)
                  .fetchDiscoutProducts(),
              builder: (context, snapShot) {
                if (snapShot.connectionState == ConnectionState.waiting) {
                  return const Loading('Loading', double.infinity, 270, 20);
                }
                if (snapShot.connectionState == ConnectionState.done) {
                  final discountProducts =
                      Provider.of<ProductProvider>(context).discountProducts;

                  return discountProducts.isEmpty
                      ? Container(
                          width: double.infinity,
                          height: 200,
                          alignment: Alignment.center,
                          child: const Text('Empty Products'),
                        )
                      : ProductWidget(
                          height: 290,
                          products: discountProducts,
                        );
                }

                return Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 200,
                  child: const Text('Empty Products'),
                );
              },
            ),
            const SizedBox(
              height: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class HomeSubWidget extends StatelessWidget {
  final String title;
  final Widget SeeMore;
  final bool isDiscount;
  const HomeSubWidget(
      {super.key,
      required this.title,
      required this.SeeMore,
      required this.isDiscount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          title,
          style: GoogleFonts.bebasNeue(fontSize: 20),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            Provider.of<ProductProvider>(context, listen: false)
                .addSearchProduct(isDiscount);
            Navigator.of(context)
                .push(FadeRightPageRoute(builder: (context) => SeeMore));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Text(
              'See more',
              style: GoogleFonts.nunito(fontSize: 10),
            ),
          ),
        )
      ]),
    );
  }
}
