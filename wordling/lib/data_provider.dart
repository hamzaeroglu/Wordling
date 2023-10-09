import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DataProvider {
  final StreamController<Map<String, dynamic>> _wordStreamController =
  StreamController<Map<String, dynamic>>();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Stream<Map<String, dynamic>> get wordStream => _wordStreamController.stream;

  // Rastgele kelimenin değiştiği zamanı izlemek için bir işlev ekleyin
  void listenForWordChange(void Function() callback) {
    _wordStreamController.stream.listen((data) {
      // Yeni kelime alındığında bu işlevi çağırın
      callback();
    });
  }
  int getRandomNumber(int max) {
    final random = Random();
    return random.nextInt(max);
  }
  Future<Map<String, dynamic>?> getLastWord() async {
    final documentSnapshot =
    await FirebaseFirestore.instance.collection('last_word').doc('last').get();

    if (documentSnapshot.exists) {
      return documentSnapshot.data() as Map<String, dynamic>?;
    }

    return null;
  }

  void saveLastWord(Map<String, dynamic> wordData) {
    FirebaseFirestore.instance.collection('last_word').doc('last').set(wordData);
  }

  Future<Map<String, dynamic>?> getRandomWord() async {
    final alphabet = 'abcdefghijklmnopqrstuvwxyz';
    final random = Random();
    final randomLetter = alphabet[random.nextInt(alphabet.length)];

    final letterDocument =
    FirebaseFirestore.instance.collection('words').doc(randomLetter);
    final documentSnapshot = await letterDocument.get();

    if (documentSnapshot.exists) {
      final words = documentSnapshot.data()?['words'];
      if (words != null && words.isNotEmpty) {
        final newWordData = words[random.nextInt(words.length)];

        // Veriyi akışa aktar ve yeni kelimeyi döndür
        _wordStreamController.add(newWordData);
        return newWordData;
      }
    }

    return null;
  }

  Future<List<String>> getRandomMeanings(int count) async {
    final List<String> meanings = [];
    final alphabet = 'abcdefghijklmnopqrstuvwxyz';
    final random = Random();

    for (int i = 0; i < count; i++) {
      final randomLetter = alphabet[random.nextInt(alphabet.length)];
      final letterDocument =
      FirebaseFirestore.instance.collection('words').doc(randomLetter);
      final documentSnapshot = await letterDocument.get();

      if (documentSnapshot.exists) {
        final words = documentSnapshot.data()?['words'];
        if (words != null && words.isNotEmpty) {
          final newWordData = words[random.nextInt(words.length)];
          meanings.add(newWordData['meaning']);
        }
      }
    }

    return meanings;
  }

  Future<List<Map<String, dynamic>>> getWords() async {
    final alphabet = 'abcdefghijklmnopqrstuvwxyz';
    final words = <Map<String, dynamic>>[];

    for (final letter in alphabet.split('')) {
      final letterDocument =
      FirebaseFirestore.instance.collection('words').doc(letter);
      final documentSnapshot = await letterDocument.get();

      if (documentSnapshot.exists) {
        final letterWords = documentSnapshot.data()?['words'];
        if (letterWords != null) {
          words.addAll(List<Map<String, dynamic>>.from(letterWords));
        }
      }
    }

    return words;
  }

  Future<void> saveLastWordAndTime(Map<String, dynamic> wordData) async {
    final prefs = await SharedPreferences.getInstance();
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    await prefs.setString('last_word', jsonEncode(wordData));
    await prefs.setInt('last_close_time', currentTime);
  }

  Future<Map<String, dynamic>?> getLastWordAndTime() async {
    final prefs = await SharedPreferences.getInstance();
    final lastWordJson = prefs.getString('last_word');
    final lastCloseTime = prefs.getInt('last_close_time');

    if (lastWordJson != null && lastCloseTime != null) {
      final lastWordData = jsonDecode(lastWordJson);
      return lastWordData;
    }

    return null;
  }

  void dispose() {
    _wordStreamController.close();
  }
}
