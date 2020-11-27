import 'package:flutter/material.dart';
import 'package:sabalearning/services/firebase-auth.service.dart';
import 'package:sabalearning/utils/background-decoration.dart';
import 'package:sabalearning/utils/loading.dart';
import 'package:sabalearning/views/authenticate/constants.dart';
import 'package:sabalearning/widgets/app-title.dart';
import 'package:sabalearning/widgets/primary-button.dart';
import 'package:sabalearning/widgets/saba-alert-box.dart';
import 'package:sabalearning/widgets/saba-input-field.dart';

class ForgotPassword extends StatefulWidget {
  final Function toggleView;

  ForgotPassword({this.toggleView});
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final FirebaseAuthService _auth = new FirebaseAuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String error = '';
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
                      SabaInputField('email', Icon(Icons.email), false,
                          onUsernameChangedCallback, null),
                      Expanded(child: Container()),
                      PrimaryButton(
                          onButtonClick: this.primaryButtonClickCallback,
                          buttonText: 'Reset password'),
                      SizedBox(height: 20.0),
                      _createAccountLabel()
                    ]))),
          ));
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () async {
        await widget.toggleView(AuthenticationScreenToRender.LOGIN);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Sign-In',
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

  void primaryButtonClickCallback() async {
    var alertBoxTitle = "Password reset";
    var alertBoxSuccessMessage =
        "Password rest link has been sent via email. Please reset your passwor";
    var alertBoxFailureMessage =
        "No account found with given email address. Please try again";
    if (_formKey.currentState.validate()) {
      setState(() => isLoading = true);
      try {
        dynamic result = await _auth.resetPassword(this.email);
        if (result == null) {
          setState(() => {
                isLoading = false,
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SabaAlertBox(alertBoxTitle, alertBoxSuccessMessage);
                  },
                )
              });
        }
      } catch (e) {
        setState(() => {
              isLoading = false,
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SabaAlertBox(alertBoxTitle, alertBoxFailureMessage);
                },
              )
            });
      }
    }
  }
}
