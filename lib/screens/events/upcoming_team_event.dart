import 'package:bar_trivia/models/trivia_event.dart';
import 'package:bar_trivia/models/team.dart';
import 'package:bar_trivia/screens/events/event_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer.dart';
import 'package:bar_trivia/shared/constants.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:bar_trivia/services/database.dart';
import 'package:bar_trivia/models/user.dart';
import 'package:provider/provider.dart';

class UpcomingTeamEvent extends StatefulWidget {
  final TriviaEvent event;
  final User user;

  UpcomingTeamEvent({this.event, this.user});

  @override
  _UpcomingTeamEventState createState() => _UpcomingTeamEventState();
}

class _UpcomingTeamEventState extends State<UpcomingTeamEvent> {
  String _teamName = "";
  DatabaseService _dbService = DatabaseService();

  showPicker(BuildContext context) {
    final teams = Provider.of<List<Team>>(context, listen: false);
    if (teams != null) {
      Picker picker = new Picker(
          adapter: PickerDataAdapter<String>(
              pickerdata: teams.map((team) => team.name).toList()),
          changeToFirst: true,
          textAlign: TextAlign.left,
          columnPadding: const EdgeInsets.all(8.0),
          onConfirm: (Picker picker, List value) {
            setState(() {
              _teamName = picker.getSelectedValues()[0];
              for (Team team in teams) {
                if (team.name == _teamName) {
                  team.members.add(widget.user);
                  _dbService.updateTeam(team);
                }
              }
            });
          });
      picker.showDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  SizedBox(height: 60),
                  Text('The game begins in:'),
                  SizedBox(height: 20),
                  EventTimer()
                      .getTimer(widget.event.when.millisecondsSinceEpoch),
                  SizedBox(height: 150),
                  Text("Create a team"),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Enter Team Name'),
                    validator: (val) =>
                        val.isEmpty ? 'Enter a team name!' : null,
                    onChanged: (value) {
                      setState(() => _teamName = value);
                    },
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                      child: Text("Create"),
                      onPressed: () {
                        Team team = Team(
                            name: _teamName,
                            owner: widget.user,
                            members: List<User>());
                        _dbService.updateTeam(team);
                      }),
                  SizedBox(height: 20),
                  Text("or"),
                  SizedBox(height: 20),
                  RaisedButton(
                      child: Text("Select a Team"),
                      onPressed: () {
                        showPicker(context);
                      }),
                  SizedBox(height: 20),
                  Text(_teamName),
                ])));
  }
}
