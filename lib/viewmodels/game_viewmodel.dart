import 'package:jibe/base/base_model.dart';
import 'package:jibe/utils/locator.dart';
import 'package:jibe/services/firebase_service.dart';
import 'package:jibe/utils/view_state.dart';
import 'package:jibe/models/jibe_models.dart';
import 'package:jibe/services/authentication_service.dart';
import 'package:jibe/services/navigation_service.dart';
import 'package:jibe/utils/routeNames.dart';

class GameViewModel extends BaseModel {
  final AuthenticationService _auth = locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FirebaseService _firestoreService = locator<FirebaseService>();

  List<Player> _players;
  List<Player> get players => _players;

  String _gameId;
  String get gameId => _gameId;
  set gameId(String gameId) {
    _gameId = gameId;
    notifyListeners();
  }

  Game _game;
  Game get game => _game;
  set game(Game game) {
    _game = game;
    notifyListeners();

    if (game.status == GameStatus.Started) {
      _navigationService.navigateTo(RouteName.Home);
    }
  }

  bool get canBegin =>
      _players != null &&
      _players.length > 1 &&
      _game != null &&
      _game.createdBy == _auth.currentUser.uid;

  void listenToGame() async {
    state = ViewState.Busy;

    _firestoreService.game(gameId).listen((gameData) {
      game = gameData;
    });
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
