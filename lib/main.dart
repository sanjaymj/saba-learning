import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sabalearning/models/user.dart';
import 'package:sabalearning/services/firebase-auth.service.dart';
import 'package:sabalearning/views/auth-wrapper.dart';
import 'package:sabalearning/views/home.dart';

import 'bloc/user-authentication-bloc.dart';

void main() {
  runApp(MyApp());
}

final FirebaseAuth auth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<UserAuthenticationBloc>(
        create: (context) => UserAuthenticationBloc()),
      StreamProvider<User>.value(
        value: FirebaseAuthService().user,
        )
      ],
      child: MaterialApp(
        home: AuthWrapper(),
      )
    );
  }
}