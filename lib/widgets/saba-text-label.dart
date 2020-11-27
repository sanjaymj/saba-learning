import 'package:flutter/material.dart';

class SabaTextLabel extends StatelessWidget {
  final String displayText;
  final double fontSize;
  SabaTextLabel(this.displayText, this.fontSize);
  @override
  Widget build(BuildContext context) {
    return Text(
      displayText,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w800,
        fontFamily: 'Roboto',
        letterSpacing: 0.5,
        fontSize: fontSize,
      ),
    );
  }
}
