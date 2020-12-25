import 'package:flutter/material.dart';
import 'package:jibe/models/interface.dart';
import 'package:jibe/widgets/score_grid_card.dart';

class ScoreGridForm extends StatelessWidget {
  ScoreGridForm(
      {this.playerViewModel,
      this.gameViewModel,
      this.turnViewmodel,
      this.isGameCreator});
  final IHavePlayers playerViewModel;
  final IHaveGame gameViewModel;
  final IHaveTurns turnViewmodel;
  final bool isGameCreator;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: true,
      crossAxisCount: 2,
      childAspectRatio: 1.8,
      children:
          playerViewModel.players != null && playerViewModel.players.length > 0
              ? List.generate(playerViewModel.players.length, (index) {
                  return ScoreGridCard(
                    player: playerViewModel.players[index],
                    game: gameViewModel.game,
                    turns: turnViewmodel?.turns,
                    index: index,
                    isGameCreator: isGameCreator,
                  );
                })
              : [LinearProgressIndicator()],
    );
  }
}
