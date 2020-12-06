import 'package:flutter/material.dart';
import 'package:isolation/views/login_view.dart';
import 'package:isolation/views/vote_view.dart';
import 'package:isolation/utils/auth.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Auth _auth = Auth();

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
                CircleAvatar(
                  backgroundImage: NetworkImage(avatarUrl()),
                  radius: 100,
                ),
                SizedBox(height: 40),
                RaisedButton(
                  onPressed: () {
                    signOutGoogle();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) {
                      return LoginScreen();
                    }), ModalRoute.withName('/'));
                  },
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Bye Bye',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return BabyNames();
                    }));
                  },
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Vote on Baby Name',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return BabyNames();
                    }));
                  },
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Start New Game',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
