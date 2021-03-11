import '../models/question_model.dart';
import '../services/Services_question.dart';

List<QuestionModel> getQuestions(String id_preoperacional) {
  List<QuestionModel> questions = new List<QuestionModel>();
  QuestionModel questionModel = new QuestionModel();

  Services_question.getQuestions(id_preoperacional).then((questionss) {
    questionss.forEach((item) {
      questionModel.setId(item.id);
      questionModel.setQuestion(item.textRevision);
      questionModel.setQuestion1(item.textAspectos);
      questionModel.setAnswer("True");
      questionModel.setImageUrl(
          "http://18.223.233.247/upload_deltec/DeltecHSEQ.png?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940");
      questions.add(questionModel);
      questionModel = new QuestionModel();
    });
  });

  return questions;
}
