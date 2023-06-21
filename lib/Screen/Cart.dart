import 'package:ab_shop/Helper/PageTranstion.dart';
import 'package:ab_shop/Provider/AuthManager.dart';
import 'package:ab_shop/Provider/CartProvider.dart' as CardProvider;
import 'package:ab_shop/Provider/UserProvider.dart';
import 'package:ab_shop/Screen/Auth/Login.dart';
import 'package:ab_shop/Screen/Checkout.dart';
import 'package:ab_shop/Widgets/BannerWidget.dart';
import 'package:ab_shop/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCarts();
  }

  Future<void> fetchCarts() async {
    // final token = await AuthManager.getToken();
    // if (token == '') {
    //   Navigator.of(context).pushAndRemoveUntil(
    //       FadeRightPageRoute(
    //           builder: (context) => Login(name: '', password: '')),
    //       (route) => false);
    // }
  //  Provider.of<CardProvider.CartProvider>(context, listen: false)
  //       .fetchCarts(token!,isReload: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CartItems(),
          Consumer<UserProvider>(
            builder: (context, value, child) {
              return value.token!.isNotEmpty
                  ? const CheckoutNow()
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 30),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        overlayColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.surfaceVariant),
                        splashColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                        onTap: () {
                          Navigator.of(context).push(
                            FadeRightPageRoute(
                              builder: (context) => Login(
                                name: '',
                                password: '',
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            // color: ,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Login'.toUpperCase(),
                          ),
                        ),
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}

class CartItems extends StatelessWidget {
  const CartItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Consumer<CardProvider.CartProvider>(
        builder: (context, value, child) {
          return value.carts.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CachedNetworkImage(
                      imageUrl:
                          'https://cdn3d.iconscout.com/3d/free/thumb/free-empty-cart-3543011-2969398.png',
                      placeholder: (context, i) => Container(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      ),
                      width: 300,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                    Loading('Empty Cart', double.infinity, 100, 20)
                  ],
                )
              : ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: value.carts.length,
                  itemBuilder: (context, i) {
                    final cart = value.carts[i];
                    return Container(
                      height: 90,
                      margin: const EdgeInsets.only(bottom: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: Theme.of(context).colorScheme.tertiary)),
                      child: ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: cart.product.photos[0],
                          placeholder: (context, i) => Container(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(),
                          ),
                          width: 50,
                          height: 50,
                          fit: BoxFit.contain,
                        ),
                        title: Text(
                          cart.product.name,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          style: GoogleFonts.bebasNeue(
                              fontSize: 18, letterSpacing: 2),
                        ),
                        subtitle: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              width: 60,
                              height: 25,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8)),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                    cart.product.categoryName.toUpperCase(),
                                    style: TextStyle(fontSize: 10)),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              width: 60,
                              height: 25,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8)),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  cart.product.subCategoryName.toUpperCase(),
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: ActionCart(cart, context),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }

  Container ActionCart(CardProvider.Cart cart, BuildContext context) {
    return Container(
      width: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          cart.product.discountPrice != 0
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        "${cart.product.price.toString()} ks",
                        style: const TextStyle(
                          color: Colors.redAccent,
                          decoration: TextDecoration.lineThrough,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        "${cart.product.discountPrice.toString()} ks",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                )
              : Padding(
                  padding: EdgeInsets.only(left: 5, bottom: 5),
                  child: Text(
                    cart.product.price.toString() + ' Ks',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
          Container(
            width: 100,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              // color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // minus
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  overlayColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.tertiaryContainer),
                  focusColor: Theme.of(context).colorScheme.tertiaryContainer,
                  splashColor: Theme.of(context).colorScheme.secondaryContainer,
                  onTap: () async {
                     final token = await AuthManager.getToken();
                      if(token == ''){
                        Navigator.of(context).pushAndRemoveUntil(
                          FadeRightPageRoute(builder: (context) => Login(name: '', password: '')),
                          (route) => false,
                        );
                      }
                    Provider.of<CardProvider.CartProvider>(context,
                            listen: false)
                        .updateCart(cart.product, false,token!);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 5),
                    width: 25,
                    height: 25,
                    alignment: Alignment.center,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8)),
                    child: const Icon(
                      CupertinoIcons.minus,
                      size: 15,
                    ),
                  ),
                ),

                //quanity
                Container(
                  margin: EdgeInsets.only(top: 5),
                  width: 25,
                  height: 25,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(cart.quantity.toString()),
                ),

                //add quantity
                InkWell(
                  overlayColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.tertiaryContainer),
                  focusColor: Theme.of(context).colorScheme.tertiaryContainer,
                  splashColor: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                  onTap: () async {
                    final token = await AuthManager.getToken();
                      if(token == ''){
                        Navigator.of(context).pushAndRemoveUntil(
                          FadeRightPageRoute(builder: (context) => Login(name: '', password: '')),
                          (route) => false,
                        );
                      }
                    Provider.of<CardProvider.CartProvider>(context,
                            listen: false)
                        .updateCart(cart.product, true,token!);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 5),
                    width: 25,
                    height: 25,
                    alignment: Alignment.center,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8)),
                    child: const Icon(
                      CupertinoIcons.add,
                      size: 15,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CheckoutNow extends StatelessWidget {
  const CheckoutNow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: const Border(
          top: BorderSide(
            color: Color.fromARGB(255, 232, 232, 232),
          ),
        ),
      ),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                  Consumer<CardProvider.CartProvider>(
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
              Material(
                color: Colors.transparent,
                child: Consumer<CardProvider.CartProvider>(
                    builder: (context, value, child) {
                  return value.carts.isEmpty
                      ? InkWell(
                          borderRadius: BorderRadius.circular(8),
                          overlayColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.surfaceVariant),
                          splashColor:
                              Theme.of(context).colorScheme.secondaryContainer,
                          onTap: () {
                            Navigator.of(context).push(FadeRightPageRoute(
                                builder: (context) => Main(
                                      title: 'AB SHOP',
                                    )));
                          },
                          child: Container(
                            width: 150,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              // color: ,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Get Products'.toUpperCase(),
                            ),
                          ),
                        )
                      : InkWell(
                          borderRadius: BorderRadius.circular(8),
                          overlayColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.surfaceVariant),
                          splashColor:
                              Theme.of(context).colorScheme.secondaryContainer,
                          onTap: () {
                            Navigator.of(context).push(FadeRightPageRoute(
                                builder: (context) => const Checkout()));
                          },
                          child: Container(
                            width: 150,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              // color: ,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Checkout Now'.toUpperCase(),
                            ),
                          ),
                        );
                }),
              ),
            ],
          )
        ],
      ),
    );
  }
}
