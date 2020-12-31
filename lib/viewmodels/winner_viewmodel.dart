import 'dart:async';
import 'package:APPLICATION_NAME/base/base_model.dart';
import 'package:APPLICATION_NAME/models/APPLICATION_NAME_models.dart';
import 'package:APPLICATION_NAME/utils/locator.dart';
import 'package:APPLICATION_NAME/services/navigation_service.dart';
import 'package:APPLICATION_NAME/utils/routeNames.dart';
import 'package:APPLICATION_NAME/services/firebase_service.dart';

class WinnerViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final FirebaseService _firebaseService = locator<FirebaseService>();

  final StreamController<String> _toastController =
      StreamController<String>.broadcast();

  Game _game;
  Game get game => _game;
  set game(Game game) {
    _game = game;

    notifyListeners();
  }

  Stream<String> toasts() {
    return _toastController.stream;
  }

  void listenToGame(String gameId) async {
    _firebaseService.gameListener(gameId).listen((gameData) {
      if (gameData != null) {
        game = gameData;
      }
    });
  }

  Future<void> goHome() async {
    try {
      _navigationService.navigateTo(RouteName.Home);
    } catch (e) {
      _toastController.add("Error occurred going to home screen");
    }
  }

  clearAllModels() {}
}
