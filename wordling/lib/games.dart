import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wordling/quiz.dart';
import 'package:wordling/widgets.dart';
import 'package:wordling/wordle.dart';

import 'feedback.dart';

class chooseGame extends StatefulWidget {
  chooseGame({Key? key}) : super(key: key);

  @override
  State<chooseGame> createState() => _chooseGameState();
}

class _chooseGameState extends State<chooseGame> {
  Widgets widgets = Widgets();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:
      [Scaffold(
        backgroundColor: Color(0xFFA7FFD0),
        appBar: widgets.buildAppBar("WORDLING"),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(

                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0XFFFEF1DA)), elevation: MaterialStatePropertyAll(20), shadowColor: MaterialStatePropertyAll(Colors.black)),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WordleGamePage(),
                          ),
                        );
                      },
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Animate(
                                  effects: [SlideEffect(), FadeEffect()],
                                  child: Image(image:AssetImage("assets/images/game_ss_1.png", ), width: 40, height: 40,)),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Animate(
                                  effects: [FadeEffect(), SlideEffect()],
                                  child: Text("Wordling - Wordle", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),textAlign: TextAlign.end)),
                            ),
                          ],
                        ),
                      ),

                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return widgets.WordlingInfo(context,'assets/texts/wordling_info.txt' );
                          },
                        );
                      },
                      icon: Icon(Icons.info, color: Colors.green, size: 30,)
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),
              Row(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.7,

                    child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0XFFFEF1DA)), elevation: MaterialStatePropertyAll(20)),

                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuizPage(),
                          ),
                        );
                      },
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Animate(
                                  effects: [FadeEffect(),SlideEffect()],
                                  child: Image(image:AssetImage("assets/images/game_ss_2.png", ), width: 40, height: 40,)),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Animate(
                                  effects: [SlideEffect(),FadeEffect()],
                                  child: Text("Temel Kelime Testi", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),textAlign: TextAlign.end)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return widgets.WordlingInfo(context,'assets/texts/quiz_info.txt' );
                          },
                        );
                      },
                      icon: Icon(Icons.info, color: Colors.green, size: 30,)
                  )

                ],
                mainAxisAlignment: MainAxisAlignment.center,

              ),

            ],
          ),
        ),
      ),
        widgets.buttonShortCut(context)
    ]
    );
  }
}
