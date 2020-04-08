import 'package:bar_trivia/screens/moderator/round_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bar_trivia/models/trivia_event.dart';

class RoundList extends StatefulWidget {
  final String eventID;

  RoundList({this.eventID});

  @override
  _RoundListState createState() => _RoundListState();
}

class _RoundListState extends State<RoundList> {
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
        return Scaffold(
            backgroundColor: Colors.brown[50],
            appBar: AppBar(
              title: Text("Bar Trivia"),
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              actions: <Widget>[
                FlatButton.icon(
                    icon: Icon(Icons.person),
                    label: Text("Start Round"),
                    onPressed: () async {}),
              ],
            ),
            body: ListView.builder(
                itemCount: event.rounds.length,
                itemBuilder: (context, index) {
                  return RoundTile(
                    event: event,
                    roundNumber: index,
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
