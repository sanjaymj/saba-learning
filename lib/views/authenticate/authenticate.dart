import 'package:flutter/material.dart';
import 'package:sabalearning/views/authenticate/constants.dart';
import 'package:sabalearning/views/authenticate/forgot-password.dart';
import 'package:sabalearning/views/authenticate/register.dart';
import 'package:sabalearning/views/authenticate/sign-in.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  AuthenticationScreenToRender activeScreen =
      AuthenticationScreenToRender.LOGIN;

  void toggleView(val) {
    setState(() {
      this.activeScreen = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.activeScreen == AuthenticationScreenToRender.LOGIN) {
      return SignIn(toggleView: toggleView);
    } else if (this.activeScreen == AuthenticationScreenToRender.REGISTER) {
      return Register(toggleView: toggleView);
    } else {
      return ForgotPassword(toggleView: toggleView);
    }
  }
}
