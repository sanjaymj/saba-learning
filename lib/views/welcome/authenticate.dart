import 'package:flutter/material.dart';
import 'package:sabalearning/views/welcome/register.dart';
import 'package:sabalearning/views/welcome/sign-in.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      this.showSignIn = !this.showSignIn;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return LoginPage();
    }
    return Register();
  }
}