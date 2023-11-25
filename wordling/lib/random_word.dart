import 'dart:async';
import 'dart:ffi';
import 'package:circular_menu/circular_menu.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wordling/bannerAd.dart';
import 'package:wordling/favorites_page.dart';
import 'package:wordling/firebase_messaging.dart';
import 'package:wordling/games.dart';
import 'package:wordling/search.dart';
import 'package:wordling/widgets.dart';
import 'package:wordling/wordle.dart';
import 'data_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database.dart';
import 'intersistalAd.dart';

class RandomWordScreen extends StatefulWidget {
  @override
  _RandomWordScreenState createState() => _RandomWordScreenState();

}

class _RandomWordScreenState extends State<RandomWordScreen> {
  final _service = FirebaseNotificationService();
  Widgets widgets = Widgets();
  Timer? _timer;
  Map<String, dynamic> wordData = {};
  String? fcmToken; // FCM token'ını saklayacak değişken
  List<Map<String, dynamic>> allWords = [];
  BannerAd? _bannerAd;
  int buttonPressCount = 0;
  AdManager interstitialState = AdManager();






  @override
  void initState() {
      super.initState();
      _loadBannerAd();
      AdManager.loadInterstitialAd();
      _service.connectNotification();
      FirebaseMessaging.instance.subscribeToTopic("all").then((value) {
        print("ABONELİK BAŞARILI");
        // Abonelik başarılı
      }).catchError((error) {
        // Abonelik hatası
      });
      loadWords();
    // FCM token'ını al ve değişkeni güncelle

    // Uygulama başladığında belirli saatteki kelimeyi kontrol et ve çek
    checkAndFetchWordAtScheduledDate();
  }
  Future<void> _loadBannerAd() async {
    _bannerAd = AdMobService.createBannerAd();

    _bannerAd!.load();
  }

   Future<void> loadWords() async {
    final words = await DataProvider().getWords();
    setState(() {
      allWords = words;
    });
  }


  Future<void> subscribeToTopicOnce(String topic) async {
    final prefs = await SharedPreferences.getInstance();
    bool alreadySubscribed = prefs.getBool('subscribed_to_$topic') ?? false;

    if (!alreadySubscribed) {
      await FirebaseMessaging.instance.subscribeToTopic(topic);
      prefs.setBool('subscribed_to_$topic', true); // Abonelik yapıldı, artık tekrar abone olunmayacak
    } else {
      // Token değiştiğinde güncelle
      String? currentToken = await FirebaseMessaging.instance.getToken();
      String? storedToken = prefs.getString('fcm_token');

      if (currentToken != storedToken) {
        await FirebaseMessaging.instance.subscribeToTopic(topic);
        prefs.setString('fcm_token', currentToken!); // Yeni tokeni sakla
      }
    }
  }


  void checkAndFetchWordAtScheduledDate() async {
    final prefs = await SharedPreferences.getInstance();
    final lastEntryDate = prefs.getString('last_entry_date');
    final now = DateTime.now();

    if (lastEntryDate == null || !_isSameDay(now, DateTime.parse(lastEntryDate))) {
      // İlk giriş veya gün farklıysa yeni kelimeyi çek ve göster
      await _loadNewWord();
      prefs.setString('last_entry_date', now.toIso8601String()); // Son giriş tarihini güncelle
    } else {
      // Otomatik kelime zaten çekildiyse sadece son kelimeyi göster
      _loadLastWordAndTime();
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }


  _loadNewWord() async {
    final data = await DataProvider().getRandomWord();
    if (data != null) {
      setState(() {
        wordData = data;
      });
      // Yeni kelimeyi ve kapatılma zamanını kaydet
      DataProvider().saveLastWordAndTime(wordData);
    }
  }

  _loadLastWordAndTime() async {
    final data = await DataProvider().getLastWordAndTime();
    if (data != null) {
      setState(() {
        wordData = data;
      });
    }
  }

  @override
  void dispose() {
    // Zamanlayıcıyı iptal et
    _timer?.cancel();
    super.dispose();
  }
  Color buttonColor = Colors.white; // Başlangıçta pasif olarak beyaz renkte
  @override
  Widget build(BuildContext context) {


    return

      Scaffold(
        backgroundColor: Color(0xFF8FC2A0),
        appBar: widgets.buildAppBar("WORDLING"),

        body: Stack(
          children:[
        Center(
          child: Container(
            margin: EdgeInsets.only(bottom: 85),
            height: MediaQuery.of(context).size.height* 0.6,
            decoration: BoxDecoration( borderRadius: BorderRadius.circular(15),),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Stack(
                children: [

                  Card(

                    color: Color(0xFFF5E0C9),
                   // color: Color(0xFFB5D6FF),
                    elevation: 40,
                    shadowColor: Color(0xffF5E0C9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          SizedBox(
                            child: Column(
                              children: [
                                if (wordData.isNotEmpty)
                                  Text(
                                    'Kelime:  ${wordData['word']} \n',
                                    style: widgets.text_style(),
                                  ),
                                if (wordData.isNotEmpty)
                                  Text(
                                    'Anlamı: ${wordData['meaning']}',
                                    style: widgets.text_style(),
                                  ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.brown,
                            thickness: 3,
                            indent: 20,
                            endIndent: 20,
                            height: 50,
                          ),
                          SizedBox(
                            child: Column(
                              children: [
                                if (wordData.isNotEmpty)
                                  Text(
                                    'Cümlede Kullanım: ${wordData['sentence']} \n',
                                    style: widgets.text_style(),
                                    textAlign: TextAlign.center,
                                  ),
                                if (wordData.isNotEmpty)
                                  Text(
                                    'Türkçe Çevirisi: ${wordData['turkish_translation']}',
                                    style: widgets.text_style(),
                                    textAlign: TextAlign.center,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: buttonColor, // IconButton'ın rengi burada belirleniyor
                    ),
                    onPressed: () async {
                      // Favorilere ekleme işlemini burada gerçekleştirin

                      int id = await DataBase.instance.insertToFavourites(wordData);
                      if (id > 0) {
                        print('Kelime favorilere eklendi, ID: $id');
                        setState(() {
                          buttonColor = Colors.red; // İşlem başarılı olduğunda rengi kırmızı yap
                        });
                      }
                    },
                  ),

                  Positioned(
                    top: 5, // Üst kenara yaslamak için
                    left: 50, // Sol kenara yaslamak için
                    right: 50, // Sağ kenara yaslamak için
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0XFFC7E1D0),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Center(
                        child: Text("GÜNLÜK KELİME", style: widgets.text_style(),),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 2,
                    right: MediaQuery.of(context).size.width*0.3,
                    left: MediaQuery.of(context).size.width*0.3,

                    child:
                    ElevatedButton(
                      style: widgets.button(),
                      onPressed: () {
                        buttonColor = Colors.white;
                        buttonPressCount++; // Buton basım sayısını artır
                        if (buttonPressCount % 10 == 0) {
                          // Her 10 basışta reklamı göster
                          AdManager.showInterstitialAd();
                        }
                        _loadNewWord();
                      },
                      child: Text("YENİ KELİME", style: widgets.text_style()),
                    ),

                  ),
                  // Circular Menu ekleme

                ],
              ),

            ),
          ),
        ),

        Positioned(

          child: Padding(
            padding: const EdgeInsets.only(bottom:70 ),
            child: CircularMenu(
              alignment: Alignment.bottomCenter,
              radius: 60, // Yarıçapı ayarlayabilirsiniz
              toggleButtonColor: Color(0xff402B04),
              items: [
                CircularMenuItem(
                  color: Color(0XFFDB56AD),

                  icon: Icons.favorite,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FavoritesPage(),
                      ),
                    );
                  },
                ),
                CircularMenuItem(
                  color: Color(0XFFDB56AD),

                  icon: Icons.search,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchWords(),
                      ),
                    );
                  },
                ),
                CircularMenuItem(
                  color: Color(0XFFDB56AD),

                  icon: Icons.videogame_asset_rounded,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => chooseGame(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        if (_bannerAd != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          ),
    ]
    )



    );

  }

}
