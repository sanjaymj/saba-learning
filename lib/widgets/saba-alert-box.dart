import 'package:flutter/material.dart';

class SabaAlertBox extends StatelessWidget {
  final String title;
  final String message;

  SabaAlertBox(this.title, this.message);
  @override
  Widget build(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    return AlertDialog(
      title: Text(this.title),
      content: Text(this.message),
      actions: [
        okButton,
      ],
    );
  }
}
