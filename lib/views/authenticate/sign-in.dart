import 'package:flutter/material.dart';
import 'package:sabalearning/services/firebase-auth.service.dart';
import 'package:sabalearning/utils/background-decoration.dart';
import 'package:sabalearning/utils/loading.dart';
import 'package:sabalearning/views/authenticate/constants.dart';
import 'package:sabalearning/widgets/app-title.dart';
import 'package:sabalearning/widgets/primary-button.dart';
import 'package:sabalearning/widgets/saba-alert-box.dart';
import 'package:sabalearning/widgets/saba-input-field.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FirebaseAuthService _auth = new FirebaseAuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return isLoading
        ? Loading()
        : Scaffold(
            body: SingleChildScrollView(
            child: Container(
                decoration: backgroundDecoration,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      SizedBox(height: height * .2),
                      AppTitle(),
                      Expanded(child: Container()),
                      //SizedBox(height: 50),
                      _emailAndPasswordWidget(),
                      //SizedBox(height: 50.0),
                      Expanded(child: Container()),
                      PrimaryButton(
                          onButtonClick: this.primaryButtonClickCallback,
                          buttonText: 'Login'),
                      SizedBox(height: 50.0),
                      _forgotPasswordLabel(),
                      SizedBox(height: height * .055),
                      _createAccountLabel(),
                    ]))),
          ));
  }

  Widget _emailAndPasswordWidget() {
    return Column(
      children: <Widget>[
        SabaInputField(
            'email', Icon(Icons.email), false, onUsernameChangedCallback, null),
        SizedBox(
          height: 20,
        ),
        SabaInputField('password', Icon(Icons.vpn_key), true,
            onPasswordChangedCallback, null),
      ],
    );
  }

  Widget _forgotPasswordLabel() {
    return InkWell(
      onTap: () async {
        await widget.toggleView(AuthenticationScreenToRender.FORGOT_PASSWORD);
      },
      child: Container(
        //margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(5),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Forgot password ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Click here',
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

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () async {
        await widget.toggleView(AuthenticationScreenToRender.REGISTER);
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

  void onUsernameChangedCallback(val) {
    this.email = val;
  }

  void onPasswordChangedCallback(val) {
    this.password = val;
  }

  void primaryButtonClickCallback() async {
    var alertBoxTitle = "Invalid SignIn";
    var alertBoxMessage = "Failed to sign-in. Please try again";
    if (_formKey.currentState.validate()) {
      setState(() => isLoading = true);
      dynamic result =
          await _auth.signInWithEmailAndPassword(this.email, this.password);
      if (result == null) {
        setState(() => {
              isLoading = false,
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SabaAlertBox(alertBoxTitle, alertBoxMessage);
                },
              )
            });
      }
    }
  }
}
