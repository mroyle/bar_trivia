import 'package:bar_trivia/shared/constants.dart';
import 'package:bar_trivia/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:bar_trivia/services/auth.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  String firstName = "";
  String lastName = "";
  String email = "";
  String password = "";
  String error = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[100],
              elevation: 0.0,
              title: Text('Sign up to play Pub Trivia'),
              actions: <Widget>[
                FlatButton.icon(
                    onPressed: () {
                      widget.toggleView();
                    },
                    icon: Icon(Icons.person),
                    label: Text("Sign In"))
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Enter First Name'),
                      validator: (val) =>
                          val.isEmpty ? 'Enter your first name' : null,
                      onChanged: (value) {
                        setState(() => firstName = value);
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Enter Last Name'),
                      validator: (val) =>
                          val.isEmpty ? 'Enter your last name' : null,
                      onChanged: (value) {
                        setState(() => lastName = value);
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Enter Email'),
                      validator: (val) => val.isEmpty ? 'Enter an email' : null,
                      onChanged: (value) {
                        setState(() => email = value);
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Enter Password'),
                      validator: (val) => val.length < 6
                          ? 'Enter a password 6+ characters long'
                          : null,
                      obscureText: true,
                      onChanged: (value) {
                        setState(() => password = value);
                      },
                    ),
                    SizedBox(height: 20),
                    RaisedButton(
                      color: Colors.pink[400],
                      child: Text("Register",
                          style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() => loading = true);
                          dynamic result =
                              await _authService.registerWithEmailAndPassword(
                                  firstName, lastName, email, password);

                          if (result == null) {
                            print("I got an error!");
                            setState(() {
                              loading = false;
                              error =
                                  'please supply a valid email and password';
                            });
                          } else {
                            error = '';
                          }
                        }
                      },
                    ),
                    SizedBox(height: 12),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
