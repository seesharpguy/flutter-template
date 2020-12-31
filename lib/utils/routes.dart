import 'package:flutter/material.dart';
import 'package:jibe/views/home_view.dart';
import 'package:jibe/views/login_view.dart';
import 'package:jibe/views/lobby_view.dart';
import 'package:jibe/splash.dart';
import 'package:jibe/utils/routeNames.dart';
import 'package:jibe/views/game_view.dart';
import 'package:jibe/views/winner_view.dart';

class Routes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => Splash());
      case RouteName.Login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case RouteName.Home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case RouteName.Lobby:
        var gameId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => Lobby(gameId: gameId));
      case RouteName.JibeGame:
        var gameId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => JibeGame(gameId: gameId));
      case RouteName.Winner:
        var gameId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => WinnerScreen(gameId: gameId));
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
//                  Image.asset('assets/images/error.jpg'),
                  Text(
                    "${settings.name} does not exists!",
                    style: TextStyle(fontSize: 24.0),
                  )
                ],
              ),
            ),
          ),
        );
    }
  }
}
