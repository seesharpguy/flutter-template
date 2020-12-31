import 'package:APPLICATION_NAME/base/base_model.dart';
import 'package:APPLICATION_NAME/models/interface.dart';
import 'package:APPLICATION_NAME/services/navigation_service.dart';
import 'package:APPLICATION_NAME/utils/locator.dart';
import 'package:APPLICATION_NAME/services/firebase_service.dart';
import 'package:APPLICATION_NAME/models/APPLICATION_NAME_models.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:APPLICATION_NAME/services/authentication_service.dart';
import 'dart:async';

import 'package:APPLICATION_NAME/utils/routeNames.dart';
import 'package:APPLICATION_NAME/utils/view_state.dart';

class GameViewModel extends BaseModel
    implements IHaveGame, IHavePlayers, IHaveTurns {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthenticationService _auth = locator<AuthenticationService>();
  final FirebaseService _firebaseService = locator<FirebaseService>();

  final StreamController<RoundStatus> _roundController =
      StreamController<RoundStatus>.broadcast();

  final StreamController<String> _toastController =
      StreamController<String>.broadcast();

  GameStatus _previousStaus = GameStatus.Unknown;

  Stream<String> toasts() {
    return _toastController.stream;
  }

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
    print("got game");
    if (game.status != _previousStaus) {
      _previousStaus = game.status;
      print("${game.status}");
      if (game.status == GameStatus.Completed) {
        _navigationService.navigateTo(RouteName.Winner, arguments: _gameId);
      } else {
        notifyListeners();
      }
    }
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

  bool get isGameCreator =>
      game != null && game.createdBy == _auth.currentUser.uid;

  bool get canSubmit =>
      _turns == null ||
      turns.firstWhere((t) => t.playerId == _auth.currentUser.uid,
              orElse: () => null) ==
          null;

  void listenToGame() {
    _firebaseService.gameListener(gameId).listen((gameData) {
      if (gameData != null) {
        game = gameData;
        // listenToRound();
      }
    });
  }

  // void listenForPlayers() {
  //   _firebaseService.playerListener(gameId).listen((playerData) {
  //     List<Player> updatedPlayers = playerData;
  //     if (updatedPlayers != null) {
  //       _players = updatedPlayers;
  //       notifyListeners();
  //     }
  //   });
  // }

  // void listenToRound() {
  //   _firebaseService
  //       .roundListener(gameId, game.currentRound.toString())
  //       .listen((roundData) {
  //     if (roundData != null) {
  //       RoundStatus prevStatus = currentRound != null
  //           ? currentRound.status ?? RoundStatus.Unknown
  //           : RoundStatus.Unknown;

  //       currentRound = roundData;
  //       listenForTurns();

  //       if (roundData.status != prevStatus &&
  //           prevStatus != RoundStatus.Unknown) {
  //         turns = null;
  //         _roundController.add(roundData.status);
  //       }
  //     }
  //   });
  // }

  Stream<RoundStatus> roundStatus() {
    return _roundController.stream;
  }

  // void listenForTurns() {
  //   print("listening for turns for round ${game.currentRound}");
  //   _firebaseService
  //       .turnListener(gameId, game.currentRound.toString())
  //       .listen((turnData) {
  //     List<Turn> updatedTurns = turnData;
  //     print("got turns");
  //     turns = updatedTurns;
  //   });
  // }

  Future<void> takeTurn(String answer) async {
    try {
      state = ViewState.Busy;
      await _firebaseService.takeTurn(
          gameId, game.currentRound.toString(), answer);
    } on FirebaseFunctionsException catch (e) {
      _toastController.add(e.message);
    } catch (e) {
      _toastController.add("Error occurred taking turn");
    } finally {
      state = ViewState.Idle;
    }
  }

  Future<void> scoreTurn(Map<String, dynamic> answers) async {
    try {
      state = ViewState.Busy;
      await _firebaseService.scoreTurn(
          gameId, game.currentRound.toString(), answers);
    } on FirebaseFunctionsException catch (e) {
      _toastController.add(e.message);
    } catch (e) {
      _toastController.add("Error occurred scoring round");
    } finally {
      state = ViewState.Idle;
    }
  }
}
