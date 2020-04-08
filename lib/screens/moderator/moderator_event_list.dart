import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bar_trivia/models/trivia_event.dart';
import 'package:bar_trivia/screens/moderator/moderator_event_tile.dart';
import 'package:bar_trivia/models/user.dart';
import 'package:bar_trivia/services/database.dart';

class ModeratorEventList extends StatefulWidget {
  final User user;
  ModeratorEventList({this.user});

  @override
  _ModeratorEventListState createState() => _ModeratorEventListState();
}

class _ModeratorEventListState extends State<ModeratorEventList> {
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<List<TriviaEvent>>(context);
    if (events != null) {
      return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            return StreamProvider<List<TriviaEvent>>.value(
                value: DatabaseService().triviaEvents,
                child: ModeratorEventTile(
                  eventID: events[index].id,
                  user: widget.user,
                ));
          });
    } else {
      return Container();
    }
  }
}
