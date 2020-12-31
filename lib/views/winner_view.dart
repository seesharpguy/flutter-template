import 'package:flutter/material.dart';
import 'package:jibe/base/base_view.dart';
import 'package:jibe/utils/util.dart';
import 'package:jibe/utils/view_state.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_awesome_buttons/flutter_awesome_buttons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jibe/viewmodels/winner_viewmodel.dart';
import 'package:toast/toast.dart';

class WinnerScreen extends StatefulWidget {
  final String gameId;

  const WinnerScreen({Key key, this.gameId}) : super(key: key);
  @override
  _WinnerScreenState createState() => _WinnerScreenState();
}

class _WinnerScreenState extends State<WinnerScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseView<WinnerViewModel>(onModelReady: (model) {
      model.listenToGame(widget.gameId);
      model.toasts().listen((String event) {
        Toast.show(event, context,
            gravity: Toast.BOTTOM,
            backgroundColor: Colors.red[600],
            duration: Toast.LENGTH_LONG);
      });
    }, builder: (context, model, build) {
      return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.all(48.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                      child: Text(
                        'Winner!',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                    ),
                    Center(
                      child: Text(
                        '${model.game.winnerDisplayName}',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                    ),
                    Expanded(
                      child: AvatarGlow(
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
                            backgroundImage: model.game?.winnerAvatar != null
                                ? NetworkImage(
                                    model.game.winnerAvatar,
                                  )
                                : null,
                            radius: 60.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    RoundedButtonWithIcon(
                      icon: FontAwesomeIcons.playCircle,
                      title: "Start Over".padLeft(30),
                      buttonColor: Colors.grey[900],
                      onPressed: () {
                        model.goHome();
                      },
                    )
                  ],
                ),
              ),
            ),
            model.state == ViewState.Busy ? Utils.progressBar() : Container()
          ]),
        ),
      );
    });
  }
}
