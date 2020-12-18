import 'package:jibe/viewmodels/home_viewmodel.dart';
import 'package:jibe/viewmodels/signin_viewmodel.dart';
import 'package:jibe/viewmodels/lobby_viewmodel.dart';
import 'package:jibe/services/navigation_service.dart';
import 'package:jibe/services/firestore_service.dart';
import 'package:jibe/services/authentication_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setLocator() {
  locator.registerLazySingleton(() => SignInViewModel());
  locator.registerLazySingleton(() => HomeViewModel());
  locator.registerLazySingleton(() => LobbyViewModel());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => FirestoreService());
}
