import 'package:flutter/material.dart';
import 'package:bar_trivia/models/user.dart';
import 'package:provider/provider.dart';
import 'package:bar_trivia/models/trivia_event.dart';
import 'package:bar_trivia/models/round.dart';

class RoundDisplay extends StatefulWidget {
  final User user;
  final String eventID;

  RoundDisplay({this.eventID, this.user});

  @override
  _RoundDisplayState createState() => _RoundDisplayState();
}

class _RoundDisplayState extends State<RoundDisplay> {
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

    Round currentRound =
        (currentEvent != null) ? currentEvent.getCurrentRound() : null;

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
            child: _getContent(currentRound)));
  }

  Column _getContent(Round round) {
    if (round != null) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Round " + round.number.toString()),
            SizedBox(height: 60),
            Text("Theme: " + round.theme),
          ]);
    } else {
      print("returning empty column");
      return Column();
    }
  }
}
