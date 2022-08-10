import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_note_one/pages/detail_page.dart';
import 'package:firebase_note_one/pages/home_page.dart';
import 'package:firebase_note_one/pages/sign_in_page.dart';
import 'package:firebase_note_one/pages/sign_up_page.dart';
import 'package:firebase_note_one/services/auth_service.dart';
import 'package:firebase_note_one/services/db_service.dart';
import 'package:flutter/material.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  await runZonedGuarded(() async {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    runApp(const MyFirebaseApp());
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class MyFirebaseApp extends StatelessWidget {
  const MyFirebaseApp({Key? key}) : super(key: key);
  static final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  Widget _startPage() {
    return StreamBuilder<User?>(
      stream: AuthService.auth.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          DBService.saveUserId(snapshot.data!.uid);
          return const HomePage();
        } else {
          DBService.removeUserId();
          return const SignInPage();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "My Firebase App",
      navigatorObservers: [routeObserver],
      home: _startPage(),
      routes: {
        HomePage.id: (context) => const HomePage(),
        SignInPage.id: (context) => const SignInPage(),
        SignUpPage.id: (context) => const SignUpPage(),
        DetailPage.id: (context) => const DetailPage(),
      },
    );
  }
}
