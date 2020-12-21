import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:jibe/base/base_view.dart';
import 'package:jibe/viewmodels/lobby_viewmodel.dart';
import 'package:jibe/models/jibe_models.dart';
import 'package:badges/badges.dart';
import 'package:flutter_awesome_buttons/flutter_awesome_buttons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:share/share.dart';

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
      model.loadGame();
      model.listenForPlayers();
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

    return Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(child: _gridView(context, viewModel)),
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
        ));
  }

  Widget _gridView(BuildContext context, LobbyViewModel viewModel) {
    return GridView.count(
      primary: true,
      crossAxisCount: 2,
      childAspectRatio: 1.4,
      children: viewModel.players != null && viewModel.players.length > 0
          ? List.generate(viewModel.players.length, (index) {
              return getStructuredGridCell(
                  viewModel.players[index], viewModel.game, index);
            })
          : [LinearProgressIndicator()],
    );
  }

  Column getStructuredGridCell(Player player, Game game, int index) {
    Color indexToColor(int index) {
      const Map colors = {
        0: Colors.red,
        1: Colors.blue,
        2: Colors.green,
        3: Colors.yellow,
        4: Colors.purple,
        5: Colors.pink,
        6: Colors.lime,
        7: Colors.brown
      };

      return colors[index];
    }

    return new Column(children: [
      Card(
          elevation: 6,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              _header(player, game),
              AvatarGlow(
                glowColor: indexToColor(index),
                endRadius: 40,
                duration: Duration(milliseconds: 2000),
                repeat: true,
                showTwoGlows: true,
                repeatPauseDuration: Duration(milliseconds: 100),
                child: Material(
                  elevation: 8.0,
                  shape: CircleBorder(),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[100],
                    backgroundImage: player.avatar != null
                        ? NetworkImage(
                            player.avatar,
                          )
                        : null,
                    radius: 30.0,
                  ),
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(child: new Text(player.displayName))
                  ],
                ),
              )
            ],
          ))
    ]);
  }

  Widget _header(Player player, Game game) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: Badge(
        padding: EdgeInsets.all(2),
        badgeColor: Colors.white,
        showBadge: player != null && game != null
            ? player.userId == game.createdBy
            : false,
        badgeContent: Text(
          '🥇',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        child: Text('Player ${player.playerNumber}'),
        position: BadgePosition.bottomEnd(bottom: -2, end: -5),
      ),
    );
  }
}

class Record {
  final String displayName;
  final String avatar;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['displayName'] != null),
        assert(map['avatar'] != null),
        displayName = map['displayName'],
        avatar = map['avatar'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "Record<$displayName:$avatar>";
}
