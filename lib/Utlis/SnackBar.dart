import 'package:flutter/material.dart';

void SnackBarWidget(BuildContext context, String content) {
  ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.white,
      content: Text(
        content,
        style: TextStyle(color: Colors.black),
      ),
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
          label: 'close',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }),
    ),
  );
}
