import 'package:jibe/models/home_model.dart';
import 'package:jibe/models/signin_model.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setLocator() {
  locator.registerLazySingleton(() => SignInViewModel());
  locator.registerLazySingleton(() => HomeViewModel());
}
