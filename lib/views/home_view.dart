import 'package:flutter/material.dart';
import 'package:jibe/views/login_view.dart';
import 'package:jibe/views/lobby_view.dart';
import 'package:jibe/utils/auth.dart';
import 'package:jibe/base/base_view.dart';
import 'package:jibe/viewmodels/home_viewmodel.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_awesome_buttons/flutter_awesome_buttons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthenticationService _auth = AuthenticationService();

  void signOutGoogle() async {
    await _auth.logout();
    print("User Sign Out");
  }

  String avatarUrl() {
    return _auth.getAvatarUrl();
  }

  String displayName() {
    return _auth.displayName();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
        onModelReady: (model) {},
        builder: (context, model, build) {
          return SafeArea(
            child: Scaffold(
              body: Container(
                child: Padding(
                  padding: const EdgeInsets.all(48.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Center(
                        child: Text(
                          'Hello ${displayName()}',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                      ),
                      SizedBox(height: 40),
                      AvatarGlow(
                        glowColor: Colors.grey[800],
                        endRadius: 150.0,
                        duration: Duration(milliseconds: 2000),
                        repeat: true,
                        showTwoGlows: true,
                        repeatPauseDuration: Duration(milliseconds: 100),
                        child: Material(
                          elevation: 8.0,
                          shape: CircleBorder(),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey[100],
                            backgroundImage: NetworkImage(
                              avatarUrl(),
                            ),
                            radius: 60.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      RoundedButtonWithIcon(
                        icon: FontAwesomeIcons.playCircle,
                        title: "               Start New Game",
                        buttonColor: Colors.grey[900],
                        onPressed: () {
                          model.createGame();
                        },
                      ),
                      SizedBox(height: 10),
                      RoundedButtonWithIcon(
                        icon: FontAwesomeIcons.userPlus,
                        title: "             Join Existing Game",
                        buttonColor: Colors.grey[900],
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return Lobby();
                          }));
                        },
                      ),
                      SizedBox(height: 10),
                      RoundedButtonWithIcon(
                        icon: FontAwesomeIcons.signOutAlt,
                        title: "                       Log Out",
                        buttonColor: Colors.grey[900],
                        onPressed: () {
                          signOutGoogle();
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) {
                            return LoginScreen();
                          }), ModalRoute.withName('/'));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
