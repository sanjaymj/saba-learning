import 'package:flutter/material.dart';
import 'package:sabalearning/models/SabaWord.dart';
import 'package:sabalearning/models/WordPair.dart';
import 'package:sabalearning/views/user-settings/edit.dart';
import 'package:sabalearning/widgets/add-new-word-dialog.dart';

class FloatingActionButtonWrapper extends StatelessWidget {
  final Function callback;
  final WordPair word;
  FloatingActionButtonWrapper(this.callback, this.word);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FloatingActionButton(
        backgroundColor: Colors.blueAccent[700],
        heroTag: null,
        onPressed: () {
          this.callback(this.word);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
