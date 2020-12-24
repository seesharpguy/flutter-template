import 'package:jibe/base/base_model.dart';
import 'package:jibe/models/interface.dart';
import 'package:jibe/utils/locator.dart';
import 'package:jibe/services/firebase_service.dart';
import 'package:jibe/utils/view_state.dart';
import 'package:jibe/models/jibe_models.dart';
import 'package:jibe/services/authentication_service.dart';
import 'package:jibe/services/navigation_service.dart';
import 'package:jibe/utils/routeNames.dart';
import 'package:cloud_functions/cloud_functions.dart';

class LobbyViewModel extends BaseModel implements IHavePlayers, IHaveGame {
  final AuthenticationService _auth = locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FirebaseService _firebaseService = locator<FirebaseService>();

  GameStatus _previousStaus = GameStatus.Unknown;

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

    if (game.status != _previousStaus) {
      _previousStaus = game.status;
      if (game.status == GameStatus.Started) {
        print("starting game from lobby viewmodel");
        _navigationService.navigateTo(RouteName.JibeGame, arguments: _gameId);
      } else {
        notifyListeners();
      }
    }
  }

  bool get canBegin =>
      _players != null &&
      _players.length > 1 &&
      _game != null &&
      _game.createdBy == _auth.currentUser.uid;

  void listenToGame() async {
    state = ViewState.Busy;

    _firebaseService.gameListener(gameId).listen((gameData) {
      if (gameData != null) {
        game = gameData;
      }
    });
    state = ViewState.Idle;
  }

  void listenForPlayers() {
    state = ViewState.Busy;

    _firebaseService.playerListener(_gameId).listen((playerData) {
      List<Player> updatedPlayers = playerData;
      if (updatedPlayers != null) {
        _players = updatedPlayers;
        notifyListeners();
      }
    });
    state = ViewState.Idle;
  }

  void startGame() async {
    try {
      await _firebaseService.startGame(gameId);
    } on FirebaseFunctionsException catch (e) {
      // _toastController.add(e.message);
    } catch (e) {
      // _toastController.add("Error occurred joining game");
    }
  }

  unlisten() {
    if (_firebaseService.gameController().hasListener) {
      _firebaseService.gameController().close();
    }

    if (_firebaseService.playerController().hasListener) {
      _firebaseService.playerController().close();
    }
  }
}
