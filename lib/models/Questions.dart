class Question {
  String id;
  String questionText1;
  String questionText2;
  bool questionAnswer;

  Question(String q, bool a) {
    questionText1 = q;
    questionAnswer = a;
  }
}
class Questions {
  String id;
  String textAspectos;
  String textRevision;

  Questions({this.id, this.textAspectos,this.textRevision});

  factory Questions.fromJson(Map<String, dynamic> json) {
    return Questions(
      id: (json['id_lista_chequo_item']) as String,
      textAspectos: json['no'] as String,
      textRevision: json['nombre_activididad'] as String,

    );
  }
}