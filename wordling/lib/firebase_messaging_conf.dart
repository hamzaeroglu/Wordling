
/*
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void connectNotification() async {
    // FirebaseMessaging onMessage listener ekleyin
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Gelen bildirimi işleyin
      print('Bildirim geldi: ${message.notification?.title}, ${message.notification?.body}');
    });

    // FirebaseMessaging onLaunch listener ekleyin (uygulama kapalıyken bildirim tıklanınca)
    FirebaseMessaging.onLaunch.listen((RemoteMessage message) {
      // Bildirime tıklanınca uygulama açıldığında yapılacak işlemleri burada gerçekleştirin
      print('Uygulama kapalıyken bildirime tıklandı: ${message.notification?.title}, ${message.notification?.body}');
    });

    // FirebaseMessaging onResume listener ekleyin (uygulama arka planda iken bildirim tıklanınca)
    FirebaseMessaging.onResume.listen((RemoteMessage message) {
      // Bildirime tıklanınca uygulama arka planda iken yapılacak işlemleri burada gerçekleştirin
      print('Uygulama arka planda iken bildirime tıklandı: ${message.notification?.title}, ${message.notification?.body}');
    });

    // FirebaseMessaging.getToken() ile cihaz token'ını alabilirsiniz
    String? token = await _firebaseMessaging.getToken();
    print('Cihaz Token: $token');
  }

  // Yeni bir bildirim gönderme yöntemi ekle
  void sendNotification(Map<String, dynamic> data) {
    // Bildirim gönderme işlemi burada gerçekleştirilir
    // data içinde bildirim verilerini kullanabilirsiniz
  }
}
*/