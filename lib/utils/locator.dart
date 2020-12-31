import 'package:jibe/viewmodels/home_viewmodel.dart';
import 'package:jibe/viewmodels/signin_viewmodel.dart';
import 'package:jibe/viewmodels/lobby_viewmodel.dart';
import 'package:jibe/viewmodels/game_viewmodel.dart';
import 'package:jibe/services/navigation_service.dart';
import 'package:jibe/services/firebase_service.dart';
import 'package:jibe/services/authentication_service.dart';
import 'package:jibe/services/deeplink_service.dart';
import 'package:get_it/get_it.dart';
import 'package:jibe/viewmodels/winner_viewmodel.dart';

GetIt locator = GetIt.instance;

void setLocator() {
  locator.registerLazySingleton(() => SignInViewModel());
  locator.registerLazySingleton(() => HomeViewModel());
  locator.registerLazySingleton(() => LobbyViewModel());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => FirebaseService());
  locator.registerLazySingleton(() => DeepLinkService());
  locator.registerLazySingleton(() => GameViewModel());
  locator.registerLazySingleton(() => WinnerViewModel());
}
