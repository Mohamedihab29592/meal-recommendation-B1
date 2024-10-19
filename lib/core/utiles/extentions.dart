 import 'package:flutter/material.dart';

extension NavigationExtension on BuildContext {
  // Navigate to a new route
  void navigateTo(String routeName, {Object? arguments}) {
    Navigator.pushNamed(this, routeName, arguments: arguments);
  }

  // Replace current route with a new one
  void replaceWith(String routeName, {Object? arguments}) {
    Navigator.pushReplacementNamed(this, routeName, arguments: arguments);
  }

  // Pop the current route
  void goBack<T extends Object?>([T? result]) {
    Navigator.pop(this, result);
  }

  // Push a new route and remove all previous ones
  void navigateAndRemove(String routeName, {Object? arguments}) {
    Navigator.pushNamedAndRemoveUntil(this, routeName, (route) => false, arguments: arguments);
  }
}