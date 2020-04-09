import 'package:bar_trivia/screens/events/score_tile.dart';
import 'package:flutter/material.dart';
import 'package:bar_trivia/models/trivia_event.dart';
import 'package:provider/provider.dart';
import 'package:bar_trivia/models/user.dart';
import 'package:bar_trivia/models/round_scores.dart';

class ScoreList extends StatefulWidget {
  final User user;
  final String eventID;
  final int roundNumber;

  ScoreList({this.user, this.eventID, this.roundNumber});

  @override
  _ScoreListState createState() => _ScoreListState();
}

class _ScoreListState extends State<ScoreList> {
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
        print(widget.roundNumber.toString());
        print("^^^^^^^^^^^^^^^^^^^^^^");
        RoundScores scores = event.getScoresForRound(widget.roundNumber + 1);
        scores.scores.sort((a, b) => a.score?.compareTo(b.score));

        return Scaffold(
            backgroundColor: Colors.brown[50],
            appBar: AppBar(
              title: Text("Bar Trivia"),
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              actions: <Widget>[],
            ),
            body: ListView.builder(
                itemCount: scores.scores.length,
                itemBuilder: (context, index) {
                  return ScoreTile(score: scores.scores[index]);
                }));
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }
}
