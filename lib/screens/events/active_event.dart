import 'package:bar_trivia/models/answer.dart';
import 'package:bar_trivia/models/question.dart';
import 'package:bar_trivia/services/database.dart';
import 'package:flutter/material.dart';
import 'package:bar_trivia/models/user.dart';
import 'package:bar_trivia/models/trivia_event.dart';
import 'package:provider/provider.dart';
import 'package:bar_trivia/shared/constants.dart';

class ActiveEvent extends StatefulWidget {
  final User user;
  final String eventID;

  ActiveEvent({this.eventID, this.user});

  @override
  _ActiveEventState createState() => _ActiveEventState();
}

class _ActiveEventState extends State<ActiveEvent> {
  String answer = "";

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
                label: Text("Logout"),
                onPressed: () async {})
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
    Question currentQuestion = Question();
    event.rounds.forEach((round) {
      round.questions.forEach((question) {
        if (question.hasBeenAsked) {
          currentQuestion = question;
        }
      });
    });

    if (currentQuestion.hasUserAnswered(widget.user.uid)) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 150),
            Text(currentQuestion.text),
            SizedBox(height: 60),
            Text(currentQuestion.getAnswerFor(widget.user.uid)),
            SizedBox(height: 60),
            RaisedButton(
                child: Text('Change Answer'),
                onPressed: () {
                  currentQuestion.deleteAnswer(widget.user.uid);
                  DatabaseService().updateEvent(event);
                })
          ]);
    } else {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 150),
            Text(currentQuestion.text),
            SizedBox(height: 60),
            TextFormField(
              decoration:
                  textInputDecoration.copyWith(hintText: 'Enter Your Answer'),
              onChanged: (value) {
                setState(() => answer = value);
              },
            ),
            SizedBox(height: 20),
            RaisedButton(
                child: Text('Submit'),
                onPressed: () {
                  print(currentQuestion);
                  currentQuestion.answers
                      .add(Answer(playerID: widget.user.uid, text: answer));
                  DatabaseService().updateEvent(event);
                })
          ]);
    }
  }
}
