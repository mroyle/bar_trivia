import 'package:flutter/material.dart';
import 'package:bar_trivia/models/trivia_event.dart';
import 'package:bar_trivia/models/team_name.dart';
import 'package:bar_trivia/models/user.dart';
import 'event_timer.dart';
import 'package:provider/provider.dart';
import 'package:bar_trivia/services/database.dart';
import 'package:bar_trivia/shared/constants.dart';

class UpcomingEvent extends StatefulWidget {
  final User user;
  final String eventID;

  UpcomingEvent({this.eventID, this.user});

  @override
  _UpcomingEventState createState() => _UpcomingEventState();
}

class _UpcomingEventState extends State<UpcomingEvent> {
  String teamName = "";

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

    Column child =
        (currentEvent != null) ? _getEventDetails(currentEvent) : _getNull();

    return Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text("Events Details"),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
                icon: Icon(Icons.person),
                label: Text("Reset Data"),
                onPressed: () async {
                  DatabaseService().resetData();
                })
          ],
        ),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: child));
  }

  Column _getNull() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 150),
          Text("It's null?"),
        ]);
  }

  Column _getEventDetails(TriviaEvent event) {
    print(event.teamNames.length);
    return event.amIRegisteredForThisEvent(widget.user)
        ? _getRegistered(event)
        : _getUnregistered(event);
  }

  Column _getRegistered(TriviaEvent event) {
    print("registered");
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 150),
          Text(event.location),
          SizedBox(height: 60),
          Text('The game begins in:'),
          SizedBox(height: 20),
          EventTimer().getTimer(event.when.millisecondsSinceEpoch),
          SizedBox(
            height: 60,
          ),
          Text("You are registered as:"),
          SizedBox(height: 20),
          Text(event.getTeamName(widget.user)),
          SizedBox(height: 60),
          Text("Full list of teams:"),
          SizedBox(height: 20),
          Text(event.teamNames.map((team) => team.teamName).join("\n")),
        ]);
  }

  Column _getUnregistered(TriviaEvent event) {
    print("unregistered");
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 150),
          Text(event.location),
          SizedBox(height: 60),
          Text('The game begins in:'),
          SizedBox(height: 20),
          EventTimer().getTimer(event.when.millisecondsSinceEpoch),
          SizedBox(
            height: 60,
          ),
          Text("Submit your team name"),
          SizedBox(height: 20),
          TextFormField(
            decoration:
                textInputDecoration.copyWith(hintText: 'Enter First Name'),
            validator: (val) => val.isEmpty ? 'Enter your first name' : null,
            onChanged: (value) {
              setState(() => teamName = value);
            },
          ),
          SizedBox(height: 20),
          RaisedButton(
              child: Text("Register"),
              onPressed: () {
                event.teamNames
                    .add(TeamName(teamName: teamName, userID: widget.user.uid));
                DatabaseService().updateEvent(event);
              })
        ]);
  }
}
