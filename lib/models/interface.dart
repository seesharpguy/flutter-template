import 'jibe_models.dart';

abstract class IHavePlayers {
  List<Player> get players;
}

abstract class IHaveGame {
  Game get game;
}
