import 'package:flutter/material.dart';

void showSnackBar(String displayText, BuildContext context) {
  final scaffold = Scaffold.of(context);
  scaffold.showSnackBar(
    SnackBar(content: Text(displayText)),
  );
}
