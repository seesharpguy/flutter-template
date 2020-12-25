import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:jibe/models/jibe_models.dart';

class PlayerInfo extends StatelessWidget {
  const PlayerInfo({this.player, this.game, this.turns, this.index});

  final Player player;
  final Game game;
  final List<Turn> turns;
  final int index;

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

  String getWordForPlayer(List<Turn> turns, Player player) {
    if (turns == null || player == null) {
      return "";
    } else {
      var matchingTurn = turns.firstWhere(
          (turn) => turn.playerId == player.userId,
          orElse: () => null);

      return matchingTurn != null ? matchingTurn.answer : "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      verticalDirection: VerticalDirection.down,
      children: <Widget>[
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
          padding: EdgeInsets.only(left: 1.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(child: new Text(getWordForPlayer(turns, player)))
            ],
          ),
        )
      ],
    );
  }
}
