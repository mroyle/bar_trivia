import 'package:bar_trivia/models/question.dart';
import 'package:bar_trivia/models/team_name.dart';

class Round {
  final int number;
  final String theme;
  bool isActive;
  bool isComplete;
  final List<Question> questions;

  Round(
      {this.number,
      this.theme,
      this.isActive,
      this.isComplete,
      this.questions});

  int getScoreForTeamName(TeamName teamName) {
    int score = 0;
    questions.forEach((question) {
      if (question.getAnswerForID(teamName.userID) != null) {
        if (question.getAnswerForID(teamName.userID).text == question.answer) {
          score++;
        }
      }
    });
    return score;
  }

  void endRound() {
    isActive = false;
    isComplete = true;
    questions.forEach((q) {
      q.hasBeenAsked = false;
    });
  }
}
