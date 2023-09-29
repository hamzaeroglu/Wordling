import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:wordling/favorites_page.dart';
import 'package:wordling/random_word.dart';
import 'package:wordling/widgets.dart';
import 'package:wordling/word_details.dart';
import 'package:wordling/wordle.dart';
import 'data_provider.dart';

class SearchWords extends StatefulWidget {
  const SearchWords({Key? key}) : super(key: key);

  @override
  State<SearchWords> createState() => _SearchWordsState();
}

class _SearchWordsState extends State<SearchWords> {
  Widgets widgets = Widgets();
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> allWords = [];
  List<Map<String, dynamic>> filteredWords = [];

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  Future<void> _loadWords() async {
    final words = await DataProvider().getWords();
    setState(() {
      allWords = words;
    });
  }

  void _searchWords(String query) {
    final lowercaseQuery = query.toLowerCase();
    if (lowercaseQuery.isEmpty) {
      setState(() {
        filteredWords.clear();
      });
    } else {
      setState(() {
        filteredWords = allWords.where((word) {
          final wordText = word['word'].toString().toLowerCase();
          final turkishTranslation = word['meaning'].toString().toLowerCase();
          final isExactMatch = wordText == lowercaseQuery || turkishTranslation == lowercaseQuery;
          return isExactMatch || wordText.contains(lowercaseQuery) || turkishTranslation.contains(lowercaseQuery);
        }).toList();
        // Tam eşleşen sonuçları en başa taşı
        filteredWords.sort((a, b) {
          final aWord = a['word'].toString().toLowerCase();
          final bWord = b['word'].toString().toLowerCase();
          final aTurkish = a['meaning'].toString().toLowerCase();
          final bTurkish = b['meaning'].toString().toLowerCase();

          if (aWord == lowercaseQuery || aTurkish == lowercaseQuery) {
            return -1;
          } else if (bWord == lowercaseQuery || bTurkish == lowercaseQuery) {
            return 1;
          }
          return 0;
        });
      });
    }
  }
  void _showWordDetails(String word, String meaning, String sentence, String turkishTranslation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WordDetailsPopup(
          word: word,
          meaning: meaning,
          sentence: sentence,
          turkishTranslation: turkishTranslation,
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Stack(
      children:
      [
      Scaffold(
        backgroundColor: Color(0xFFECEAE8),
        appBar: widgets.buildAppBar("Sözlük"),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(

                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,

                  ),
                  TextFormField(
                    style: widgets.text_style(),
                    controller: searchController,
                    onChanged: _searchWords,
                    decoration: InputDecoration(
                      labelText: 'Kelime Ara',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20),gapPadding:20 ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: filteredWords.isEmpty
                        ? Center(
                      child: Text('Arama sonuçları bulunamadı.', style: widgets.text_style()),
                    )
                        : ListView.builder(
                      itemCount: filteredWords.length,
                      itemBuilder: (context, index) {
                        final word = filteredWords[index];
                        return Card(
                          color: Color(0xFFFFF8E0),
                          child: ListTile(
                            onTap: () {
                              _showWordDetails(
                                word['word'].toString(),
                                word['meaning'].toString(),
                                // Burada İngilizce cümle içinde kullanımını ve Türkçe çevirisini almanız gerekiyor.
                                // Bu bilgileri Firestore'dan veya uygun bir yerden almalısınız.
                                // Örnek olarak aşağıdaki gibi düşünülebilir:
                                word['sentence'].toString(),
                                word['turkish_translation'].toString(),
                              );
                            },

                            title: Text(word['word'].toString(), style: widgets.text_style()),
                            subtitle: Text(word['meaning'].toString(), style: widgets.text_style(),),
                          ),

                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
        Positioned(

          child: CircularMenu(
            alignment: Alignment.bottomRight,
            radius: 60, // Yarıçapı ayarlayabilirsiniz
            toggleButtonColor: Colors.black,
            items: [
              CircularMenuItem(
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
                icon: Icons.videogame_asset_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WordleGamePage(),
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
}
