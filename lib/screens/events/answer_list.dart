import 'package:bar_trivia/screens/events/answer_tile.dart';
import 'package:bar_trivia/screens/events/score_list.dart';
import 'package:flutter/material.dart';
import 'package:bar_trivia/models/trivia_event.dart';
import 'package:provider/provider.dart';
import 'package:bar_trivia/models/user.dart';
import 'package:bar_trivia/services/database.dart';

class AnswerList extends StatefulWidget {
  final User user;
  final String eventID;
  final int roundNumber;

  AnswerList({this.user, this.eventID, this.roundNumber});

  @override
  _AnswerListState createState() => _AnswerListState();
}

class _AnswerListState extends State<AnswerList> {
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<List<TriviaEvent>>(context);
    if (events != null) {
      TriviaEvent event;
      events.forEach((tevent) {
        if (tevent.id == widget.eventID) {
          event = tevent;
        }
      });

      if (event != null) {
        return Scaffold(
            backgroundColor: Colors.brown[50],
            appBar: AppBar(
              title: Text("Bar Trivia"),
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              actions: <Widget>[
                FlatButton.icon(
                    icon: Icon(Icons.business_center),
                    label: Text("Team Scores"),
                    onPressed: () async {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return StreamProvider<List<TriviaEvent>>.value(
                              value: DatabaseService().triviaEvents,
                              child: ScoreList(
                                user: widget.user,
                                eventID: event.id,
                                roundNumber: widget.roundNumber,
                              ));
                        },
                      ));
                    })
              ],
            ),
            body: ListView.builder(
                itemCount: event.rounds[widget.roundNumber].questions.length,
                itemBuilder: (context, index) {
                  return AnswerTile(
                    user: widget.user,
                    event: event,
                    roundNumber: widget.roundNumber,
                    questionNumber: index,
                  );
                }));
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }
}
