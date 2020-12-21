import 'package:flutter/material.dart';
import 'package:jibe/base/base_view.dart';
import 'package:jibe/viewmodels/home_viewmodel.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_awesome_buttons/flutter_awesome_buttons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(onModelReady: (model) {
      model.init();
      model.listenForDeepLinks();
    }, builder: (context, model, build) {
      return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            child: Padding(
              padding: const EdgeInsets.all(48.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                    child: Text(
                      'Hello ${model.displayName}',
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
                        backgroundImage: model.avatarUrl != null
                            ? NetworkImage(
                                model.avatarUrl,
                              )
                            : null,
                        radius: 60.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  RoundedButtonWithIcon(
                    icon: FontAwesomeIcons.playCircle,
                    title: "Start New Game".padLeft(35),
                    buttonColor: Colors.grey[900],
                    onPressed: () {
                      model.createGame();
                    },
                  ),
                  SizedBox(height: 10),
                  RoundedButtonWithIcon(
                    icon: FontAwesomeIcons.userPlus,
                    title: "Join Existing Game".padLeft(35),
                    buttonColor: Colors.grey[900],
                    onPressed: () {
                      showDialog(
                          useSafeArea: true,
                          child: new Dialog(
                              clipBehavior: Clip.hardEdge,
                              child: _gameIdForm(context, model)),
                          context: context);
                    },
                  ),
                  SizedBox(height: 10),
                  RoundedButtonWithIcon(
                    icon: FontAwesomeIcons.signOutAlt,
                    title: "Log Out".padLeft(35),
                    buttonColor: Colors.grey[900],
                    onPressed: () {
                      model.logout();
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

  Widget _gameIdForm(BuildContext context, HomeViewModel model) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding: EdgeInsets.all(10),
              child: FormBuilder(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: FormBuilderTextField(
                  name: 'gameId',
                  decoration: InputDecoration(
                    labelText: 'Enter jibe game id.',
                  ),
                  // valueTransformer: (text) => num.tryParse(text),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                    FormBuilderValidators.minLength(context, 8),
                    FormBuilderValidators.maxLength(context, 8)
                  ]),
                  keyboardType: TextInputType.text,
                ),
              )),
          SizedBox(height: 10),
          FloatingIconButton(
            icon: FontAwesomeIcons.handPointRight,
            buttonColor: Colors.grey[900],
            onPressed: () {
              _formKey.currentState.save();
              if (_formKey.currentState.validate()) {
                model.joinGame(_formKey.currentState.value['gameId']);
              } else {
                print("validation failed");
              }
            },
          ),
        ]);
  }
}
