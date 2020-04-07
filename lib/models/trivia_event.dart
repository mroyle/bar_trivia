import 'package:bar_trivia/models/round_scores.dart';
import 'package:bar_trivia/models/round.dart';
import 'package:bar_trivia/models/team_name.dart';
import 'package:bar_trivia/models/score.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bar_trivia/models/user.dart';
import 'question.dart';

class TriviaEvent {
  final String id;
  final String location;
  final Timestamp when;
  final bool isActive;
  final List<Round> rounds;
  final List<TeamName> teamNames;

  TriviaEvent(
      {this.id,
      this.location,
      this.when,
      this.isActive,
      this.rounds,
      this.teamNames});

  bool isQuestionBeingAsked() {
    bool response = false;
    rounds.forEach((round) {
      round.questions.forEach((question) {
        if (question.isCurrentQuestion) {
          response = true;
        }
      });
    });
    return response;
  }

  Question getCurrentQuestion() {
    Question question;
    Round round = getCurrentRound();
    print("Round is null = " + (round == null).toString());
    if (round != null) {
      round.questions.forEach((q) {
        print(q.text);
        if (q.isCurrentQuestion) {
          question = q;
        }
      });
    }
    return question;
  }

  Round getCurrentRound() {
    Round round = null;
    rounds.forEach((_round) {
      if (_round.isActive) {
        round = _round;
      }
    });
    return round;
  }

  bool amIRegisteredForThisEvent(User user) {
    bool result = false;
    teamNames.forEach((team) {
      if (team.userID == user.uid) {
        result = true;
      }
    });
    return result;
  }

  String getTeamName(User user) {
    String result = "";
    teamNames.forEach((team) {
      if (team.userID == user.uid) {
        result = team.teamName;
      }
    });
    return result;
  }

  Round latestCompletedRound() {
    Round result;
    rounds.forEach((round) {
      if (round.isComplete) {
        if (result == null) {
          result = round;
        } else {
          if (result.number < round.number) {
            result = round;
          }
        }
      }
    });
    return result;
  }

  Round getRoundByNumber(int number) {
    Round result;
    rounds.forEach((round) {
      if (round.number == number) {
        result = round;
      }
    });
    return result;
  }

  List<RoundScores> getScores() {
    List<RoundScores> scores = [];
    int lastCompletedRound =
        latestCompletedRound() == null ? 0 : latestCompletedRound().number;
    for (int index = 1; index <= lastCompletedRound; index++) {
      scores.add(RoundScores(
          roundNumber: index,
          scores: teamNames
              .map((team) => Score(
                  team: team,
                  score: getRoundByNumber(index).getScoreForTeamName(team)))
              .toList()));
    }
    return scores;
  }
}
