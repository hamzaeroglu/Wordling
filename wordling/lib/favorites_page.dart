import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wordling/games.dart';
import 'package:wordling/random_word.dart';
import 'package:wordling/search.dart';
import 'package:wordling/widgets.dart';
import 'package:wordling/database.dart';
import 'package:wordling/word_details.dart';
import 'package:wordling/wordle.dart';

import 'bannerAd.dart';
class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  Widgets widgets = Widgets();
  DataBase db = DataBase();
  List<Map<String, dynamic>> favoritesData = []; // Favorileri saklayacak liste

  @override
  void initState() {
    super.initState();
    // Favorileri başlatmak için veritabanından verileri alın
    _loadFavorites();
  }

  _loadFavorites() async {
    final favorites = await db.getFavorites();
    setState(() {
      favoritesData = favorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:
      [Scaffold(
        backgroundColor: Color(0xFFECEAE8),
        appBar: widgets.buildAppBar("FAVORİ KELİMELER", ),
        body: _buildFavoritesList(),

      ),
        Positioned(

          child: CircularMenu(
            alignment: Alignment.bottomRight,
            radius: 60, // Yarıçapı ayarlayabilirsiniz
            toggleButtonColor: Colors.black,
            items: [
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

      ]
    );
  }

  Widget _buildFavoritesList() {
    if (favoritesData.isEmpty) {
      return Center(
        child: Text('Henüz favori kelimeniz yok.'),
      );
    } else {
      return ListView.builder(
        itemCount: favoritesData.length,
        itemBuilder: (context, index) {
          final favorite = favoritesData[index];
          final word = favorite['word'] ?? '';
          final meaning = favorite['meaning'] ?? '';
          final sentence = favorite['sentence'] ?? '';

          return Card(
            color: Color(0xFFFFF8E0),
            child: ListTile(
              leading: IconButton(
                onPressed: () {
                  _showDeleteConfirmationDialog(word, favorite['id'], index);
                },
                icon: Icon(Icons.delete_outlined),
              ),
              trailing: IconButton(
                onPressed: () {
                  _showWordDetailsPopup(word, sentence, favorite['turkish_translation'] ?? '');
                },
                icon: Icon(Icons.info_outline),
              ),
              title: Text(
                word,
                style: widgets.text_style(),
                textAlign: TextAlign.center,
              ),
              subtitle: Text(
                meaning,
                style: widgets.text_style(),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      );
    }
  }


  _deleteFavorite(int id, int index) async {
    // Favoriyi veri tabanından sil
    await db.deleteFavorite(id);

    // Veritabanından güncel favori listesini al
    final updatedFavorites = await db.getFavorites();

    // Listeyi güncelle
    setState(() {
      favoritesData = updatedFavorites;
    });
  }
  _showWordDetailsPopup(String word, String sentence, String translation) async {
    // Fetch the sentence and Turkish translation from the database
    final favorites = await db.getFavorites();
    final favorite = favorites.firstWhere((element) => element['word'] == word);

    final sentenceFromDB = favorite['sentence'];
    final turkishTranslationFromDB = favorite['turkish_translation'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WordDetailsPopup(
          word: word,
          meaning: sentenceFromDB,
          sentence: sentenceFromDB,
          turkishTranslation: turkishTranslationFromDB,
        );
      },
    );
  }



  _showDeleteConfirmationDialog(String word, int id, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Favoriyi Sil"),
          content: Text("'$word' kelimesini favorilerden silmek istediğinize emin misiniz?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // İletişim kutusunu kapat
              },
              child: Text("İptal"),
            ),
            TextButton(
              onPressed: () {
                _deleteFavorite(id, index); // Favoriyi silme işlemini gerçekleştir
                Navigator.of(context).pop(); // İletişim kutusunu kapat
              },
              child: Text("Sil"),
            ),
          ],
        );
      },
    );
  }



}
