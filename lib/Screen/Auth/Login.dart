import 'dart:io';

import 'package:ab_shop/Helper/PageTranstion.dart';
import 'package:ab_shop/Provider/UserProvider.dart';
import 'package:ab_shop/Screen/Auth/Register.dart';
import 'package:ab_shop/Screen/Home.dart';
import 'package:ab_shop/Utlis/SnackBar.dart';
import 'package:ab_shop/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  late String name = '';
  late String password = '';
  Login({super.key, required this.name, required this.password});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  TextEditingController userPhone = TextEditingController();
  TextEditingController userPassword = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userPhone.text = widget.name;
    userPassword.text = widget.password;
  }

  Future<void> submit(BuildContext context) async {
    if (!_key.currentState!.validate()) {
      return;
    }
    final Map<String, dynamic> data = {
      'credentials': userPhone.text,
      'password': userPassword.text,
      'fcm_token_key': 'HELLO',
    };
    final response =
        await Provider.of<UserProvider>(context, listen: false).Login(data);

    ///what is i don't know for suggestion only
    if (!context.mounted) return;
    if (response['status'] == true) {
      SnackBarWidget(context, response['message']);
      Navigator.of(context).pushAndRemoveUntil(
          FadeRightPageRoute(
            builder: (context) => const Main(
              title: 'WELCOME',
            ),
          ),
          (route) => false);
    } else {
      SnackBarWidget(context, 'SOMETHING WAS WRONG!');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userPhone.dispose();
    userPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 18.0),
              child: Center(
                child: CachedNetworkImage(
                  colorBlendMode: BlendMode.overlay,
                  imageUrl:
                      'https://cdn3d.iconscout.com/3d/premium/thumb/login-password-7469262-6138303.png',
                  placeholder: (context, url) => Container(
                      width: 350,
                      height: 300,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator()),
                  width: 350,
                  height: 300,
                ),
              ),
            ),
            Form(
              key: _key,
              child: Column(
                children: [
                  TextFormField(
                    controller: userPhone,
                    scrollPadding: const EdgeInsets.all(10),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(14),
                      labelText: 'User Phone',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(8))),
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
                    obscureText: _obscureText,
                    controller: userPassword,
                    scrollPadding: const EdgeInsets.all(10),
                    decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(14),
                      labelText: 'Password',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(8))),
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
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    overlayColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.surfaceVariant),
                    splashColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    onTap: () => submit(context),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8)),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => {
                Navigator.of(context).pushAndRemoveUntil(
                  FadeRightPageRoute(builder: (context) => const Register()),
                  (route) => false,
                )
              },
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                width: double.infinity,
                alignment: Alignment.bottomRight,
                child: const Text(
                  'Don\'t have an account ? Sign Up',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
