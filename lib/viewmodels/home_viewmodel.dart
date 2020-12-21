import 'dart:async';
import 'package:jibe/base/base_model.dart';
import 'package:jibe/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jibe/utils/locator.dart';
import 'package:jibe/services/navigation_service.dart';
import 'package:jibe/utils/routeNames.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:jibe/services/deeplink_service.dart';

class HomeViewModel extends BaseModel {
  final AuthenticationService _auth = locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DeepLinkService _deepLinkService = locator<DeepLinkService>();
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

  Future<void> createGame() async {
    User user = _auth.currentUser;
    Future<HttpsCallableResult<dynamic>> callable = FirebaseFunctions.instance
        .httpsCallable('createGame')
        .call(<String, dynamic>{
      "creator": {
        "displayName": user.displayName,
        "avatar": user.photoURL,
        "userId": user.uid
      }
    });

    final results = await callable;
    var data = results.data;
    _navigationService.navigateTo(RouteName.Lobby, arguments: data['gameId']);
  }

  Future<void> joinGame(String gameId) async {
    User user = _auth.currentUser;
    Future<HttpsCallableResult<dynamic>> callable = FirebaseFunctions.instance
        .httpsCallable('joinGame')
        .call(<String, dynamic>{
      "gameId": gameId,
      "displayName": user.displayName,
      "avatar": user.photoURL,
      "userId": user.uid
    });

    final results = await callable;

    print(results.toString());
    var data = results.data;
    _navigationService.navigateTo(RouteName.Lobby, arguments: data['gameId']);
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
