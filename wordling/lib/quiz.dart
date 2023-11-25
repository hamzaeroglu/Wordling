import 'dart:async';
import 'dart:math';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wordling/random_word.dart';
import 'package:wordling/search.dart';
import 'package:wordling/widgets.dart';
import 'bannerAd.dart';
import 'data_provider.dart';
import 'favorites_page.dart';
import 'feedback.dart';
import 'games.dart'; // DataProvider sınıfını içe aktarın

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  Widgets widgets = Widgets();
  final DataProvider dataProvider = DataProvider(); // DataProvider örneği oluşturun
  String question = ''; // Soru metni
  String correctAnswer = ''; // Doğru cevap
  List<String> choices = []; // Seçeneklerin listesi
  Color boxColor = Color(0xFFBCEFD0);
  Color boxShadowColor = Colors.grey;
  Random random = Random();
  bool containsForbiddenLetters = false;
  bool isAnswerCorrect = false; // Sorunun doğru cevap verilip verilmediğini takip etmek için bir değişken
  Map<int, Color> boxColors = {}; // Şıkların renklerini saklamak için bir Map kullanın
  Map<int, Color?> boxShadows = {}; // Şıkların renklerini saklamak için bir Map kullanın
  BannerAd? _bannerAd;



  @override
  void initState() {
    super.initState();
    _loadBannerAd();
    for (int i = 0; i < 3; i++) {
      boxShadows[i] = boxShadowColor;
      boxColors[i] = boxColor;
    }
    _initializeQuiz();
  }
  Future<void> _loadBannerAd() async {
    _bannerAd = AdMobService.createBannerAd();

    _bannerAd!.load();
  }


  void _initializeQuiz() async {
    // DataProvider ile rastgele 3 kelime çekme işlemi
    final List<Map<String, dynamic>?> randomWordsData = [];

    for (int i = 0; i < 3; i++) {
      final randomWordData = await dataProvider.getRandomWord();
      if (randomWordData != null) {
        randomWordsData.add(randomWordData);
      }
    }

    // Eğer randomWordsData listesi hala 3 öğeden azsa, yeni kelimeler ekleyin
    while (randomWordsData.length < 3) {
      final randomWordData = await dataProvider.getRandomWord();
      if (randomWordData != null) {
        randomWordsData.add(randomWordData);
      }
    }

    // Rastgele bir kelime seçin
    final filteredWordsData = randomWordsData.where((wordData) {
      final word = wordData?['word'] as String;
      final meaning = wordData?['meaning'] as String;

      return !word.contains('x') &&
          !meaning.contains('x') &&
          !word.startsWith(RegExp(r'[A-Z]')) &&
          !meaning.startsWith(RegExp(r'[A-Z]'));
    }).toList();

    if (filteredWordsData.isNotEmpty) {
      final randomIndex = Random().nextInt(filteredWordsData.length);
      final randomWordData = filteredWordsData[randomIndex];

      setState(() {
        int randomNumber = random.nextInt(2) + 1;
        if (randomNumber == 2) {
          question = '${randomWordData?['word']}';
          correctAnswer = randomWordData?['meaning'];

          choices = [
            randomWordsData[0]!['meaning'] as String,
            randomWordsData[1]!['meaning'] as String,
            randomWordsData[2]!['meaning'] as String,
          ]..shuffle();
        } else if (randomNumber == 1) {
          question = '${randomWordData?['meaning']}';
          correctAnswer = randomWordData?['word'];

          choices = [
            randomWordsData[0]!['word'] as String,
            randomWordsData[1]!['word'] as String,
            randomWordsData[2]!['word'] as String,
          ]..shuffle();
        }
      });

      for (int i = 0; i < 3; i++) {
        boxShadows[i] = boxShadowColor;
        boxColors[i] = boxColor;
      }
    } else {
      // Uygun kelime bulunamazsa, isteğe bağlı olarak bir hata mesajı gösterilebilir
      print("Uygun kelime bulunamadı.");
    }
  }




  void _failedMessage(){
    final snackBar = SnackBar(
      backgroundColor: Colors.redAccent,
      content: Text(" CEVAP YANLIŞ!",style:TextStyle(color: Colors.black, fontFamily: 'Montserrat', fontWeight:FontWeight.bold ,)),
      action: SnackBarAction(
        label: 'Tamam',
        onPressed: () {
          // Eylem gerçekleştiğinde burada bir şey yapabilirsiniz.
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }
  void _successMessage(){
    final snackBar = SnackBar(
      backgroundColor: Colors.greenAccent,
      content: Text("CEVAP DOĞRU", style: TextStyle(color: Colors.black, fontFamily: 'Montserrat', fontWeight:FontWeight.bold ,)),

    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }

  // Diğer işlevler ve build metodu burada bulunmalıdır

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widgets.buildAppBar("Kelimenin Karşılığı Nedir"),
      body: Stack(
    children:
    [
    Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [

      Container(
        margin: EdgeInsets.only(bottom: 70),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 20,
          color:Color(0XFF09B7E6) ,
          child: Column(
            children: [

              Container(

                width: MediaQuery.of(context).size.width*0.7,
                decoration: BoxDecoration( border: Border.all(width: 0.6, style: BorderStyle.solid), borderRadius: BorderRadius.circular(20), color: Color(0xFFF0C70A)),
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(16.0),
                child: Text(
                  question,
                  style: widgets.text_style(),
                ),
              ),
              SizedBox(height: 20),
              Column(
                children: choices.asMap().entries.map((entry) {
                  final index = entry.key;
                  final choice = entry.value;

                  return GestureDetector(
                    onTap: () {
                      if (choice == correctAnswer) {
                        setState(() {
                          isAnswerCorrect = true;
                          boxShadows[index] = Colors.transparent; // Şık doğruysa, box shadow rengini transparan yapın
                          boxColors[index] = Colors.green;

                        });
                        _successMessage();
                        _initializeQuiz();
                      } else {
                        setState(() {
                          boxShadows[index] = Colors.transparent; // Şık doğruysa, box shadow rengini transparan yapın
                          boxColors[index] = Colors.red;
                        });
                        _failedMessage();
                      }
                      // Şık seçimine basıldığında bekleyin ve rengi tekrar orijinal hale getirin
                      Future.delayed(Duration(seconds: 3), () {
                        setState(() {
                          boxColors[index] = boxColor;
                          isAnswerCorrect = false;
                          boxShadows[index] = boxShadowColor;
                        });
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: boxColors[index],
                          boxShadow: [
                            BoxShadow(
                              color: boxShadows[index] = boxShadows[index] ?? Colors.transparent, // Varsayılan olarak nullsa, şeffaf yapabilirsiniz

                        offset: Offset(0, 2),
                              blurRadius: 2,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: Center(child: Text('$choice', textAlign: TextAlign.center, style: widgets.text_style())),
                      ),
                    ),
                  );

                }).toList(),
              ),

              SizedBox(height: 20),

            ],
          ),

        ),
      ),

    ],
    ),



      Positioned(

        child: Padding(
          padding: const EdgeInsets.only(top:120 ),
          child: CircularMenu(
            alignment: Alignment.topRight,
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
                icon: Icons.my_library_books_sharp,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RandomWordScreen(),
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
    ));
  }


}
