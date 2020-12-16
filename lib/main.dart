import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:jibe/models/home_model.dart';
import 'package:jibe/models/signin_model.dart';
import 'package:jibe/utils/navigation_service.dart';
import 'package:get_it/get_it.dart';
import 'package:jibe/utils/locator.dart';
import 'package:jibe/utils/prefer.dart';
import 'package:jibe/utils/routes.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

GetIt locator = GetIt.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (kDebugMode) {
    print('Running in debug mode so pointing to local emulator');

    if (Platform.isAndroid) {
      FirebaseFirestore.instance.settings =
          Settings(host: '10.0.2.2:8083', sslEnabled: false);

      FirebaseFunctions.instance
          .useFunctionsEmulator(origin: 'http://10.0.2.2:5001');
    } else {
      FirebaseFirestore.instance.settings =
          Settings(host: '127.0.0.1:8083', sslEnabled: false);

      FirebaseFunctions.instance
          .useFunctionsEmulator(origin: 'http://localhost:5001');
    }
  }

  Prefs.init();
  setLocator();
  runApp(MultiProvider(
    child: JibeApp(),
    providers: [
      ChangeNotifierProvider<HomeViewModel>(
        create: (_) => HomeViewModel(),
      ),
    ],
  ));
}

class JibeApp extends StatefulWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  _JibeAppState createState() => _JibeAppState();
}

class _JibeAppState extends State<JibeApp> {
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
