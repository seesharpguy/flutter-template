import 'dart:async';
import 'package:flutter/material.dart';
import 'package:isolation/models/signin_model.dart';
import 'package:isolation/utils/deviceSize.dart';
import 'package:isolation/utils/auth.dart';
import 'package:isolation/views/login_view.dart';
import 'package:isolation/views/home_view.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  @override
  VideoState createState() => VideoState();
}

DeviceSize deviceSize;

class VideoState extends State<Splash> with SingleTickerProviderStateMixin {
  var _visible = true;

  AnimationController animationController;
  Animation<double> animation;

  final Auth _auth = Auth();

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    final bool isLogged = await _auth.isLoggedIn();

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => isLogged ? HomeScreen() : LoginScreen()));
  }

  @override
  void initState() {
    super.initState();

    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    deviceSize = DeviceSize(
        size: MediaQuery.of(context).size,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        aspectRatio: MediaQuery.of(context).size.aspectRatio);
    return ChangeNotifierProvider<SignInViewModel>(
        create: (_) => SignInViewModel(),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(bottom: 30.0),
                      child: new Image.asset(
                        'assets/powered_by_dm.png',
                        height: 100.0,
                        fit: BoxFit.scaleDown,
                      ))
                ],
              ),
              new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Image.asset(
                    'assets/devs.jpg',
                    width: animation.value * 250,
                    height: animation.value * 250,
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
