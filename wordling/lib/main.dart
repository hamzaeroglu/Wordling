import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grock/grock.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordling/firebase_messaging_conf.dart';
import 'package:wordling/random_word.dart';
import 'package:wordling/splash.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // FirebaseMessaging'i başlatın
  FirebaseMessaging.onBackgroundMessage(_myBackgroundMessageHandler);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true ;

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
    home: isFirstTime ? FirstTimeOpenScreen() : RandomWordScreen(),
  ));

}
Future<void> _myBackgroundMessageHandler(RemoteMessage message) async {
  print("Bildirim alındı: ${message.messageId}");
  // Bildirimi işleyin veya kullanıcının görmesini sağlayın.
}