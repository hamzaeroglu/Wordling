import 'package:flutter/material.dart';
import 'package:wordling/widgets.dart';

class WordDetailsPopup extends StatelessWidget {
  Widgets widgets = Widgets();
  final String word;
  final String meaning;
  final String sentence;
  final String turkishTranslation;

  WordDetailsPopup({
    required this.word,
    required this.meaning,
    required this.sentence,
    required this.turkishTranslation,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the desired height for the AlertDialog
    double desiredHeight = MediaQuery.of(context).size.height * 0.3;

    return Container(
      child: AlertDialog(
        elevation: 20,
        shadowColor: Colors.blueGrey,
        backgroundColor: Color(0xFFCFEAF2),
        title: Container(
          margin: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(

            border: Border.fromBorderSide( BorderSide( color: Colors.black12, width: 0.2)),

          ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(word,style: widgets.text_style(),textAlign: TextAlign.center, ),
            )),
        content: Container(

          height: desiredHeight, // Set the desired height here
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  child: Column(
                    children: [
                      Text("Örnek Kullanım:", style: widgets.text_style()),
                      Text(sentence, style: widgets.text_style(),),
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
                      Text("Türkçe Çeviri:", style: widgets.text_style(),),
                      Text(turkishTranslation, style: widgets.text_style(),),
                    ],
                  ),

                )



              ],
            ),
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
