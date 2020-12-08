import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sabalearning/services/firebase-auth.service.dart';
import 'package:sabalearning/utils/background-decoration.dart';
import 'package:sabalearning/utils/loading.dart';
import 'package:sabalearning/views/authenticate/constants.dart';
import 'package:sabalearning/widgets/app-title.dart';
import 'package:sabalearning/widgets/primary-button.dart';
import 'package:sabalearning/widgets/saba-alert-box.dart';
import 'package:sabalearning/widgets/saba-input-field.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FirebaseAuthService _auth = new FirebaseAuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String displayName = '';
  String targetLang = '';
  String sourceLang = '';
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
                      SizedBox(height: 50),
                      _emailAndPasswordWidget(),
                      SizedBox(
                        height: 20,
                      ),
                      FormBuilderRadioGroup(
                        decoration:
                            new InputDecoration(labelText: "I want to learn"),
                        validators: [FormBuilderValidators.required()],
                        options: ["French", "Spanish", "German", "Italian"]
                            .map((lang) => FormBuilderFieldOption(value: lang))
                            .toList(growable: false),
                        onChanged: onSourceLangChangedCallback,
                        attribute: null,
                      ),
                      //SizedBox(height: 20),
                      Expanded(child: Container()),
                      PrimaryButton(
                          onButtonClick: this.primaryButtonClickCallback,
                          buttonText: 'Register'),
                      SizedBox(height: 12.0),
                      _accountAlreadyExistsLabel(),
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
        SizedBox(
          height: 20,
        ),
        SabaInputField('display name', Icon(Icons.perm_identity), false,
            onDisplayNameChangedCallback, null),
      ],
    );
  }

  Widget _accountAlreadyExistsLabel() {
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
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
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

  void onPasswordChangedCallback(val) {
    this.password = val;
  }

  void onDisplayNameChangedCallback(val) {
    this.displayName = val;
  }

  void onSourceLangChangedCallback(val) {
    switch (val) {
      case "German":
        this.targetLang = "de";
        break;
      case "Spanish":
        this.targetLang = "es";
        break;
      case "Italian":
        this.targetLang = "it";
        break;
      case "French":
        this.targetLang = "fr";
        break;
      default:
        this.targetLang = "de";
    }
    // translate only to english for now
    this.sourceLang = "en";
  }

  void primaryButtonClickCallback() async {
    var alertBoxTitle = "Invalid SignUp";
    var alertBoxMessage = "Failed to Register. Please try again";

    if (_formKey.currentState.validate()) {
      setState(() => isLoading = true);
      dynamic result = await _auth.registerWithEmailAndPassword(this.email,
          this.password, this.displayName, this.sourceLang, this.targetLang);
      if (result == null) {
        setState(() => {
              isLoading = false,
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SabaAlertBox(
                    alertBoxTitle,
                    alertBoxMessage,
                  );
                },
              )
            });
      }
    }
  }
}
