import 'package:bar_trivia/models/user.dart';

class Team {
  final String id;
  final String name;
  final User owner;
  final List<User> members;

  Team({this.id, this.name, this.owner, this.members});
}
