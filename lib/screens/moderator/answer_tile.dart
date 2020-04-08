import 'package:bar_trivia/models/answer.dart';
import 'package:bar_trivia/models/question.dart';
import 'package:bar_trivia/models/trivia_event.dart';
import 'package:bar_trivia/services/database.dart';
import 'package:flutter/material.dart';

class AnswerTile extends StatelessWidget {
  final int roundNumber;
  final int questionNumber;
  final int answerNumber;
  final TriviaEvent event;

  AnswerTile(
      {this.event, this.roundNumber, this.questionNumber, this.answerNumber});

  @override
  Widget build(BuildContext context) {
    Answer answer = event
        .rounds[roundNumber].questions[questionNumber].answers[answerNumber];
    if (answer != null) {
      return Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Card(
            margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
            child: ListTile(
              leading: CircleAvatar(
                radius: 25.0,
                backgroundColor:
                    answer.isCorrect ? Colors.lightGreen : Colors.pink,
              ),
              title: Text(answer.text),
              subtitle: Text(event.getTeamNameByUserID(answer.playerID)),
              onTap: () {
                answer.isCorrect = !answer.isCorrect;
                DatabaseService().updateEvent(event);
              },
            ),
          ));
    } else {
      return Container();
    }
  }
}
