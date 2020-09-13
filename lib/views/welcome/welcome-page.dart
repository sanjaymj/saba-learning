import 'package:flutter/material.dart';
import 'package:sabalearning/services/firebase-auth.service.dart';
import 'package:sabalearning/utils/background-decoration.dart';
import 'package:sabalearning/views/welcome/register.dart';
import 'package:sabalearning/views/welcome/sign-in.dart';
import 'package:sabalearning/widgets/app-title.dart';
import 'package:sabalearning/widgets/primary-button.dart';
import 'package:sabalearning/widgets/secondary-button.dart';
/* class WelcomePage extends StatefulWidget {
  WelcomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  void secondaryButtonClickCallback() {
    Navigator.push(context,
     MaterialPageRoute(builder: (context) => Register()));
  }

  void primaryButtonClickCallback() {
    Navigator.push(context,
     MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
        child:Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: MediaQuery.of(context).size.height,
            decoration: backgroundDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AppTitle(),
                SizedBox(
                  height: 80,
                ),
                PrimaryButton(onButtonClick: this.primaryButtonClickCallback, buttonText: 'Login'),
                SizedBox(
                  height: 20,
                ),
                SecondaryButton(onButtonClick: this.secondaryButtonClickCallback, buttonText: 'Register'),
                SizedBox(
                  height: 20,
                ),
                
              ],
            ),
          ),
      ),
    );
  }
} */


class WelcomePage extends StatelessWidget {
  WelcomePage({Key key, this.context}) : super(key: key);
    final FirebaseAuthService _auth = new FirebaseAuthService();

  final BuildContext context;

  void secondaryButtonClickCallback() {
    Navigator.push(this.context,
     MaterialPageRoute(builder: (context) => Register()));
  }

  void primaryButtonClickCallback() async{
        //await _auth.signInWithEmailAndPassword('test123@test.com', '123456');

    Navigator.push(this.context,
     MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
        child:Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: MediaQuery.of(context).size.height,
            decoration: backgroundDecoration,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AppTitle(),
                SizedBox(
                  height: 80,
                ),
                PrimaryButton(onButtonClick: this.primaryButtonClickCallback, buttonText: 'Login'),
                SizedBox(
                  height: 20,
                ),
                SecondaryButton(onButtonClick: this.secondaryButtonClickCallback, buttonText: 'Register'),
                SizedBox(
                  height: 20,
                ),
                
              ],
            ),
          ),
      ),
    );
  }
}