import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:APPLICATION_NAME/base/base_model.dart';
import 'package:APPLICATION_NAME/models/interface.dart';
import 'package:APPLICATION_NAME/utils/locator.dart';
import 'package:APPLICATION_NAME/services/firebase_service.dart';
import 'package:APPLICATION_NAME/utils/view_state.dart';
import 'package:APPLICATION_NAME/models/game_models.dart';
import 'package:APPLICATION_NAME/services/authentication_service.dart';
import 'package:APPLICATION_NAME/services/navigation_service.dart';
import 'package:APPLICATION_NAME/utils/routeNames.dart';
import 'package:cloud_functions/cloud_functions.dart';

class LobbyViewModel extends BaseModel implements IHavePlayers, IHaveGame {
  final AuthenticationService _auth = locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FirebaseService _firebaseService = locator<FirebaseService>();
  final StreamController<String> _toastController =
      StreamController<String>.broadcast();

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
        _navigationService.navigateTo(RouteName.Game, arguments: _gameId);
      } else {
        notifyListeners();
      }
    }
  }

  Stream<String> toasts() {
    return _toastController.stream;
  }

  bool get canBegin =>
      _players != null &&
      _players.length > (kDebugMode ? 1 : 2) &&
      _game != null &&
      _game.createdBy == _auth.currentUser.uid;

  void listenToGame() async {
    _firebaseService.gameListener(gameId).listen((gameData) {
      if (gameData != null) {
        game = gameData;
      }
    });
  }

  void startGame() async {
    try {
      state = ViewState.Busy;
      await _firebaseService.startGame(gameId);
    } on FirebaseFunctionsException catch (e) {
      _toastController.add(e.message);
    } catch (e) {
      _toastController.add("Error occurred starting game");
    } finally {
      state = ViewState.Idle;
    }
  }
}
