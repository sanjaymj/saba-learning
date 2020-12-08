import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SabaInputField extends StatelessWidget {
  final Function callback;
  final String labelText;
  final Function onsubmitCallback;
  final bool isPassword;

  SabaInputField(
      this.labelText, this.isPassword, this.callback, this.onsubmitCallback);
  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
        attribute: "word",
        obscureText: this.isPassword,
        decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: Color(0xfff3f3f4),
            filled: true,
            labelText: this.labelText),
        validators: [
          FormBuilderValidators.required(),
          FormBuilderValidators.max(70),
        ],
        onChanged: (val) {
          this.callback(val);
        },
        onFieldSubmitted: (val) {
          this.onsubmitCallback(val);
        });
  }
}
