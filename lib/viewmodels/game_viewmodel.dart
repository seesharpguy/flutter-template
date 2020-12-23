import 'package:jibe/base/base_model.dart';
import 'package:jibe/utils/locator.dart';
import 'package:jibe/services/firebase_service.dart';
import 'package:jibe/utils/view_state.dart';
import 'package:jibe/models/jibe_models.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:jibe/services/authentication_service.dart';

class GameViewModel extends BaseModel {
  // final NavigationService _navigationService = locator<NavigationService>();
  final AuthenticationService _auth = locator<AuthenticationService>();
  final FirebaseService _firebaseService = locator<FirebaseService>();

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
    safeListenToGame();
    notifyListeners();
  }

  Round _currentRound;
  Round get currentRound => _currentRound;
  set currentRound(Round round) {
    _currentRound = round;
    notifyListeners();
  }

  List<Turn> _turns;
  List<Turn> get turns => _turns;
  set turns(List<Turn> turns) {
    _turns = turns;
    notifyListeners();
  }

  bool get canSubmit =>
      _turns == null ||
      turns.firstWhere((t) => t.playerId == _auth.currentUser.uid,
              orElse: () => null) ==
          null;

  void listenToGame() async {
    state = ViewState.Busy;

    _firebaseService.gameListener(gameId).listen((gameData) {
      if (gameData != null) {
        game = gameData;
      }
    });
    state = ViewState.Idle;
  }

  void listenForPlayers() async {
    state = ViewState.Busy;

    _firebaseService.playerListener(gameId).listen((playerData) {
      List<Player> updatedPlayers = playerData;
      if (updatedPlayers != null) {
        _players = updatedPlayers;
        notifyListeners();
      }
    });
    state = ViewState.Idle;
  }

  void listenToRound() async {
    state = ViewState.Busy;

    _firebaseService
        .roundListener(gameId, game.currentRound.toString())
        .listen((roundData) {
      if (roundData != null) {
        currentRound = roundData;
      }
    });
    state = ViewState.Idle;
  }

  void listenForTurns() async {
    state = ViewState.Busy;

    _firebaseService
        .turnListener(gameId, game.currentRound.toString())
        .listen((turnData) {
      List<Turn> updatedTurns = turnData;
      if (updatedTurns != null) {
        _turns = updatedTurns;
        notifyListeners();
      }
    });
    state = ViewState.Idle;
  }

  Future<void> takeTurn(String answer) async {
    try {
      await _firebaseService.takeTurn(
          gameId, game.currentRound.toString(), answer);
    } on FirebaseFunctionsException catch (e) {
      // _toastController.add(e.message);
    } catch (e) {
      // _toastController.add("Error occurred joining game");
    }
  }

  void safeListenToGame() {
    if (!_firebaseService.roundController().hasListener) {
      print("listening to round");
      listenToRound();
    }

    if (!_firebaseService.turnController().hasListener) {
      print("listening to turns");
      listenForTurns();
    }
  }

  void unlisten() {
    if (_firebaseService.gameController().hasListener) {
      _firebaseService.gameController().close();
    }

    if (_firebaseService.playerController().hasListener) {
      _firebaseService.playerController().close();
    }
  }
}
