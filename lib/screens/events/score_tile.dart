import 'package:bar_trivia/models/score.dart';
import 'package:flutter/material.dart';

class ScoreTile extends StatelessWidget {
  final Score score;

  ScoreTile({this.score});

  @override
  Widget build(BuildContext context) {
    if (score != null) {
      print(score.team.teamName);
      print(score.score.toString());
      return Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Card(
            margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
            child: ListTile(
              leading: CircleAvatar(
                radius: 25.0,
                backgroundColor: Colors.brown[200],
              ),
              title: Text(score.team.teamName),
              subtitle: Text(score.score.toString()),
            ),
          ));
    } else {
      return Container();
    }
  }
}
