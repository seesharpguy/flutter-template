import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:jibe/models/jibe_models.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:jibe/viewmodels/game_viewmodel.dart';

class PlayerListView extends StatelessWidget {
  PlayerListView({this.viewModel});
  final GameViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListView(
        scrollDirection: Axis.horizontal,
        children: viewModel.players != null && viewModel.players.length > 0
            ? List.generate(viewModel.players.length, (index) {
                return getPlayerListItem(
                    viewModel.players[index], viewModel?.turns, index);
              })
            : [Container(width: 45, child: CircularProgressIndicator())]);
  }

  Container getPlayerListItem(Player player, List<Turn> turns, int index) {
    Color statusColor(Player player, List<Turn> turns) {
      if (turns != null && player != null) {
        var turn = turns.firstWhere((t) => t.playerId == player.userId,
            orElse: () => null);

        return turn == null ? Colors.white : Colors.green[900];
      } else {
        return Colors.grey[100];
      }
    }

    return Container(
      width: 45.0,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          AvatarGlow(
            glowColor: statusColor(player, turns),
            endRadius: 28,
            duration: Duration(milliseconds: 1000),
            repeat: true,
            showTwoGlows: true,
            repeatPauseDuration: Duration(milliseconds: 100),
            child: Material(
              elevation: 8.0,
              shape: CircleBorder(side: BorderSide.none),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: player.avatar != null
                    ? NetworkImage(
                        player.avatar,
                      )
                    : null,
                radius: 15.0,
              ),
            ),
          ),
          new Padding(
            padding: EdgeInsets.all(1),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(child: new Text(player.score.toString()))
              ],
            ),
          )
        ],
      ),
    );
  }
}
