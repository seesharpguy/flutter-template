import 'package:auto_size_text/auto_size_text.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:APPLICATION_NAME/models/game_models.dart';

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
      crossAxisAlignment: CrossAxisAlignment.start,
      verticalDirection: VerticalDirection.down,
      children: <Widget>[
        AvatarGlow(
          glowColor: indexToColor(index),
          endRadius: 30,
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
              radius: 23.0,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 6),
          child: AutoSizeText(
            getWordForPlayer(turns, player),
            maxLines: 1,
            style: TextStyle(fontSize: 20),
          ),
        )
      ],
    );
  }
}
