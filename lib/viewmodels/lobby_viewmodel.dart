import 'package:jibe/base/base_model.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jibe/utils/locator.dart';
import 'package:jibe/services/navigation_service.dart';
import 'package:jibe/services/firestore_service.dart';
import 'package:jibe/utils/routeNames.dart';
import 'package:jibe/utils/auth.dart';
import 'package:jibe/utils/view_state.dart';
import 'package:jibe/models/jibe_models.dart';

class LobbyViewModel extends BaseModel {
  final AuthenticationService _auth = locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();

  List<Player> _players;
  List<Player> get players => _players;

  void listenToPosts() {
    state = ViewState.Busy;

    _firestoreService.gamePlayers("1F4DK2KH").listen((playerData) {
      List<Player> updatedPlayers = playerData;
      if (updatedPlayers != null && updatedPlayers.length > 0) {
        _players = updatedPlayers;
        notifyListeners();
      }

      state = ViewState.Idle;
    });
  }

  Future<void> createGame() async {
    User user = await _auth.currentUserAsync();
    Future<HttpsCallableResult<dynamic>> callable = FirebaseFunctions.instance
        .httpsCallable('createGame')
        .call(<String, dynamic>{
      "creator": {"displayName": user.displayName, "avatar": user.photoURL}
    });

    final results = await callable;
    var data = results.data;
    print(data['gameId']);
    _navigationService.navigateTo(RouteName.Lobby, arguments: data['gameId']);
  }

  clearAllModels() {}
}
