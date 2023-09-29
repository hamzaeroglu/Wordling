import 'package:flutter/material.dart';

class Widgets{
  AppBar buildAppBar(String appBar_text) {
    return AppBar(
      automaticallyImplyLeading: false, // Geri butonunu kaldır
      shape: border(20),
      backgroundColor: Color(0xFFCDE9E8),
      title: Center(child: Text('${appBar_text}', textAlign: TextAlign.center, style: text_style(),)),
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



}