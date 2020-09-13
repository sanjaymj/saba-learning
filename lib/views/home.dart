import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sabalearning/models/user.dart';
import 'package:sabalearning/services/firebase-auth.service.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuthService _auth = new FirebaseAuthService();
    return StreamProvider<User>.value(
      value: FirebaseAuthService().user,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child: AppBar(
                title: Text('Test'),
                elevation: 0.0,
                actions: <Widget>[
                  FlatButton.icon(
                    onPressed: () async {
                      await _auth.signOut();
                    }, 
                    icon: Icon(Icons.person), 
                    label: Text('Sign Out'))
                ],
              ))),
    );
  }
}