import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sabalearning/bloc/user-authentication-bloc.dart';
import 'package:sabalearning/services/firebase-auth.service.dart';
import 'package:sabalearning/utils/background-decoration.dart';
import 'package:sabalearning/views/welcome/register.dart';
import 'package:sabalearning/widgets/app-title.dart';
import 'package:sabalearning/widgets/input-text-box.dart';
import 'package:sabalearning/widgets/primary-button.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final FirebaseAuthService _auth = new FirebaseAuthService();
  UserAuthenticationBloc userAuthenticationBloc;

  void primaryButtonClickCallback() async{
    await _auth.signInWithEmailAndPassword(this.userAuthenticationBloc.userName, this.userAuthenticationBloc.password);
  }

  void onUsernameChangedCallback(val) {
    this.userAuthenticationBloc.userName = val;
  }

  void onPasswordChangedCallback(val) {
    this.userAuthenticationBloc.password = val;
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Register()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        InputTextField(title: 'Email_ID', isPassword: false, onChange: onUsernameChangedCallback),
        InputTextField(title: 'Password', isPassword: true, onChange: onPasswordChangedCallback),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    this.userAuthenticationBloc = Provider.of<UserAuthenticationBloc>(context);

    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: height,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: MediaQuery.of(context).size.height,
            decoration: backgroundDecoration,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .2),
                  AppTitle(),
                  SizedBox(height: 50),
                  _emailPasswordWidget(),
                  SizedBox(height: 20),
                PrimaryButton(onButtonClick: this.primaryButtonClickCallback, buttonText: 'Login'),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.centerRight,
                    child: Text('Forgot Password ?',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                  SizedBox(height: height * .055),
                  _createAccountLabel(),
                ],
              ),
            ),
          ),
          //Positioned(top: 40, left: 0, child: CustomBackButton()),
        ],
      ),
    ));
  }
}