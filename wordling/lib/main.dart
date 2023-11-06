import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:grock/grock.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordling/random_word.dart';
import 'package:wordling/splash.dart';

import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  if (isFirstTime) {
    // İlk defa açılıyorsa 'isFirstTime' değerini 'false' olarak güncelle
    prefs.setBool('isFirstTime', false);

    runApp(MaterialApp(
      theme: ThemeData(
        dividerTheme: DividerThemeData(
          space: 20,
          thickness: 10,
          color: Colors.blueGrey,
          indent: 20,
          endIndent: 20,
        ),
      ),
      title: 'Firestore Example',
      debugShowCheckedModeBanner: false,
      navigatorKey: Grock.navigationKey,
      scaffoldMessengerKey: Grock.scaffoldMessengerKey,
      home: FirstTimeOpenScreen(),
    ));
  } else {
    runApp(MaterialApp(
      theme: ThemeData(
        dividerTheme: DividerThemeData(
          space: 20,
          thickness: 10,
          color: Colors.blueGrey,
          indent: 20,
          endIndent: 20,
        ),
      ),
      title: 'Firestore Example',
      debugShowCheckedModeBanner: false,
      navigatorKey: Grock.navigationKey,
      scaffoldMessengerKey: Grock.scaffoldMessengerKey,
      home: RandomWordScreen(),
    ));
  }

}

