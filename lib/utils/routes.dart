import 'package:flutter/material.dart';
import 'package:social_swap/views/Authentication/login.dart';
import 'package:social_swap/views/Authentication/signup.dart';
import 'package:social_swap/views/Interface/interface.dart';
import 'package:social_swap/views/home/home_page.dart';

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;

  CustomPageRoute({required this.child})
    : super(
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(opacity: animation, child: child),
          );
        },
      );
}

class Routes {
  static const String login = LoginPage.id;
  static const String home = HomePage.id;
  static const String signup = SignUpPage.id;
  static const String interface = InterfacePage.id;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return CustomPageRoute(child: const LoginPage());
      case home:
        return CustomPageRoute(child: const HomePage());
      case signup:
        return CustomPageRoute(child: const SignUpPage());
      case interface:
        return CustomPageRoute(child: const InterfacePage());
      default:
        return CustomPageRoute(
          child: const Scaffold(body: Center(child: Text('Route not found!'))),
        );
    }
  }
}
