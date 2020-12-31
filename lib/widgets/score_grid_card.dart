import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:APPLICATION_NAME/models/APPLICATION_NAME_models.dart';
import 'package:APPLICATION_NAME/widgets/player_info.dart';

class ScoreGridCard extends StatelessWidget {
  const ScoreGridCard(
      {this.player, this.game, this.turns, this.index, this.isGameCreator});

  final Player player;
  final Game game;
  final List<Turn> turns;
  final int index;
  final bool isGameCreator;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 6,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PlayerInfo(
                      player: player, game: game, turns: turns, index: index),
                ],
              ),
            ),
            isGameCreator
                ? Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FormBuilderChoiceChip(
                          name: player.userId,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(context,
                                errorText: "score required")
                          ]),
                          options: [
                            FormBuilderFieldOption(value: 0, child: Text('0')),
                            FormBuilderFieldOption(value: 2, child: Text('2')),
                            FormBuilderFieldOption(value: 5, child: Text('5')),
                          ],
                        )
                      ],
                    ),
                  )
                : Container()
          ],
        ));
  }
}
