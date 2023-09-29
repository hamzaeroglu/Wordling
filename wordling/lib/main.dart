import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grock/grock.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:wordling/firebase_messaging_conf.dart';
import 'package:wordling/random_word.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();



  runApp(MaterialApp(
    theme: ThemeData(
      dividerTheme:
        DividerThemeData(
          space: 20,
          thickness: 10,
          color: Colors.blueGrey,
          indent: 20,
          endIndent: 20,
        )
    ),
    title: 'Firestore Example',
    debugShowCheckedModeBanner: false,
    navigatorKey: Grock.navigationKey,
    scaffoldMessengerKey: Grock.scaffoldMessengerKey,
    home: RandomWordScreen(),
  ));
}

