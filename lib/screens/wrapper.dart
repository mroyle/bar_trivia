import 'package:bar_trivia/screens/authenticate/authenticate.dart';
import 'package:bar_trivia/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bar_trivia/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user);
    if (user == null) {
      return Authenticate();
    } else {
      return Home(user: user);
    }
  }
}
