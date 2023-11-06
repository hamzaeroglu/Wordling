import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:wordling/feedback.dart';
import 'package:wordling/games.dart';
import 'package:wordling/random_word.dart';
import 'package:wordling/search.dart';
import 'feedback.dart';
import 'favorites_page.dart';

class Widgets{
  AppBar buildAppBar(String appBar_text) {
    return AppBar(
      automaticallyImplyLeading: false, // Geri butonunu kaldır
      shape: border(20),
      backgroundColor: Color(0xFFFFB959),
      title: Text(
        '${appBar_text}',
        textAlign: TextAlign.center,
        style: text_style(),
      ),
      centerTitle: true, // Text'i tam ortalamak için centerTitle kullanın
      actions: <Widget>[
        FeedbackButton(),
      ],
    );
  }



  TextStyle text_style() => TextStyle(color: Colors.black, fontFamily: 'Montserrat', fontWeight:FontWeight.bold ,);

  RoundedRectangleBorder border( double radius) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(radius),
          bottomRight: Radius.circular(radius),
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius)
      ),
      // side: BorderSide(width: 3,color: Color(0xFFF09865)),
    );
  }
  ButtonStyle button() {
    return ButtonStyle(
        shadowColor: MaterialStatePropertyAll(Colors.brown),
        elevation: MaterialStatePropertyAll(12),
        backgroundColor: MaterialStatePropertyAll(Color(0xFFFFF0D9)),
        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),)
    );
  }
  Positioned buttonShortCut(BuildContext context) {
    return Positioned(

      child: CircularMenu(
        alignment: Alignment.bottomCenter,
        radius: 60, // Yarıçapı ayarlayabilirsiniz
        toggleButtonColor: Colors.black,
        toggleButtonIconColor:Color(0xFFCDE9E8) ,

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
    );
  }

 SingleChildScrollView WordlingInfo(BuildContext context, String path){
  return SingleChildScrollView(
    child: AlertDialog(
      backgroundColor: Color(0xFFECEAE8),
      title: SingleChildScrollView(
         child: FutureBuilder<String>(
           future: DefaultAssetBundle.of(context).loadString(path),
           builder: (context, snapshot) {
             if (snapshot.hasData) {
               return Text(
                 snapshot.data!,
                 style: TextStyle(fontSize: 13.0, color: Colors.pinkAccent), // Metin boyutunu ayarlayın
               );
             } else if (snapshot.hasError) {
               return Text('Metin dosyası okunamıyor: ${snapshot.error}');
             }
             return CircularProgressIndicator();
           },
         ),
       ),
       actions: [
         TextButton(
           onPressed: () {
             Navigator.of(context).pop(); // Pop-up penceresini kapat
           },
           child: Text("Kapat"),
         ),
       ],
     ),
  );

 }

    
    





}