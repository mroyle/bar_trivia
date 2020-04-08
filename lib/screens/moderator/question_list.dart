import 'package:bar_trivia/screens/moderator/question_tile.dart';
import 'package:bar_trivia/services/database.dart';
import 'package:flutter/material.dart';
import 'package:bar_trivia/models/trivia_event.dart';
import 'package:provider/provider.dart';

class QuestionList extends StatefulWidget {
  final String eventID;
  final int roundNumber;

  QuestionList({this.eventID, this.roundNumber});

  @override
  _QuestionListState createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
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
        FlatButton startRoundBTN = FlatButton.icon(
            icon: Icon(Icons.blur_circular),
            label: Text("Start Round"),
            onPressed: () async {
              event.rounds[widget.roundNumber].isActive = true;
              DatabaseService().updateEvent(event);
            });

        FlatButton endRoundBTN = FlatButton.icon(
            icon: Icon(Icons.blur_circular),
            label: Text("End Round"),
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
                event.rounds[widget.roundNumber].isActive
                    ? endRoundBTN
                    : startRoundBTN,
              ],
            ),
            body: ListView.builder(
                itemCount: event.rounds[widget.roundNumber].questions.length,
                itemBuilder: (context, index) {
                  return QuestionTile(
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
