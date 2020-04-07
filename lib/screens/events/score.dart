import 'package:flutter/material.dart';
import 'package:bar_trivia/models/user.dart';
import 'package:provider/provider.dart';
import 'package:bar_trivia/models/trivia_event.dart';

class ScoreDisplay extends StatefulWidget {
  final User user;
  final String eventID;

  ScoreDisplay({this.eventID, this.user});

  @override
  _ScoreDisplayState createState() => _ScoreDisplayState();
}

class _ScoreDisplayState extends State<ScoreDisplay> {
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<List<TriviaEvent>>(context);
    TriviaEvent currentEvent = null;
    if (events != null) {
      events.forEach((event) {
        if (event.id == widget.eventID) {
          currentEvent = event;
        }
      });
    }

    String text = "";
    print(currentEvent.getScores().length);
    currentEvent.getScores().forEach((score) {
      text = text + "\nRound " + score.roundNumber.toString() + '\n';
      text = text +
          score.scores
              .map((score) =>
                  "\t" + score.team.teamName + ": " + score.score.toString())
              .join("\n");
    });
    return Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text("Events Details"),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
                icon: Icon(Icons.person),
                label: Text("Logout"),
                onPressed: () async {})
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Scores:"),
                SizedBox(height: 40),
                Text(text),
              ]),
        ));
  }
}
