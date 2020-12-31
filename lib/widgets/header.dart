import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:APPLICATION_NAME/models/game_models.dart';

class PlayerHeader extends StatelessWidget {
  PlayerHeader({this.player, this.game});
  final Player player;
  final Game game;

  @override
  Widget build(BuildContext context) {
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
