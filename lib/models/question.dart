import 'answer.dart';

class Question {
  final String text;
  final String answer;
  bool hasBeenAsked;
  final List<Answer> answers;

  Question({this.text, this.answer, this.hasBeenAsked, this.answers});

  bool hasUserAnswered(String userID) {
    return getAnswerForID(userID) != null;
  }

  String getAnswerFor(String userID) {
    return getAnswerForID(userID) == null ? "" : getAnswerForID(userID).text;
  }

  Answer getAnswerForID(String userID) {
    Answer answer;
    answers.forEach((a) {
      if ((a != null) && (a.playerID == userID)) {
        answer = a;
      }
    });
    return answer;
  }

  void deleteAnswer(String userID) {
    answers.remove(getAnswerForID(userID));
  }
}
