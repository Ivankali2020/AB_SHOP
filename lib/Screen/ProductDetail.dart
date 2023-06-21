import 'package:ab_shop/Helper/PageTranstion.dart';
import 'package:ab_shop/Model/Product.dart';
import 'package:ab_shop/Provider/AuthManager.dart';
import 'package:ab_shop/Provider/BannerProvider.dart';
import 'package:ab_shop/Provider/CartProvider.dart';
import 'package:ab_shop/Provider/UserProvider.dart';
import 'package:ab_shop/Screen/Auth/Login.dart';
import '../Screen/Cart.dart' as CartScreen;
import 'package:ab_shop/Widgets/BannerWidget.dart';
import 'package:ab_shop/Widgets/CategoryMain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final _controller = PageController();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    width: double.infinity,
                    height: 400,
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: product.photos.length,
                      itemBuilder: (context, i) {
                        return BannerImageWidget(
                          photo: product.photos[i],
                        );
                      },
                    ),
                  ),
                  Center(
                    child: SmoothPageIndicator(
                      controller: _controller,
                      count: product.photos.length,
                      effect: const ExpandingDotsEffect(
                        dotWidth: 6,
                        dotHeight: 5,
                        activeDotColor: Colors.redAccent,
                        dotColor: Color.fromARGB(255, 240, 240, 240),
                      ),
                    ),
                  ),
                  ProductName(),
                  const SizedBox(
                    height: 15,
                  ),
                  CategoryBrand(),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(product.detail),
                ],
              ),
            ),
            Positioned(
              left: 0,
              top: 5,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(CupertinoIcons.chevron_left),
              ),
            ),
            Positioned(
              right: 0,
              top: 5,
              child: IconButton(
                onPressed: () {},
                icon: Icon(CupertinoIcons.cart),
              ),
            ),
            AddToCart(context),
          ],
        ),
      ),
    );
  }

  Positioned AddToCart(BuildContext context) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 70,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
                top: BorderSide(color: Color.fromARGB(255, 232, 232, 232)))),
        width: double.infinity,
        // color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Total Amount',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Consumer<CartProvider>(
                      builder: (context, cart, child) {
                        return Text(
                          cart.total.toString(),
                          style: GoogleFonts.bebasNeue(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 2,
                              color: Theme.of(context).colorScheme.primary),
                        );
                      },
                    ),
                    const Text(
                      ' Ks',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),
            Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  overlayColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.tertiaryContainer),
                  focusColor: Theme.of(context).colorScheme.tertiaryContainer,
                  splashColor: Theme.of(context).colorScheme.secondaryContainer,
                  onTap: () {
                    Navigator.of(context).push(FadeRightPageRoute(
                        builder: (context) => CartScreen.Cart()));
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.zero,
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(0)),
                    ),
                    child: const Icon(CupertinoIcons.cart),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    overlayColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.tertiaryContainer),
                    focusColor: Theme.of(context).colorScheme.tertiaryContainer,
                    splashColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    onTap: () async {
                      final token = await AuthManager.getToken();
                      if(token == ''){
                        Navigator.of(context).pushAndRemoveUntil(
                          FadeRightPageRoute(builder: (context) => Login(name: '', password: '')),
                          (route) => false,
                        );
                      }
                      Provider.of<CartProvider>(context, listen: false)
                          .addToCart(product, 1,token!);
                    },
                    child: Container(
                      width: 150,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        // color: ,
                        border: Border.all(color: Colors.grey),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(8),
                            bottomLeft: Radius.zero,
                            bottomRight: Radius.circular(8)),
                      ),
                      child: Text(
                        'Add to Cart'.toUpperCase(),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Row CategoryBrand() {
    return Row(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {},
          child: Container(
            width: 100,
            height: 35,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8)),
            child: Text(
              product.categoryName.toUpperCase(),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {},
          child: Container(
            width: 100,
            height: 35,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8)),
            child: Text(
              product.subCategoryName.toUpperCase(),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }

  Row ProductName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              product.name,
              style: GoogleFonts.bebasNeue(fontSize: 22, letterSpacing: 2),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              product.brandName.toUpperCase(),
            ),
          ],
        ),
        product.discountPrice != 0
            ? Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 5, bottom: 10),
                    child: Text(
                      product.price.toString() + ' Ks',
                      style: const TextStyle(
                          color: Colors.redAccent,
                          decoration: TextDecoration.lineThrough,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      product.discountPrice.toString() + ' Ks',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              )
            : Padding(
                padding: EdgeInsets.only(left: 5, bottom: 5),
                child: Text(
                  product.price.toString() + ' Ks',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
      ],
    );
  }
}
