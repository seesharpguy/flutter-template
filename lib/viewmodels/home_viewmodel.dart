import 'dart:async';
import 'package:jibe/base/base_model.dart';
import 'package:jibe/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jibe/utils/locator.dart';
import 'package:jibe/services/navigation_service.dart';
import 'package:jibe/utils/routeNames.dart';
import 'package:jibe/services/deeplink_service.dart';
import 'package:jibe/services/firebase_service.dart';
import 'package:flutter/services.dart';

class HomeViewModel extends BaseModel {
  final AuthenticationService _auth = locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DeepLinkService _deepLinkService = locator<DeepLinkService>();
  final FirebaseService _firebaseService = locator<FirebaseService>();

  final StreamController<String> _toastController =
      StreamController<String>.broadcast();

  User _currentUser;

  User get currentUser => _auth.currentUser;
  String get avatarUrl => _currentUser?.photoURL;
  String get displayName => _currentUser?.displayName;

  void init() async {
    _currentUser = _auth.currentUser;
    String gameId = await _deepLinkService.initialGameId();
    if (gameId != null) {
      joinGame(gameId);
    }
    notifyListeners();
  }

  void listenForDeepLinks() {
    _deepLinkService.uniLinks().listen((Uri uri) {
      if (uri.queryParameters.containsKey('gameId')) {
        String gameId = uri.queryParameters['gameId'];
        joinGame(gameId);
      }
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
    });
  }

  Stream<String> toasts() {
    return _toastController.stream;
  }

  Future<void> createGame() async {
    try {
      var result = await _firebaseService.createGame(
          displayName, avatarUrl, _currentUser.uid);
      var data = result.data;
      if (data != null) {
        _navigationService.navigateTo(RouteName.Lobby,
            arguments: data['gameId']);
      }
    } catch (e) {
      _toastController.add("Error occurred creating game");
    }
  }

  Future<void> joinGame(String gameId) async {
    try {
      var result = await _firebaseService.joinGame(
          gameId, displayName, avatarUrl, _currentUser.uid);

      if (result.hasError) {
        _toastController.add(result.data['message']);
      } else {
        if (result.data != null) {
          _navigationService.navigateTo(RouteName.Lobby,
              arguments: result.data['gameId']);
        }
      }
    } catch (e) {
      if (e is PlatformException) {
        _toastController.add("Error occurred joining game");
      }
    }
  }

  void signOutGoogle() async {
    await _auth.logout();
    print("User Sign Out");
  }

  void logout() async {
    signOutGoogle();
    _navigationService.navigateTo(RouteName.Login);
  }

  clearAllModels() {}
}
