import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:APPLICATION_NAME/viewmodels/signin_viewmodel.dart';
import 'package:APPLICATION_NAME/base/base_view.dart';
import 'package:APPLICATION_NAME/splash.dart';
import 'package:APPLICATION_NAME/utils/util.dart';
import 'package:APPLICATION_NAME/utils/view_state.dart';
import 'package:flutter_awesome_buttons/flutter_awesome_buttons.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // GlobalKey<FormState> _userLoginFormKey = GlobalKey();

  bool isSignIn = false;
  bool google = false;

  @override
  Widget build(BuildContext context) {
    return BaseView<SignInViewModel>(
        onModelReady: (model) {},
        builder: (context, model, build) {
          return WillPopScope(
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Color(0xFFE6E6E6),
                body: Stack(
                  children: <Widget>[
                    Container(
                      height: 400,
                      width: 430,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/jibe_splash.jpg'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: deviceSize.height / 2.4),
                          Container(
                            width: deviceSize.width,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 5.0, bottom: 15, left: 10, right: 10),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                        "jibe",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 25),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: SignInWithGoogle(
                                          buttonColor: Colors.grey[900],
                                          onPressed: () async {
                                            model.loginWithGoogle();
                                          }),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: RoundedButtonWithIcon(
                                        icon: FontAwesomeIcons.userSecret,
                                        title: "Play Without Login".padLeft(35),
                                        buttonColor: Colors.grey[900],
                                        onPressed: () {
                                          model.loginAnonomously();
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    model.state == ViewState.Busy
                        ? Utils.progressBar()
                        : Container(),
                  ],
                ),
              ),
            ),
            onWillPop: () async {
              model.clearAllModels();
              return false;
            },
          );
        });
  }
}
