import 'package:bar_trivia/models/trivia_event.dart';
import 'package:provider/provider.dart';
import 'package:bar_trivia/screens/events/answer_list.dart';
import 'package:bar_trivia/screens/events/question_list.dart';
import 'package:flutter/material.dart';
import 'package:bar_trivia/services/database.dart';
import 'package:bar_trivia/models/user.dart';

class RoundTile extends StatelessWidget {
  final TriviaEvent event;
  final int roundNumber;
  final User user;

  RoundTile({this.user, this.event, this.roundNumber});

  @override
  Widget build(BuildContext context) {
    if (roundNumber != null) {
      return StreamProvider<List<TriviaEvent>>.value(
          value: DatabaseService().triviaEvents,
          child: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Card(
                margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25.0,
                    backgroundColor: !event.rounds[roundNumber].isActive
                        ? event.rounds[roundNumber].isComplete
                            ? Colors.pink
                            : Colors.grey[300]
                        : Colors.lightGreen,
                  ),
                  title: Text(
                      "Round " + event.rounds[roundNumber].number.toString()),
                  subtitle: Text("Theme " + event.rounds[roundNumber].theme),
                  onTap: () {
                    if (event.rounds[roundNumber].isActive) {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return StreamProvider<List<TriviaEvent>>.value(
                              value: DatabaseService().triviaEvents,
                              child: QuestionList(
                                user: user,
                                eventID: event.id,
                                roundNumber: roundNumber,
                              ));
                        },
                      ));
                    } else if (event.rounds[roundNumber].isComplete) {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return StreamProvider<List<TriviaEvent>>.value(
                              value: DatabaseService().triviaEvents,
                              child: AnswerList(
                                user: user,
                                eventID: event.id,
                                roundNumber: roundNumber,
                              ));
                        },
                      ));
                    }
                  },
                ),
              )));
    } else {
      return Container();
    }
  }
}
