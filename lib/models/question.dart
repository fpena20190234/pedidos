class Question {
  String id;
  String questionText1;
  String questionText2;
  bool questionAnswer;

  Question(String q, bool a){
    questionText1 = q;
    questionAnswer = a;
  }
  //Question({this.id,this.questionText1, this.questionText2,this.questionAnswer});

  /*factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: (json['id_lista_chequo_item']) as String,
      questionText1: (json['No']) as String,
      questionText2: json['nombre_actividad'] as String,
    );
  }*/
}