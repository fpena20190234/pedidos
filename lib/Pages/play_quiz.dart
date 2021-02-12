import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../data/data.dart';
import '../models/question_model.dart';
//import '../pages/homepage.dart';
//import 'package:true_false_quiz/views/result.dart';

class PlayQuiz extends StatefulWidget {
  @override
  _PlayQuizState createState() => _PlayQuizState();
}

class _PlayQuizState extends State<PlayQuiz>
    with SingleTickerProviderStateMixin {
  //Inicio el cuestionario
  List<QuestionModel> questions = new List<QuestionModel>();
  int index = 0;
  int points = 0;
  int pointsf = 0;

  int correct = 0;
  int incorrect = 0;

  AnimationController controller;

  Animation animation;

  double beginAnim = 0.0;

  double endAnim = 1.0;
  //Fin el cuestionario

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Inicio Carga cuestionario
    questions = getQuestions("1");
    //if(questions.length>0) {
      controller =
          AnimationController(
              duration: const Duration(seconds: 1), vsync: this);
      animation = Tween(begin: beginAnim, end: endAnim).animate(controller)
        ..addListener(() {
          setState(() {
            // Change here any Animation object value.
            //stopProgress();
          });
        });

      startProgress();

      animation.addStatusListener((AnimationStatus animationStatus) {
        if (animationStatus == AnimationStatus.completed) {
          if (index < questions.length - 1) {
            //index++;
            //resetProgress();
            //startProgress();
          } else {
            // Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => Result(
            //               score: points,
            //               totalQuestion: questions.length,
            //               correct: correct,
            //               incorrect: incorrect,
            //             )));
          }
        }
      });

      //Fin cuestionario

  }

  startProgress() {
    controller.forward();
  }

  stopProgress() {
    controller.stop();
  }

  resetProgress() {
    controller.reset();
  }

  void nextQuestion() {
    if (index < questions.length - 1) {
      index++;
      //resetProgress();
      //startProgress();
    } else {
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => Result(
      //               score: points,
      //               totalQuestion: questions.length,
      //               correct: correct,
      //               incorrect: incorrect,
      //             )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 80),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        questions.length>0?"${index + 1}/${questions.length}":'X',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Pregunta(s)",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                  Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "C=$points/",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        "NC=$pointsf",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                      ),
                      // SizedBox(
                      //   width: 10,
                      // ),
                      // Text(
                      //   "Puntos",
                      //   style: TextStyle(
                      //       fontSize: 17, fontWeight: FontWeight.w300),
                      // )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Pregunta',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,),
            ),
            Text(
              questions.length>0 ?  questions[index].getQuestion1() + ".":'',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              questions.length>0?questions[index].getQuestion() + "?":'',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                child: LinearProgressIndicator(
              value: animation.value,
            )),
            CachedNetworkImage(imageUrl: questions.length>0?questions[index].getImageUrl():''),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      if(index+1< questions.length) {
                        if (questions[index].getAnswer() == "True") {
                          setState(() {
                            points = points + 1;
                            nextQuestion();
                            correct++;
                          });
                        } else {
                          setState(() {
                            pointsf = pointsf + 1;
                            nextQuestion();
                            incorrect++;
                          });
                        }
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(24)),
                      child: Text(
                        "Conforme",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: GestureDetector(
                    onTap: () {
                      if(index+1  < questions.length) {
                        if (questions[index].getAnswer() == "False") {
                          setState(() {
                            points = points + 1;
                            nextQuestion();
                            correct++;
                          });
                        } else {
                          setState(() {
                            pointsf = pointsf + 1;
                            nextQuestion();
                            incorrect++;
                          });
                        }
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(24)),
                      child: Text(
                        "No Conforme",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }
}
