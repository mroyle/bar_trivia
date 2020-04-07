import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bar_trivia/models/trivia_event.dart';
import 'package:bar_trivia/screens/home/trivia_event_tile.dart';
import 'package:bar_trivia/models/user.dart';
import 'package:bar_trivia/services/database.dart';

class TriviaEventList extends StatefulWidget {
  final User user;
  TriviaEventList({this.user});

  @override
  _TriviaEventListState createState() => _TriviaEventListState();
}

class _TriviaEventListState extends State<TriviaEventList> {
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<List<TriviaEvent>>(context);
    if (events != null) {
      return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            return StreamProvider<List<TriviaEvent>>.value(
                value: DatabaseService().triviaEvents,
                child: TriviaEventTile(
                  eventID: events[index].id,
                  user: widget.user,
                ));
          });
    } else {
      return Container();
    }
  }
}
