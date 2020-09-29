import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sabalearning/models/user.dart';
import 'package:sabalearning/services/firebase-auth.service.dart';
import 'package:sabalearning/views/auth-wrapper.dart';
import 'package:sabalearning/views/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'bloc/user-authentication-bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


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