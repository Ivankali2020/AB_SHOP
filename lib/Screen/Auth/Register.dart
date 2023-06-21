import 'package:ab_shop/Helper/PageTranstion.dart';
import 'package:ab_shop/Provider/UserProvider.dart';
import 'package:ab_shop/Screen/Auth/Login.dart';
import 'package:ab_shop/Screen/Home.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _obscureText = true;

  GlobalKey<FormState> _key = GlobalKey<FormState>();

  TextEditingController userName = TextEditingController();

  TextEditingController userPhone = TextEditingController();

  TextEditingController userPassword = TextEditingController();

  TextEditingController userConfirmPassword = TextEditingController();

  Future<void> submit() async {
    if (!_key.currentState!.validate()) {
      return;
    }
    final data = {
      'name': userName.text,
      'credentials': userPhone.text,
      'password': userPassword.text,
      'password_confirmation': userConfirmPassword.text,
      'fcm_token_key': 'sdf',
    };

    final response =
        await Provider.of<UserProvider>(context, listen: false).Register(data);

    if (response['status'] == true) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response['message'])));
      Navigator.of(context)
          .push(FadeRightPageRoute(builder: (context) => Login(name: userPhone.text,password: userPassword.text,)));
    } else {
      print(response['message']);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response['message'])));
    }
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
            Center(
              child: CachedNetworkImage(
                imageUrl:
                    'https://cdn3d.iconscout.com/3d/premium/thumb/virtual-vision-4768955-3975759.png',
                placeholder: (context, url) => Container(
                    width: 300,
                    height: 300,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator()),
                width: 300,
                height: 300,
              ),
            ),
            Form(
              key: _key,
              child: Column(
                children: [
                  TextFormField(
                    controller: userName,
                    scrollPadding: const EdgeInsets.all(10),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(14),
                      labelText: 'User Name',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                    ),
                    validator: (value) {
                      if (value == '') {
                        return 'Fill the name';
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
                      labelText: 'User Phone',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                    ),
                    validator: (value) {
                      if (value == '') {
                        return 'Fill the phone';
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
                      if (value == '' || value!.length < 8) {
                        return 'Fill the password';
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: _obscureText,
                    controller: userConfirmPassword,
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
                      if (value == '' || value != userPassword.text) {
                        return 'Fill the same password';
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Consumer<UserProvider>(
                    builder: (context, value, child) {
                      return value.isLoading
                          ? InkWell(
                              borderRadius: BorderRadius.circular(8),
                              overlayColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.surfaceVariant),
                              splashColor: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8)),
                                child: const CircularProgressIndicator(),
                              ),
                            )
                          : InkWell(
                              borderRadius: BorderRadius.circular(8),
                              overlayColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.surfaceVariant),
                              splashColor: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              onTap: submit,
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
                            );
                    },
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => {
                Navigator.of(context).pushAndRemoveUntil(
                  FadeRightPageRoute(
                    builder: (context) =>  Login(name: '',password: '',),
                  ),
                  (route) => false
                )
              },
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                width: double.infinity,
                alignment: Alignment.bottomRight,
                child: const Text(
                  'Already have an account ? Login',
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
