import 'package:jibe/base/base_model.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jibe/utils/locator.dart';
import 'package:jibe/services/navigation_service.dart';
import 'package:jibe/services/firestore_service.dart';
import 'package:jibe/utils/routeNames.dart';
import 'package:jibe/utils/auth.dart';
import 'package:jibe/utils/view_state.dart';
import 'package:jibe/models/jibe_models.dart';

class LobbyViewModel extends BaseModel {
  final AuthenticationService _auth = locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();

  List<Player> _players;
  List<Player> get players => _players;

  String _gameId;
  String get gameId => _gameId;
  set gameId(String gameId) {
    _gameId = gameId;
    print('gameId set in lobby viewmodel with id: $gameId');
    notifyListeners();
  }

  Game _game;
  Game get game => _game;
  set game(Game game) {
    _game = game;
    print(game.gameId);
    notifyListeners();
  }

  void loadGame() async {
    game = await _firestoreService.getGame(_gameId);
  }

  void listenForPlayers() {
    state = ViewState.Busy;

    _firestoreService.gamePlayers(_gameId).listen((playerData) {
      List<Player> updatedPlayers = playerData;
      if (updatedPlayers != null) {
        _players = updatedPlayers;
        notifyListeners();
      }

      state = ViewState.Idle;
    });
  }

  clearAllModels() {}
}
