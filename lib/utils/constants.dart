import 'package:flutter/material.dart';

class OptionsListContainer {
  static const String Edit = "edit";
  static const String SignOut = "sign out";
  static const List<String> Choices = <String>[Edit, SignOut];
}

const textFieldDecorator = InputDecoration(
    hintText: 'Email',
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2.0)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.pink, width: 2.0)));
