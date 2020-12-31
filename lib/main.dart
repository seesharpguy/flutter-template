import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:APPLICATION_NAME/viewmodels/home_viewmodel.dart';
import 'package:APPLICATION_NAME/viewmodels/signin_viewmodel.dart';
import 'package:APPLICATION_NAME/services/navigation_service.dart';
import 'package:get_it/get_it.dart';
import 'package:APPLICATION_NAME/utils/locator.dart';
import 'package:APPLICATION_NAME/utils/prefer.dart';
import 'package:APPLICATION_NAME/utils/routes.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform, exit;

GetIt locator = GetIt.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (kDebugMode) {
    print(
        'Running in debug mode on ${Platform.isAndroid} so pointing to local emulator');
    if (Platform.isAndroid) {
      FirebaseFirestore.instance.settings =
          Settings(host: '10.0.2.2:8082', sslEnabled: false);

      FirebaseFunctions.instance
          .useFunctionsEmulator(origin: 'http://10.0.2.2:5001');
    } else {
      FirebaseFirestore.instance.settings =
          Settings(host: '127.0.0.1:8082', sslEnabled: false);

      FirebaseFunctions.instance
          .useFunctionsEmulator(origin: 'http://localhost:5001');
    }
  }

  Prefs.init();
  setLocator();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode) exit(1);
  };

  runApp(MultiProvider(
    child: Grateful8App(),
    providers: [
      ChangeNotifierProvider<HomeViewModel>(
        create: (_) => HomeViewModel(),
      ),
    ],
  ));
}

class Grateful8App extends StatefulWidget {
  @override
  _Grateful8AppState createState() => _Grateful8AppState();
}

class _Grateful8AppState extends State<Grateful8App> {
  Locale locale;
  bool localeLoaded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.grey[400],
//        statusBarColor: Styles.blueColor,
        statusBarIconBrightness:
            Brightness.light //or set color with: Color(0xFF0000FF)
        ));
    return ChangeNotifierProvider<SignInViewModel>(
      create: (_) => SignInViewModel(),
      child: Center(
        child: MaterialApp(
          initialRoute: '/',
          navigatorKey: locator<NavigationService>().navigatorKey,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: Routes.onGenerateRoute,
          theme: ThemeData(
            primaryColor: Colors.black,
            fontFamily: 'FA',
          ),
        ),
      ),
    );
  }
}
