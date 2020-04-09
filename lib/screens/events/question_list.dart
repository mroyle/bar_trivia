import 'package:bar_trivia/models/question.dart';
import 'package:bar_trivia/screens/events/question_tile.dart';
import 'package:bar_trivia/services/database.dart';
import 'package:flutter/material.dart';
import 'package:bar_trivia/models/trivia_event.dart';
import 'package:provider/provider.dart';
import 'package:bar_trivia/models/user.dart';

class QuestionList extends StatefulWidget {
  final User user;
  final String eventID;
  final int roundNumber;

  QuestionList({this.user, this.eventID, this.roundNumber});

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
        List<Question> askedQuestions = event
            .rounds[widget.roundNumber].questions
            .where((question) => question.hasBeenAsked)
            .toList();

        return Scaffold(
            backgroundColor: Colors.brown[50],
            appBar: AppBar(
              title: Text("Bar Trivia"),
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              actions: <Widget>[],
            ),
            body: ListView.builder(
                itemCount: askedQuestions.length,
                itemBuilder: (context, index) {
                  return QuestionTile(
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
