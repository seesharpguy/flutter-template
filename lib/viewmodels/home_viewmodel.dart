import 'package:jibe/base/base_model.dart';
import 'package:jibe/utils/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jibe/utils/locator.dart';
import 'package:jibe/services/navigation_service.dart';
import 'package:jibe/utils/routeNames.dart';
import 'package:cloud_functions/cloud_functions.dart';

class HomeViewModel extends BaseModel {
  final AuthenticationService _auth = locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future<void> createGame() async {
    User user = await _auth.currentUserAsync();
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

  clearAllModels() {}
}
