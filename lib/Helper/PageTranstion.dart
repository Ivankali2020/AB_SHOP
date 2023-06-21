import 'package:flutter/material.dart';

class FadeRightPageRoute<T> extends PageRouteBuilder<T> {
  final WidgetBuilder builder;

  FadeRightPageRoute({required this.builder,Object? arguments})
      : super(
          settings: RouteSettings(arguments: arguments),
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
            return builder(context);
          },
          transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        );
}
