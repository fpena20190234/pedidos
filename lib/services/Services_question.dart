import 'dart:async';
//import 'dart:convert'  as conver;
import 'dart:convert';
import 'package:http/http.dart' as http; // add the http plugin in pubspec.yaml file.
import '../models/Questions.dart';

class Services_question {
  static const ROOT = 'http://18.223.233.247/deltec/webservice/Supervisorn/Questions.php';
  static const _GET_ALL_ACTION = 'GET_ALL';
  int _questionNumber = 0;

  // List<Question> _questionBank = getProjectDetails();

  // List<Question> _questionBank = await _questionBank1;
  List<Question> _questionBank = [
    Question('como estas',true),
    Question('hola', true),
  ];

  static Future<List<Questions>> getQuestions(String id_preoperacional) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _GET_ALL_ACTION;
      map['id_lista_chequeo'] = id_preoperacional;

      final response = await http.post(ROOT, body: map);
      if (200 == response.statusCode || 500 == response.statusCode) {
        List<Questions> list = parseResponse(response.body);
        //getCrearLista(list);
        // list.forEach((item) {
        //   print(item.id);
        //   // _questionBank.add(Question(0, name: 'Any category'));
        // });
        return list;
      } else {
        return List<Questions>();
      }
    } catch (e) {
      return List<Questions>(); // return an empty list on exception/error
    }
  }


static void getCrearLista(List<Questions> pregunta)
{
  //List<Question> questions;
  //
  //     questions = pregunta
  //     .map((question) => Question.fromQuestionModel(question))
  //     .toList();
  // pregunta.map((e) => null).toList();
  pregunta.forEach((item) {
     // _questionBank.add(Question(item.textAspectos,true));
    // _questionBank.add(Question(0, name: 'Any category'));
  });

  // return list;
}
  static List<Questions> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Questions>((json) => Questions.fromJson(json)).toList();
  }

   //metodos para acceder a las propiedades
  String getQuestionText() {
    return _questionBank[_questionNumber].questionText1;
  }


  bool getQuestionAnswer() {
    return _questionBank[_questionNumber].questionAnswer;
  }

  void nextQuestion() {
    if (_questionNumber < _questionBank.length -1 )
      _questionNumber++;
  }

  bool finalQuestion() {
    if (_questionNumber == _questionBank.length -1 ) {
      _questionNumber = 0;
      return true;
    }
    else
      return false;

  }


}