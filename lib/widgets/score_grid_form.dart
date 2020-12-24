import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:jibe/models/interface.dart';
import 'package:jibe/models/jibe_models.dart';
import 'package:jibe/widgets/header.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ScoreGridForm extends StatelessWidget {
  ScoreGridForm({this.playerViewModel, this.gameViewModel, this.turnViewmodel});
  final IHavePlayers playerViewModel;
  final IHaveGame gameViewModel;
  final IHaveTurns turnViewmodel;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: true,
      crossAxisCount: 2,
      childAspectRatio: 1.4,
      children:
          playerViewModel.players != null && playerViewModel.players.length > 0
              ? List.generate(playerViewModel.players.length, (index) {
                  return getStructuredGridCell(playerViewModel.players[index],
                      gameViewModel.game, turnViewmodel?.turns, index);
                })
              : [LinearProgressIndicator()],
    );
  }

  Column getStructuredGridCell(
      Player player, Game game, List<Turn> turns, int index) {
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
      if (turns == null) {
        return "";
      }
      return turns
              .firstWhere((turn) => turn.playerId == player.userId,
                  orElse: null)
              .answer ??
          "";
    }

    return new Column(children: [
      Card(
          elevation: 6,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              PlayerHeader(player: player, game: game),
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
                    Center(child: new Text(getWordForPlayer(turns, player)))
                  ],
                ),
              )
            ],
          ))
    ]);
  }
}
