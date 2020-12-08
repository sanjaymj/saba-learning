import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SabaInputField extends StatelessWidget {
  final Function onChangedCallback;
  final String hintText;
  final Icon icon;
  final Function onsubmitCallback;
  final bool isPassword;

  SabaInputField(this.hintText, this.icon, this.isPassword,
      this.onChangedCallback, this.onsubmitCallback);
  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
        attribute: "word",
        obscureText: this.isPassword,
        decoration: InputDecoration(
            icon: this.icon,
            hintText: this.hintText,
            labelStyle: new TextStyle(color: const Color(0xFF424242))),
        validators: [
          FormBuilderValidators.required(),
          //FormBuilderValidators.max(70),
        ],
        onChanged: (val) {
          this.onChangedCallback(val);
        },
        onFieldSubmitted: (val) {
          this.onsubmitCallback(val);
        });
  }
}
