import 'package:flutter/material.dart';
import 'package:flutter_todo_app_22apr/pages/login.dart';
import 'package:flutter_todo_app_22apr/pages/register.dart';
import 'package:flutter_todo_app_22apr/pages/todo.dart';

class RouteManager {
  static const String loginPage = '/';
  static const String registerPage = '/registerPage';
  static const String todoPage = '/todoPage';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginPage:
        return MaterialPageRoute(
          builder: (context) => const Login(),
        );
      case registerPage:
        return MaterialPageRoute(
          builder: (context) => const Register(),
        );
      case todoPage:
        return MaterialPageRoute(
          builder: (context) => const TodoPage(),
        );
      default:
        throw const FormatException('Route not found. Please check routing.');
    }
  }
}
