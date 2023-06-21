import 'dart:io';

import 'package:ab_shop/Helper/PageTranstion.dart';
import 'package:ab_shop/Model/Cart.dart' as CartModal;
import 'package:ab_shop/Provider/OrderProvider.dart';
import 'package:ab_shop/Provider/UserProvider.dart';
import 'package:ab_shop/Screen/CheckoutSuccess.dart';
import 'package:ab_shop/Utlis/CouponItem.dart';
import 'package:ab_shop/Utlis/SnackBar.dart';
import 'package:ab_shop/Widgets/SnackBarWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:ab_shop/Provider/CartProvider.dart' as CardProvider;

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  TextEditingController userPhone = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController userAddress = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final orderProvide = Provider.of<OrderProvider>(context, listen: false);
    userPhone.text = userProvider.userData!.credentials;
    userName.text = userProvider.userData!.name;

    orderProvide.fetchPayment();
    orderProvide.fetchRegions();
    userProvider.fetchCoupons();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userPhone.dispose();
    userName.dispose();
    userAddress.dispose();
  }

  Future<void> selectImage() async {
    final picker = ImagePicker();
    final pickImage = await picker.pickImage(source: ImageSource.gallery);

    if (!context.mounted) return;
    if (pickImage != null) {
      Provider.of<OrderProvider>(context, listen: false)
          .addSlip(File(pickImage.path));
    }
  }

  Future<void> submit() async {
    if (!_key.currentState!.validate()) {
      return;
    }

    final townshiop =
        Provider.of<OrderProvider>(context, listen: false).township;
    final slip = Provider.of<OrderProvider>(context, listen: false).slip;

    if (townshiop == null) {
      SnackBarWidget(context, 'Township Is Required!');
      return;
    } else {
      if (!townshiop.cod) {
        if (slip == null) {
          SnackBarWidget(context,
              "${townshiop.townshipName} is not provide COD ayment slip required");
          return;
        }
      }
    }

    final cartProvider =
        Provider.of<CardProvider.CartProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final carts = cartProvider.carts;
    final token = userProvider.token ?? '';

    if (token == '') {
      SnackBarWidget(context, "You Need To Login");
    }

    final List<CartModal.Cart> newCarts = [];
    carts
        .map((e) => newCarts.add(CartModal.Cart(
            productId: e.product.id,
            quantity: e.quantity,
            bannerId: e.product.banner != null
                ? e.product.banner!.id.toString()
                : '')))
        .toList();

    final Map userData = {
      'name': userName.text,
      'phone': userPhone.text,
      'address': userAddress.text,
      'user_id': userProvider.userData!.id,
    };

    final Map<String, dynamic> response =
        await Provider.of<OrderProvider>(context, listen: false)
            .order(newCarts, token, userData);

    if (!context.mounted) return;

    if (!response['status']) {
      SnackBarWidget(context, response['message']);
    } else {
      cartProvider.emptyCart();
      orderProvider.emptyOrder();
      SnackBarWidget(context, response['message']);

      Navigator.of(context).push(
          FadeRightPageRoute(builder: (context) => const CheckoutSuccess()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: ListView(
                padding: EdgeInsets.all(18),
                children: [
                  Form(
                    key: _key,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: userName,
                          scrollPadding: const EdgeInsets.all(10),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(14),
                            labelText: 'Delivery Name',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == '') {
                              return 'Required';
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: userPhone,
                          scrollPadding: const EdgeInsets.all(10),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(14),
                            labelText: 'Delivery Phone',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          ),
                          validator: (value) {
                            if (value == '') {
                              return 'Required Phone';
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          maxLines: 3,
                          controller: userAddress,
                          scrollPadding: const EdgeInsets.all(10),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(14),
                            labelText: 'Delivery Address',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          ),
                          validator: (value) {
                            if (value == '') {
                              return 'Required Address';
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    overlayColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.surfaceVariant),
                    splashColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    onTap: () => couponsModalBottomSheet(context),
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
                        'Coupons'.toUpperCase(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    overlayColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.surfaceVariant),
                    splashColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    onTap: () => regionModalBottomSheet(context),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        Provider.of<OrderProvider>(context).region == null
                            ? 'Select Region'
                            : Provider.of<OrderProvider>(context)
                                .region!
                                .region,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Provider.of<OrderProvider>(context).region == null
                      ? Container()
                      : InkWell(
                          borderRadius: BorderRadius.circular(8),
                          overlayColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.surfaceVariant),
                          splashColor:
                              Theme.of(context).colorScheme.secondaryContainer,
                          onTap: () => townshiopModalBottomSheet(context),
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8)),
                            child: Text(
                              Provider.of<OrderProvider>(context).township ==
                                      null
                                  ? 'Select township'
                                  : Provider.of<OrderProvider>(context)
                                      .township!
                                      .townshipName,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  Consumer<OrderProvider>(
                    builder: (context, value, child) {
                      return value.township == null
                          ? Container()
                          : !value.township!.cod
                              ? InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  overlayColor: MaterialStateProperty.all(
                                      Theme.of(context)
                                          .colorScheme
                                          .surfaceVariant),
                                  splashColor: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                  onTap: () => paymentModalBottomSheet(context),
                                  child: Container(
                                      height: 50,
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Consumer<OrderProvider>(
                                        builder: (context, value, child) {
                                          return value.payment == null
                                              ? const Text(
                                                  'Select Payment Account',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                )
                                              : Text(
                                                  value.payment!.name,
                                                  style: GoogleFonts.bebasNeue(
                                                      fontSize: 20),
                                                );
                                        },
                                      )),
                                )
                              : Container();
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Consumer<OrderProvider>(
                    builder: (context, value, child) {
                      return value.township == null
                          ? Container()
                          : !value.township!.cod
                              ? InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  overlayColor: MaterialStateProperty.all(
                                      Theme.of(context)
                                          .colorScheme
                                          .surfaceVariant),
                                  splashColor: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer,
                                  onTap: selectImage,
                                  child: Container(
                                    height: 50,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: const Text(
                                      'Select Payment Slip',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                )
                              : Container();
                    },
                  ),
                  Consumer<OrderProvider>(builder: (context, value, child) {
                    return value.slip != null
                        ? Container(
                            width: 300,
                            height: 400,
                            margin: const EdgeInsets.only(top: 30),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: FileImage(value.slip!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Container();
                  })
                ],
              ),
            ),
            OrderNowWidget(
              submit: submit,
            ),
          ],
        ),
      ),
    );
  }
}

Future<dynamic> regionModalBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    builder: (context) {
      return Container(
        height: 400,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: const Text(
                'REGION',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Consumer<OrderProvider>(
              builder: (context, value, child) {
                return value.regions.isEmpty
                    ? const Center(child: Text('No regions Found'))
                    : Expanded(
                        child: GridView.builder(
                          itemCount: value.regions.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 8,
                                  mainAxisExtent: 50,
                                  mainAxisSpacing: 8),
                          itemBuilder: (context, i) {
                            return InkWell(
                              onTap: () {
                                value.addRegion(value.regions[i]);
                                Navigator.of(context).pop();
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: value.region?.regionId ==
                                            value.regions[i].regionId
                                        ? Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary)
                                        : Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10)),
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Text(
                                    value.regions[i].region.toUpperCase(),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
              },
            )
          ],
        ),
      );
    },
  );
}

Future<dynamic> townshiopModalBottomSheet(BuildContext context) {
  Provider.of<OrderProvider>(context, listen: false).fetchTownship();
  return showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    builder: (context) {
      return Container(
        height: 400,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Consumer<OrderProvider>(
                builder: (context, value, child) {
                  return Text(
                    value.region!.region + ' Region',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  );
                },
              ),
            ),
            Consumer<OrderProvider>(
              builder: (context, value, child) {
                return value.townships.isEmpty
                    ? const Center(child: Text('No Township Found'))
                    : Expanded(
                        child: GridView.builder(
                          itemCount: value.townships.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8,
                                  mainAxisExtent: 120,
                                  mainAxisSpacing: 8),
                          itemBuilder: (context, i) {
                            return InkWell(
                              onTap: () {
                                value.addTownship(value.townships[i]);
                                Navigator.of(context).pop();
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 120,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border: value.township?.townshipId ==
                                            value.townships[i].townshipId
                                        ? Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary)
                                        : Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(
                                          value.townships[i].townshipName
                                              .toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Text(
                                        "Deli ${value.townships[i].fees.toString()} Ks"),
                                    Text(
                                        "Duration ${value.townships[i].duration.toString()} Day"),
                                    Text(
                                      value.townships[i].cod
                                          ? "COD"
                                          : "NOT COD",
                                      style: TextStyle(
                                          color: value.townships[i].cod
                                              ? Colors.green
                                              : Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
              },
            ),
          ],
        ),
      );
    },
  );
}

Future<dynamic> paymentModalBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    builder: (context) {
      return Container(
        height: 400,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: const Text(
                ' Payments',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Consumer<OrderProvider>(
              builder: (context, value, child) {
                return value.townships.isEmpty
                    ? const Center(child: Text('No Payments Found'))
                    : Expanded(
                        child: GridView.builder(
                          itemCount: value.payments.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  crossAxisSpacing: 8,
                                  mainAxisExtent: 100,
                                  mainAxisSpacing: 8),
                          itemBuilder: (context, i) {
                            return InkWell(
                              onTap: () {
                                value.addPayment(value.payments[i]);
                                Navigator.of(context).pop();
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 120,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border: value.payment?.id ==
                                            value.payments[i].id
                                        ? Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary)
                                        : Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10)),
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl: value.payments[i].photo,
                                      placeholder: (context, url) => Container(
                                        width: 120,
                                        height: 120,
                                        alignment: Alignment.center,
                                        child:
                                            const CircularProgressIndicator(),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(
                                    value.payments[i].name.toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    value.payments[i].account,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
              },
            ),
          ],
        ),
      );
    },
  );
}

class OrderNowWidget extends StatelessWidget {
  final Function submit;
  const OrderNowWidget({super.key, required this.submit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 80,
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
                  Consumer2<CardProvider.CartProvider, OrderProvider>(
                    builder: (context, CartProvider, OrderProvider, child) {
                      return Text(
                        (CartProvider.total - OrderProvider.coupon_amount)
                            .toString(),
                        style: GoogleFonts.bebasNeue(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            letterSpacing: 2,
                            color: Theme.of(context).colorScheme.primary),
                      );
                    },
                  ),
                  const Text(
                    ' Ks + ',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Consumer<OrderProvider>(
                    builder: (context, value, child) {
                      return Text(
                        value.township != null
                            ? value.township!.fees.toString()
                            : '0',
                        style: GoogleFonts.bebasNeue(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            letterSpacing: 2,
                            color: Theme.of(context).colorScheme.primary),
                      );
                    },
                  ),
                  const Text(
                    ' Deli',
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
                child: Consumer<OrderProvider>(
                  builder: (context, value, child) {
                    return value.isLoading
                        ? InkWell(
                            borderRadius: BorderRadius.circular(8),
                            overlayColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.surfaceVariant),
                            splashColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            onTap: () =>
                                snackBarWidget(context, 'PROCESSING ORDER'),
                            child: Container(
                              width: 150,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                // color: ,
                                border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .tertiaryContainer),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : InkWell(
                            borderRadius: BorderRadius.circular(8),
                            overlayColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.surfaceVariant),
                            splashColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            onTap: () => submit(),
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
                                'Order Now'.toUpperCase(),
                              ),
                            ),
                          );
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

Future<dynamic> couponsModalBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    backgroundColor: Colors.white,
    context: context,
    builder: (context) {
      return Container(
        height: 600,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 30),
              child: Text(
                'YOUR AVAILABLE COUPONS',
                style: GoogleFonts.bebasNeue(fontSize: 25, letterSpacing: 3),
              ),
            ),
            Consumer<UserProvider>(
              builder: (context, value, child) {
                return value.coupons.isEmpty
                    ? const Center(child: Text('NO COUPONS FOUND'))
                    : Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: value.coupons.length,
                          itemBuilder: (context, i) {
                            final coupon = value.coupons[i];
                            return coupon.isUsed
                                ? Container()
                                : CouponItem(
                                    coupon: coupon,
                                    isCheckoutScreen: true,
                                  );
                          },
                        ),
                      );
              },
            )
          ],
        ),
      );
    },
  );
}
