import 'package:jibe/base/base_model.dart';
import 'package:jibe/utils/locator.dart';
import 'package:jibe/services/firebase_service.dart';
import 'package:jibe/utils/view_state.dart';
import 'package:jibe/models/jibe_models.dart';
import 'package:jibe/services/authentication_service.dart';

class LobbyViewModel extends BaseModel {
  final AuthenticationService _auth = locator<AuthenticationService>();
  // final NavigationService _navigationService = locator<NavigationService>();
  final FirebaseService _firestoreService = locator<FirebaseService>();

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

  bool get canBegin =>
      _players != null &&
      _players.length > 1 &&
      _game != null &&
      _game.createdBy == _auth.currentUser.uid;

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

  void startGame() {
    print('game started');
  }

  clearAllModels() {}
}
