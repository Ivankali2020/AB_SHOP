import 'package:flutter/material.dart';

class AppButtonStyle {
  static ButtonStyle defaultButtonStyle(BuildContext context) {
    return ButtonStyle(
       elevation: MaterialStateProperty.all(0),
      padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(vertical: 5, horizontal: 10)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              10.0), // Set your desired border radius here
          side: BorderSide(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer // Set the border color and width here
              ),
        ),
      ),
    );
  }
}
