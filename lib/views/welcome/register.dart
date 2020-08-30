import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sabalearning/bloc/user-authentication-bloc.dart';
import 'package:sabalearning/services/firebase-auth.service.dart';
import 'package:sabalearning/utils/background-decoration.dart';
import 'package:sabalearning/views/welcome/sign-in.dart';
import 'package:sabalearning/widgets/app-title.dart';
import 'package:sabalearning/widgets/input-text-box.dart';
import 'package:sabalearning/widgets/primary-button.dart';

class Register extends StatefulWidget {
  Register({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<Register> {

  UserAuthenticationBloc userAuthenticationBloc;
    final FirebaseAuthService _auth = new FirebaseAuthService();


  void primaryButtonClickCallback() async{
    await _auth.registerWithEmailAndPassword(this.userAuthenticationBloc.userName, this.userAuthenticationBloc.password);
  }

  void onUsernameChangedCallback(val) {
    this.userAuthenticationBloc.userName = val;
  }

  void onPasswordChangedCallback(val) {
    this.userAuthenticationBloc.password = val;
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        InputTextField(title: 'Email_ID', isPassword: false, onChange: onUsernameChangedCallback),
        InputTextField(title: 'Password', isPassword: true, onChange: onPasswordChangedCallback),
      ],
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
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
                  PrimaryButton(onButtonClick: this.primaryButtonClickCallback, buttonText: 'Register'),
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