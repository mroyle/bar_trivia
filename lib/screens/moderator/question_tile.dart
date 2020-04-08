import 'package:bar_trivia/models/question.dart';
import 'package:bar_trivia/models/trivia_event.dart';
import 'package:bar_trivia/screens/moderator/answer_list.dart';
import 'package:bar_trivia/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionTile extends StatelessWidget {
  final int roundNumber;
  final int questionNumber;
  final TriviaEvent event;

  QuestionTile({this.event, this.roundNumber, this.questionNumber});

  @override
  Widget build(BuildContext context) {
    Question question = event.rounds[roundNumber].questions[questionNumber];
    if (question != null) {
      return Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Card(
            margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
            child: ListTile(
              leading: CircleAvatar(
                radius: 25.0,
                backgroundColor: question.hasBeenAsked
                    ? Colors.lightGreen
                    : Colors.grey[300],
              ),
              title: Text(question.text),
              subtitle: Text(question.answer),
              onTap: () {
                if (event.rounds[roundNumber].questions[questionNumber]
                    .hasBeenAsked) {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return StreamProvider<List<TriviaEvent>>.value(
                          value: DatabaseService().triviaEvents,
                          child: AnswerList(
                            eventID: event.id,
                            roundNumber: roundNumber,
                            questionNumber: questionNumber,
                          ));
                    },
                  ));
                } else {
                  if (event.rounds[roundNumber].isActive) {
                    question.hasBeenAsked = true;
                    DatabaseService().updateEvent(event);
                  }
                }
              },
            ),
          ));
    } else {
      return Container();
    }
  }
}
