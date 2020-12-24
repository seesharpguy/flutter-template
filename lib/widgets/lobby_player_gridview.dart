import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:jibe/models/interface.dart';
import 'package:jibe/models/jibe_models.dart';
import 'package:jibe/widgets/header.dart';

class LobbyPlayerGridView extends StatelessWidget {
  LobbyPlayerGridView({this.playerViewModel, this.gameViewModel});
  final IHavePlayers playerViewModel;
  final IHaveGame gameViewModel;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: true,
      crossAxisCount: 2,
      childAspectRatio: 1.4,
      children: playerViewModel.players != null &&
              playerViewModel.players.length > 0
          ? List.generate(playerViewModel.players.length, (index) {
              return getStructuredGridCell(
                  playerViewModel.players[index], gameViewModel.game, index);
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
                    Center(child: new Text(player.displayName))
                  ],
                ),
              )
            ],
          ))
    ]);
  }
}
