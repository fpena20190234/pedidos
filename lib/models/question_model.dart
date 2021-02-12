class QuestionModel{
  String id;
  String question;
  String question1;

  String answer;
  String imageUrl;

  QuestionModel({this.id,this.question,this.question1,this.answer});

  void setId(String getId){
    id = getId;
  }

  void setQuestion(String getQuestion){
    question = getQuestion;
  }

  void setQuestion1(String getQuestion1){
    question1 = getQuestion1;
  }

  void setAnswer(String getAnswer){
    answer = getAnswer;
  }

  void setImageUrl(String getImageUrl){
    imageUrl = getImageUrl;
  }

  String getId(){
    return id;
  }

  String getQuestion(){
    return question;
  }

  String getQuestion1(){
    return question1;
  }

  String getAnswer(){
    return answer;
  }

  String getImageUrl(){
    return imageUrl;
  }

}