import 'package:flutter/material.dart';
import 'package:sabalearning/views/learn/add-new-word.dart';
import 'package:sabalearning/views/user-settings/edit.dart';
import 'package:sabalearning/widgets/add-new-word-dialog.dart';

class FloatingActionButtonWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddNewWord()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
