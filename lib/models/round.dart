import 'package:bar_trivia/models/question.dart';
import 'package:bar_trivia/models/team_name.dart';

class Round {
  final int number;
  final String theme;
  final bool isActive;
  final bool isComplete;
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
      if (question.getAnswerForID(teamName.userID).text == question.answer) {
        score++;
      }
    });
    return score;
  }
}
