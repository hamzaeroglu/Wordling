import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackButton extends StatelessWidget {
  final CollectionReference feedbackCollection =
  FirebaseFirestore.instance.collection('feedback');
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.feedback, color: Colors.red),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return AlertDialog(
                  backgroundColor: Color(0xFFCDE9E8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  title: Text("Geri Bildirim"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        child: RadioListTile(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          title: Text("Hatalı Kelime Bildir"),
                          value: 'wrong_words',
                          groupValue: feedbackType,
                          onChanged: (value) {
                            setState(() {
                              feedbackType = value!;
                            });
                          },
                        ),
                      ),
                      Divider(
                        color: Colors.red,
                        thickness: 2,
                        indent: 20,
                        endIndent: 20,
                        height: 5,
                      ),
                      SizedBox(
                        child: RadioListTile(
                          title: Text("Eksik Kelime Bildir"),
                          value: 'missing_words',
                          groupValue: feedbackType,
                          onChanged: (value) {
                            setState(() {
                              feedbackType = value!;
                            });
                          },
                        ),
                      ),
                      TextField(
                        controller: descriptionController,
                        decoration: InputDecoration(labelText: 'Hatalı veya eksik kelimeyi girin.'),
                        maxLength: 20, // Maksimum karakter sınırı
                      ),
                      ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blue)),
                        onPressed: () {
                          if (descriptionController.text.length <= 20) {
                            // Açıklama maksimum 20 karakterse Firestore'a gönder
                            _submitFeedback(feedbackType, context);
                          } else {
                            // Hata mesajı gösterme
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Açıklama 20 karakterden uzun olamaz.'),
                              ),
                            );
                          }
                        },
                        child: Text("Gönder", style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  String feedbackType = 'wrong_words';

  Future<void> _submitFeedback(String feedbackType, BuildContext context) async {
    String description = descriptionController.text;

    // Geri bildirim türüne göre ilgili doküman referansını alın
    DocumentReference feedbackDocument;

    if (feedbackType == 'missing_words') {
      feedbackDocument = FirebaseFirestore.instance.collection('feedback').doc('missing_words');
    } else if (feedbackType == 'wrong_words') {
      feedbackDocument = FirebaseFirestore.instance.collection('feedback').doc('wrong_words');
    } else {
      // Geri bildirim türü belirtilmediğinde bir varsayılan dokümanı kullanın
      feedbackDocument = FirebaseFirestore.instance.collection('feedback').doc('default');
    }

    // Geri bildirimi eklemek için collection referansını kullanın
    CollectionReference feedbackCollection = feedbackDocument.collection('feedbacks');

    // Açıklama verisini ilgili koleksiyona ekleyin
    await feedbackCollection.add({
      'description': description,
      'timestamp': FieldValue.serverTimestamp(),
    });

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Geri bildiriminiz gönderildi, TEŞEKKÜRLER.'),
        behavior: SnackBarBehavior.floating, // SnackBar'ı üst tarafta gösterir
      ),
    );

    descriptionController.clear();
  }




}
