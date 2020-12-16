import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState
        .pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false);
  }

  void goBack() {
    return navigatorKey.currentState.pop();
  }
}
