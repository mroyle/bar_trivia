import 'package:bar_trivia/screens/events/round.dart';
import 'package:bar_trivia/screens/events/score.dart';
import 'package:flutter/material.dart';
import 'package:bar_trivia/models/trivia_event.dart';
import 'package:provider/provider.dart';
import 'package:bar_trivia/screens/events/waiting.dart';
import 'package:bar_trivia/screens/events/upcoming_event.dart';
import 'package:bar_trivia/screens/events/active_event.dart';
import 'package:bar_trivia/models/user.dart';
import 'package:bar_trivia/models/round.dart';
import 'package:bar_trivia/models/question.dart';

class Event extends StatefulWidget {
  final String eventID;
  final User user;

  Event({this.eventID, this.user});

  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Event> {
  @override
  Widget build(BuildContext context) {
    final events = Provider.of<List<TriviaEvent>>(context);
    TriviaEvent event = TriviaEvent();

    if (events != null) {
      events.forEach((eventh) {
        if (eventh.id == widget.eventID) {
          event = eventh;
        }
      });
    }
    if ((event == null) || (event.id == null)) {
      return WaitingOnModerator();
    } else {
      if (event.isActive == null) {
        print(event.id);
      }
      if (!event.isActive) {
        print('event not active');
        return UpcomingEvent(eventID: event.id, user: widget.user);
      } else {}
    }
  }
}
