import 'package:ab_shop/Helper/PageTranstion.dart';
import 'package:ab_shop/Provider/ProductProvider.dart';
import 'package:ab_shop/Provider/UserProvider.dart';
import 'package:ab_shop/Screen/ProductDetail.dart';
import 'package:ab_shop/Utlis/SnackBar.dart';
import 'package:ab_shop/Widgets/BannerWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ab_shop/Model/Product.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatelessWidget {
  final List<Product> products;
  final double height;
  const ProductWidget(
      {super.key, required this.height, required this.products});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: products.length,
          itemBuilder: (context, i) {
            return ProductItem(product: products[i]);
          }),
    );
  }
}

Future<void> _favouriteToggle(Product product, BuildContext context) async {
  final token = Provider.of<UserProvider>(context, listen: false).token;
  final Map<String,dynamic> respons = await Provider.of<ProductProvider>(context, listen: false)
      .favourite(product, token!);

  if (respons['status']) {
    SnackBarWidget(context, respons['message']);
  }else{
    SnackBarWidget(context, 'FAILED!');
  }
}

class ProductItem extends StatelessWidget {
  final Product product;
  late double leftPadding;
  ProductItem({super.key, required this.product, this.leftPadding = 10});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165,
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 241, 241, 241)),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(right: 3, left: 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.of(context).push(FadeRightPageRoute(
              builder: (context) => ProductDetail(
                    product: product,
                  )));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: product.photos[0],
                      placeholder: (context, url) => const Loading(
                        'Loading',
                        165,
                        165,
                        13,
                      ),
                      fit: BoxFit.cover,
                      width: 165,
                      height: 165,
                    ),
                  ),
                ),
                Provider.of<UserProvider>(context, listen: false).token == '' ? Container() : Positioned(
                  top: -5,
                  left: -5,
                  child: IconButton(
                    splashRadius: 1,
                    splashColor: Theme.of(context).colorScheme.tertiary,
                    onPressed: () => _favouriteToggle(product, context),
                    icon: Icon(
                      product.isFavourite
                          ? Icons.favorite_sharp
                          : Icons.favorite_outline_outlined,
                      color:
                          product.isFavourite ? Colors.redAccent : Colors.grey,
                      size: 18,
                    ),
                  ),
                ),
                product.discountPrice != 0 &&
                        product.banner!.discountPercentage != 0
                    ? Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            product.banner!.discountPercentage.toString() +
                                ' %',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.redAccent),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: leftPadding),
              child: FittedBox(
                fit: BoxFit.cover,
                child: Text(
                  product.name,
                  overflow: TextOverflow.fade,
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.normal, fontSize: 14),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: leftPadding),
              child: Text(
                "Cat : ${product.categoryName} ${ product.isFavourite ? 'yes' : 'no'}",
                style: GoogleFonts.nunito(
                    fontWeight: FontWeight.normal, fontSize: 13),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: leftPadding),
              child: Text(
                "Brand : ${product.brandName}",
                style: GoogleFonts.nunito(
                    fontWeight: FontWeight.normal, fontSize: 13),
              ),
            ),
            product.discountPrice != 0
                ? Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: leftPadding, bottom: 5),
                        child: Text(
                          product.price.toString(),
                          style: GoogleFonts.nunito(
                              color: Colors.redAccent,
                              decoration: TextDecoration.lineThrough,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: leftPadding, bottom: 5),
                        child: Text(
                          product.discountPrice.toString() + ' Ks',
                          style: GoogleFonts.nunito(
                              fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ],
                  )
                : Padding(
                    padding: EdgeInsets.only(left: leftPadding, bottom: 5),
                    child: Text(
                      product.price.toString() + ' Ks',
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
