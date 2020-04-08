import 'package:bar_trivia/screens/moderator/answer_tile.dart';
import 'package:bar_trivia/screens/moderator/question_tile.dart';
import 'package:bar_trivia/services/database.dart';
import 'package:flutter/material.dart';
import 'package:bar_trivia/models/trivia_event.dart';
import 'package:provider/provider.dart';

class AnswerList extends StatefulWidget {
  final String eventID;
  final int roundNumber;
  final int questionNumber;

  AnswerList({this.eventID, this.roundNumber, this.questionNumber});

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
        FlatButton placeHolderButton = FlatButton.icon(
            icon: Icon(Icons.blur_circular),
            label: Text("Placeholder"),
            onPressed: () async {
              event.rounds[widget.roundNumber].endRound();
              DatabaseService().updateEvent(event);
            });

        return Scaffold(
            backgroundColor: Colors.brown[50],
            appBar: AppBar(
              title: Text("Bar Trivia"),
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              actions: <Widget>[
                placeHolderButton,
              ],
            ),
            body: ListView.builder(
                itemCount: event.rounds[widget.roundNumber]
                    .questions[widget.questionNumber].answers.length,
                itemBuilder: (context, index) {
                  return AnswerTile(
                      event: event,
                      roundNumber: widget.roundNumber,
                      questionNumber: widget.questionNumber,
                      answerNumber: index);
                }));
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }
}
