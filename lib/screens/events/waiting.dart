import 'package:flutter/material.dart';

class WaitingOnModerator extends StatefulWidget {
  @override
  _WaitingOnModeratorState createState() => _WaitingOnModeratorState();
}

class _WaitingOnModeratorState extends State<WaitingOnModerator> {
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
                  SizedBox(height: 150),
                  Text("Waiting on the Moderator"),
                  SizedBox(height: 60),
                ])));
  }
}
