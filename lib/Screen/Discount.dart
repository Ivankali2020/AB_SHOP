import 'package:ab_shop/Helper/PageTranstion.dart';
import 'package:ab_shop/Model/Product.dart';
import 'package:ab_shop/Provider/DIscountProvider.dart';
import 'package:ab_shop/Screen/ProductDetail.dart';
import 'package:ab_shop/Widgets/BannerWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Discount extends StatelessWidget {
  const Discount({super.key});

  @override
  Widget build(BuildContext context) {
    final int id = ModalRoute.of(context)!.settings.arguments as int;

    void detailPage(Product product) {
      Navigator.of(context).push(FadeRightPageRoute(
          builder: (context) => ProductDetail(product: product)));
    }

    Provider.of<DiscountProvider>(context, listen: false)
        .fetchProductsWithBannerId(id);

    return Scaffold(
      appBar: AppBar(
        title: Text('Discount'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Consumer<DiscountProvider>(
              builder: (context, value, child) {
                return value.banner == null
                    ? const Center(
                        child:
                            Loading('Fetching Data', double.infinity, 130, 12),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: value.banner!.photo,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 130,
                          placeholder: (context, url) => const Center(
                            child: Loading(
                                'Getting Photos', double.infinity, 130, 20),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      );
              },
            ),
            Expanded(
              child: Consumer<DiscountProvider>(
                builder: (context, value, child) {
                  return value.products.isEmpty
                      ? const Center(
                          child: Loading(
                              'No Discount Products', double.infinity, 100, 12),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: value.products.length,
                          itemBuilder: (context, i) {
                            final product = value.products[i];
                            return Container(
                              margin: EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl: product.photos[0],
                                          fit: BoxFit.cover,
                                          height: 125,
                                          width: 100,
                                          placeholder: (context, url) =>
                                              const Center(
                                                  child: Loading(
                                                      'Getting ',
                                                      double.infinity,
                                                      120,
                                                      10),),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                      Container(
                                        width: 180,
                                        padding: const EdgeInsets.symmetric(horizontal:10.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Name : ${product.name}",
                                              overflow: TextOverflow.fade,
                                              style: GoogleFonts.nunito(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13),
                                            ),
                                           const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              "Category : ${product.categoryName}",
                                              style: GoogleFonts.nunito(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 13),
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              "Brand : ${product.brandName}",
                                              style: GoogleFonts.nunito(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        product.discountPrice == 0
                                            ? Text(
                                                '${product.price}',
                                                style: GoogleFonts.nunito(
                                                    color: Colors.redAccent,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              )
                                            : Column(
                                                children: [
                                                  Text(
                                                    '${product.price}',
                                                    style: GoogleFonts.nunito(
                                                        color: Colors.redAccent,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14),
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  Text(
                                                    '${product.discountPrice} Ks',
                                                    style: GoogleFonts.nunito(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14),
                                                  ),
                                                ],
                                              ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        IconButton(
                                            onPressed: () =>
                                                detailPage(product),
                                            icon:
                                                const Icon(Icons.info_outline))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
