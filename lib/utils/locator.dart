import 'package:APPLICATION_NAME/viewmodels/home_viewmodel.dart';
import 'package:APPLICATION_NAME/viewmodels/signin_viewmodel.dart';
import 'package:APPLICATION_NAME/viewmodels/lobby_viewmodel.dart';
import 'package:APPLICATION_NAME/viewmodels/game_viewmodel.dart';
import 'package:APPLICATION_NAME/services/navigation_service.dart';
import 'package:APPLICATION_NAME/services/firebase_service.dart';
import 'package:APPLICATION_NAME/services/authentication_service.dart';
import 'package:APPLICATION_NAME/services/deeplink_service.dart';
import 'package:get_it/get_it.dart';
import 'package:APPLICATION_NAME/viewmodels/winner_viewmodel.dart';

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
