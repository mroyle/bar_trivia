import 'package:bar_trivia/models/trivia_event.dart';
import 'package:bar_trivia/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:bar_trivia/services/database.dart';
import 'package:provider/provider.dart';
import 'package:bar_trivia/models/user.dart';
import 'package:bar_trivia/screens/moderator/moderator_event_list.dart';

class ModeratorHome extends StatelessWidget {
  final AuthService _auth = AuthService();
  final DatabaseService _databaseService = DatabaseService();

  final User user;

  ModeratorHome({this.user});

  @override
  Widget build(BuildContext context) {
    print(user.uid);
    return StreamProvider<List<TriviaEvent>>.value(
        value: DatabaseService().triviaEvents,
        child: Scaffold(
          backgroundColor: Colors.brown[50],
          appBar: AppBar(
            title: Text("Bar Trivia"),
            backgroundColor: Colors.brown[400],
            elevation: 0.0,
            actions: <Widget>[
              FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text("Logout"),
                  onPressed: () async {
                    await _auth.signOut();
                  }),
              FlatButton.icon(
                  icon: Icon(Icons.data_usage),
                  label: Text("Reset data"),
                  onPressed: () {
                    _databaseService.resetData();
                  })
            ],
          ),
          body: ModeratorEventList(user: user),
        ));
  }
}
