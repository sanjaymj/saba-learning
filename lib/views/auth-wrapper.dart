import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sabalearning/models/user.dart';
import 'package:sabalearning/views/welcome/authenticate.dart';
import 'package:sabalearning/views/welcome/sign-in.dart';
import 'package:sabalearning/views/home.dart';
import 'package:sabalearning/views/welcome/welcome-page.dart';

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      return LoginPage();
    }
    return Home();
  }
}
