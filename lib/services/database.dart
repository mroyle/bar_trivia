import 'package:bar_trivia/models/question.dart';
import 'package:bar_trivia/models/round.dart';
import 'package:bar_trivia/models/team_name.dart';
import 'package:bar_trivia/models/trivia_event.dart';
import 'package:bar_trivia/models/team.dart';
import 'package:bar_trivia/models/user.dart';
import 'package:bar_trivia/models/answer.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      Firestore.instance.collection('users');
  final CollectionReference triviaEventCollection =
      Firestore.instance.collection('trivia_events');
  final CollectionReference teamsCollection =
      Firestore.instance.collection('teams');

  User getUserByID(String userID) {
    return User(uid: userID);
  }

  Future getUserData(User user) async {
    DocumentSnapshot snap = await userCollection.document(user.uid).get();
    return User(
        uid: user.uid,
        firstName: snap.data['first_name'],
        lastName: snap.data['last_name'],
        isAdmin: snap.data['isAdmin'],
        isModerator: snap.data['isModerator'],
        hasBeenUpdated: snap.data['hasBeenUpdated']);
  }

  Future updateUserData(User user) async {
    return await userCollection.document(uid).setData({
      'first_name': user.firstName,
      'last_namne': user.lastName,
      'isAdmin': user.isAdmin,
      'isModerator': user.isModerator,
      "hasBeenUpdated": user.hasBeenUpdated
    });
  }

  List<TriviaEvent> _trivaEventListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((document) {
      return TriviaEvent(
        id: document.documentID,
        location: document.data['location'],
        when: document.data['when'],
        isActive: document.data['isActive'] == null
            ? false
            : document.data['isActive'],
        rounds: document.data['rounds'] == null
            ? List<Round>()
            : List.castFrom(document.data['rounds']).map((value) {
                Map<dynamic, dynamic> values = Map.castFrom(value);
                return Round(
                    number: values['number'],
                    isActive: values['isActive'],
                    theme: values['theme'],
                    isComplete: values['isComplete'],
                    questions: values['questions'] == null
                        ? List<Question>()
                        : List.castFrom(values['questions']).map((value) {
                            Map<dynamic, dynamic> values = Map.castFrom(value);
                            return Question(
                                text: values['text'],
                                answer: values['answer'],
                                hasBeenAsked: values['has_been_asked'],
                                answers: values['answers'] == null
                                    ? List<Answer>()
                                    : List.castFrom(values['answers'])
                                        .map((answerValue) {
                                        Map<dynamic, dynamic> answerValues =
                                            Map.castFrom(answerValue);
                                        return Answer(
                                            playerID: answerValues['player_id'],
                                            text: answerValues['text'],
                                            isCorrect:
                                                answerValues['is_correct']);
                                      }).toList());
                          }).toList());
              }).toList(),
        teamNames: document.data["team_names"] == null
            ? List<TeamName>()
            : List.castFrom(document.data["team_names"].map((value) {
                Map<dynamic, dynamic> values = Map.castFrom(value);
                print(values['team_name']);
                return TeamName(
                    userID: values['user_id'], teamName: values['team_name']);
              }).toList()),
      );
    }).toList();
  }

  Future updateEvent(TriviaEvent event) async {
    return await triviaEventCollection.document(event.id).setData({
      'location': event.location,
      'when': event.when,
      'isActive': event.isActive,
      'rounds': event.rounds.map((round) {
        return {
          'number': round.number,
          'theme': round.theme,
          'isActive': round.isActive,
          'isComplete': round.isComplete,
          'questions': round.questions.map((question) {
            return {
              'text': question.text,
              'answer': question.answer,
              'has_been_asked': question.hasBeenAsked,
              'answers': question.answers.map((answer) {
                return {
                  'player_id': answer.playerID,
                  'text': answer.text,
                  'is_correct': answer.isCorrect
                };
              }).toList()
            };
          }).toList()
        };
      }).toList(),
      'team_names': event.teamNames.map((name) {
        print(name.teamName);
        return {"user_id": name.userID, "team_name": name.teamName};
      }).toList()
    });
  }

  Stream<List<TriviaEvent>> get triviaEvents {
    return triviaEventCollection.snapshots().map(_trivaEventListFromSnapshot);
  }

  List<Team> _teamListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((document) {
      return Team(
          id: document.documentID,
          name: document.data['name'],
          owner: User(uid: document.data['owner']),
          members: List.from(document.data['members'])
              .map((id) => User(uid: id))
              .toList());
    }).toList();
  }

  Stream<List<Team>> get teams {
    return teamsCollection.snapshots().map(_teamListFromSnapshot);
  }

  void updateTeam(Team team) async {
    List<String> members = team.members.map((user) => user.uid).toList();
    DocumentReference dr = teamsCollection.document(team.id);
    print(team.owner);
    print(team.name);
    return await dr.setData(
        {'name': team.name, 'owner': team.owner.uid, 'members': members});
  }

  void resetData() {
    triviaEventCollection.getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.delete();
      }
    });
    Timestamp eventtime = Timestamp.fromDate(
        Timestamp.now().toDate().add(new Duration(hours: 4)));
    updateEvent(TriviaEvent(
      location: 'Seawolf',
      when: eventtime,
      isActive: false,
      teamNames: [
        TeamName(teamName: "House on Fire", userID: "1"),
        TeamName(teamName: "Brain Dump", userID: "2")
      ],
      rounds: [
        Round(
            number: 1,
            theme: "History",
            isActive: true,
            isComplete: false,
            questions: [
              Question(
                text: "What was Alexander the Great's horse's name?",
                answer: "Buchephalus",
                hasBeenAsked: true,
                answers: [
                  Answer(playerID: "2", text: "Buchephalus", isCorrect: true),
                  Answer(playerID: "1", text: "Horse", isCorrect: false)
                ],
              ),
              Question(
                text: "What year was Julius Caesar assassinated?",
                answer: "44 BC",
                hasBeenAsked: true,
                answers: [
                  Answer(
                      playerID: "2", text: "Fourty Four BC", isCorrect: false),
                  Answer(playerID: "1", text: "44 BC", isCorrect: true)
                ],
              ),
              Question(
                text: "What was the first state?",
                answer: "Deleware",
                hasBeenAsked: true,
                answers: [
                  Answer(playerID: "2", text: "Deleware", isCorrect: true),
                  Answer(playerID: "1", text: "Deleware", isCorrect: true)
                ],
              ),
            ]),
        Round(
            number: 2,
            theme: "Pop Culture",
            isActive: false,
            isComplete: false,
            questions: [
              Question(
                text: "In which city was Jim Morrison buried?",
                answer: "Paris",
                hasBeenAsked: false,
                answers: List<Answer>(),
              ),
              Question(
                text: "How much does the Chewbacca costume weigh?",
                answer: "8 pounds",
                hasBeenAsked: false,
                answers: List<Answer>(),
              ),
              Question(
                text: "Which name is rapper Sean Combs better known by?",
                answer: "P. Diddy",
                hasBeenAsked: false,
                answers: List<Answer>(),
              ),
            ]),
        Round(
            number: 3,
            theme: "Science",
            isActive: false,
            isComplete: false,
            questions: [
              Question(
                text: "Hg is the chemical symbol of which element?",
                answer: "Mercury",
                hasBeenAsked: false,
                answers: List<Answer>(),
              ),
              Question(
                text: "Pure water as a pH level of around?",
                answer: "7",
                hasBeenAsked: false,
                answers: List<Answer>(),
              ),
              Question(
                text: "What’s the hardest rock?",
                answer: "Diamond",
                hasBeenAsked: false,
                answers: List<Answer>(),
              ),
            ])
      ],
    ));
  }
}
