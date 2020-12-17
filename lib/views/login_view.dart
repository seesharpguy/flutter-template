import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jibe/viewmodels/signin_viewmodel.dart';
import 'package:jibe/base/base_view.dart';
import 'package:jibe/splash.dart';
import 'package:jibe/utils/util.dart';
import 'package:jibe/utils/view_state.dart';
import 'package:flutter_awesome_buttons/flutter_awesome_buttons.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _userLoginFormKey = GlobalKey();

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
                          Container(
                              height: deviceSize.height / 2.4,
                              width: deviceSize.width / 3),
                          Container(
                            child: Form(
                              key: _userLoginFormKey,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 5.0, bottom: 15, left: 10, right: 10),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
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
                                          padding: const EdgeInsets.only(
                                              top: 15.0,
                                              right: 14,
                                              left: 14,
                                              bottom: 8),
                                          child:
                                              GoogleButton(onPressed: () async {
                                            model.loginWithGoogle();
                                          })),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                    ],
                                  ),
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
