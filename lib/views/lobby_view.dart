import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:jibe/base/base_view.dart';
import 'package:jibe/utils/util.dart';
import 'package:jibe/utils/view_state.dart';
import 'package:jibe/viewmodels/lobby_viewmodel.dart';
import 'package:flutter_awesome_buttons/flutter_awesome_buttons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jibe/widgets/lobby_player_gridview.dart';
import 'package:share/share.dart';
import 'package:toast/toast.dart';

class Lobby extends StatefulWidget {
  final String gameId;

  const Lobby({Key key, this.gameId}) : super(key: key);

  @override
  _LobbyState createState() {
    return _LobbyState();
  }
}

class _LobbyState extends State<Lobby> {
  @override
  Widget build(BuildContext context) {
    return BaseView<LobbyViewModel>(onModelReady: (model) {
      model.gameId = widget.gameId;
      model.listenToGame();
      model.listenForPlayers();
      model.toasts().listen((String event) {
        Toast.show(event, context,
            gravity: Toast.BOTTOM,
            backgroundColor: Colors.red[600],
            duration: Toast.LENGTH_LONG);
      });
    }, builder: (context, model, build) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Center(child: Text('(${widget.gameId}) Game Lobby'))),
          body: _buildBody(context, model),
        ),
      );
    });
  }

  Widget _buildBody(BuildContext context, LobbyViewModel viewModel) {
    final RenderBox box = context.findRenderObject();

    return Stack(children: <Widget>[
      Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                  child: LobbyPlayerGridView(
                      playerViewModel: viewModel, gameViewModel: viewModel)),
              viewModel.canBegin
                  ? RoundedButtonWithIcon(
                      icon: FontAwesomeIcons.thumbsUp,
                      title: "Begin Game".padLeft(45),
                      buttonColor: Colors.grey[900],
                      onPressed: () {
                        viewModel.startGame();
                      },
                    )
                  : Text(''),
              SizedBox(height: 10),
              RoundedButtonWithIcon(
                icon: FontAwesomeIcons.shareSquare,
                title: "Invite Others".padLeft(45),
                buttonColor: Colors.grey[900],
                onPressed: () async {
                  await Share.share('''Please join my jibe game ${widget.gameId}
                  
                  You can join easily by clicking the following link:
                  
                  https://grateful8.games.com/game/join?gameId=${widget.gameId}
                  ''',
                      subject: widget.gameId,
                      sharePositionOrigin:
                          box.localToGlobal(Offset.zero) & box.size);
                },
              )
            ],
          )),
      viewModel.state == ViewState.Busy ? Utils.progressBar() : Container()
    ]);
  }
}
