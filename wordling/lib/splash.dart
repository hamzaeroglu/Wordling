import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:grock/grock.dart';
import 'package:wordling/random_word.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstTimeOpenScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: OnBoardingSlider(

        headerBackgroundColor: Colors.white,
        finishButtonStyle: FinishButtonStyle(

          backgroundColor: Colors.green,
        ),

        finishButtonText:'UYGULAMAYA GİT',
        onFinish :(){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RandomWordScreen(),
            ),
          );
        },
        addButton: true,
        background: [
          buildImage(context, '1', MediaQuery.of(context).size.height * 0.7),
          buildImage(context, '2',MediaQuery.of(context).size.height * 0.7),
          buildImage(context, '3-4',MediaQuery.of(context).size.height * 0.9),
          buildImage(context, '5-6-7',MediaQuery.of(context).size.height * 0.9),
        ],
        totalPage: 4,
        speed: 1.8,
        pageBodies: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                buildSizedBox(context),
                Text('HER GÜN YENİLENEN KELİMENİZİ ÖĞRENİN', style: buildTextStyle()),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                buildSizedBox(context),
                Text('TEKRAR GÖRMEK İSTEDİĞİNİZ KELİMELERİ İŞARETLEYİN',style: buildTextStyle(),),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                buildSizedBox(context),
                Text('TÜRKÇE VE İNGİLİZCE OLARAK SÖZLÜK ARAMASI YAPIN',style: buildTextStyle(),),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                buildSizedBox(context),
                Text('OYUNLARLA KELİME ÖĞRENMEYİ DAHA KEYİFLİ BİR HALE GETİRİN',style: buildTextStyle(),),
              ],
            ),
          ),

        ],
      ),
    );
  }

  TextStyle buildTextStyle() => TextStyle(fontWeight: FontWeight.bold,fontSize: 15);

  SizedBox buildSizedBox(BuildContext context) {
    return SizedBox(
                height: MediaQuery.of(context).size.height*0.75,
       );
  }

  Widget buildImage(BuildContext context, String name, double imageHeight) {
    return Padding(
      padding: const EdgeInsets.only(left:8.0),
      child: Card(
        child: Image.asset(
          'assets/images/opening/$name.png',
          width: MediaQuery.of(context).size.width * 0.9,
          height: imageHeight,
        ),
      ),
    );
  }
}
