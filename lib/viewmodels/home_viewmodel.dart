import 'dart:async';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:jibe/base/base_model.dart';
import 'package:jibe/models/user.dart';
import 'package:jibe/services/authentication_service.dart';
import 'package:jibe/utils/locator.dart';
import 'package:jibe/services/navigation_service.dart';
import 'package:jibe/utils/routeNames.dart';
import 'package:jibe/services/deeplink_service.dart';
import 'package:jibe/services/firebase_service.dart';
import 'package:jibe/utils/view_state.dart';

class HomeViewModel extends BaseModel {
  final AuthenticationService _auth = locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DeepLinkService _deepLinkService = locator<DeepLinkService>();
  final FirebaseService _firebaseService = locator<FirebaseService>();

  final StreamController<String> _toastController =
      StreamController<String>.broadcast();

  JibeUser _currentUser;

  JibeUser get currentUser => _auth.currentUser;
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
      state = ViewState.Busy;
      var result = await _firebaseService.createGame(
          _currentUser.displayName, _currentUser.photoURL);
      var data = result.data;
      if (data != null) {
        _navigationService.navigateTo(RouteName.Lobby,
            arguments: data['gameId']);
      }
    } on FirebaseFunctionsException catch (e) {
      _toastController.add(e.message);
    } catch (e) {
      _toastController.add("Error occurred creating game");
    } finally {
      state = ViewState.Idle;
    }
  }

  Future<void> joinGame(String gameId) async {
    try {
      var result = await _firebaseService.joinGame(gameId);

      _navigationService.navigateTo(RouteName.Lobby,
          arguments: result.data['gameId']);
    } on FirebaseFunctionsException catch (e) {
      _toastController.add(e.message);
    } catch (e) {
      _toastController.add("Error occurred joining game");
    }
  }

  void signOutGoogle() async {
    await _auth.logout();
  }

  void logout() async {
    signOutGoogle();
    _navigationService.navigateTo(RouteName.Login);
  }

  clearAllModels() {}
}
