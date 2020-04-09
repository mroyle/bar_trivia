import 'package:bar_trivia/models/question.dart';
import 'package:bar_trivia/models/trivia_event.dart';
import 'package:bar_trivia/services/database.dart';
import 'package:flutter/material.dart';
import 'package:bar_trivia/models/answer.dart';
import 'package:bar_trivia/models/user.dart';

class AnswerTile extends StatelessWidget {
  final User user;
  final int roundNumber;
  final int questionNumber;
  final TriviaEvent event;

  AnswerTile({this.user, this.event, this.roundNumber, this.questionNumber});

  @override
  Widget build(BuildContext context) {
    Question question = event.rounds[roundNumber].questions[questionNumber];
    Answer answer = question.getAnswerForID(user.uid);
    if (question != null) {
      return Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Card(
            margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
            child: ListTile(
              leading: CircleAvatar(
                radius: 25.0,
                backgroundColor:
                    answer.isCorrect ? Colors.lightGreen : Colors.red,
              ),
              title: Text(question.text),
              subtitle: answer.isCorrect
                  ? Text(answer.text)
                  : Text("Expected " +
                      question.answer +
                      ", but was " +
                      answer.text),
            ),
          ));
    } else {
      return Container();
    }
  }

  void _saveAnswer(String answer) async {
    Question question = event.rounds[roundNumber].questions[questionNumber];
    question.deleteAnswer(user.uid);
    question.answers.add(Answer(
        playerID: user.uid,
        text: answer,
        isCorrect: (answer.toLowerCase() == question.answer.toLowerCase())));
    DatabaseService().updateEvent(event);
  }
}
