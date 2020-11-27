import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sabalearning/models/user.dart';
import 'package:sabalearning/views/authenticate/authenticate.dart';
import 'package:sabalearning/views/home.dart';

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool isHome = false;
  @override
  Widget build(BuildContext context) {
    test(val) {
      setState(() {
        this.isHome = val;
      });
    }

    final user = Provider.of<User>(context);

    test(user != null);

    if (!this.isHome) {
      return Authenticate();
    }
    return Home();
  }
}
