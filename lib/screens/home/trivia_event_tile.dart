import 'package:bar_trivia/screens/events/round_list.dart';
import 'package:flutter/material.dart';
import 'package:bar_trivia/models/trivia_event.dart';
import 'package:bar_trivia/models/user.dart';
import 'package:provider/provider.dart';
import 'package:bar_trivia/services/database.dart';

class TriviaEventTile extends StatelessWidget {
  final String eventID;
  final User user;

  TriviaEventTile({this.eventID, this.user});

  TriviaEvent _getEvent(BuildContext context) {
    final events = Provider.of<List<TriviaEvent>>(context);
    TriviaEvent event = TriviaEvent();

    if (events != null) {
      events.forEach((eventh) {
        if (eventh.id == eventID) {
          event = eventh;
        }
      });
    }

    return event;
  }

  @override
  Widget build(BuildContext context) {
    TriviaEvent event = _getEvent(context);

    if (event != null && event.location != null) {
      return StreamProvider<List<TriviaEvent>>.value(
          value: DatabaseService().triviaEvents,
          child: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Card(
                margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 25.0,
                    backgroundColor: Colors.brown[100],
                  ),
                  title: Text(event.location),
                  subtitle: Text(event.when.toDate().toString()),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return StreamProvider<List<TriviaEvent>>.value(
                            value: DatabaseService().triviaEvents,
                            child: RoundList(
                              user: user,
                              eventID: eventID,
                            ));
                      },
                    ));
                  },
                ),
              )));
    } else {
      return Container();
    }
  }
}
