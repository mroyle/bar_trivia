import 'package:bar_trivia/screens/authenticate/authenticate.dart';
import 'package:bar_trivia/screens/home/home.dart';
import 'package:bar_trivia/screens/moderator/moderator_home.dart';
import 'package:bar_trivia/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bar_trivia/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      return Authenticate();
    } else {
      return FutureBuilder<dynamic>(
          future: DatabaseService().getUserData(user),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              User fullUser = snapshot.data;
              if (fullUser.isModerator != null && fullUser.isModerator) {
                return ModeratorHome(user: fullUser);
              } else {
                return Home(user: fullUser);
              }
            }
          });
      return Container();
    }
  }
}
