import 'package:flutter/material.dart';
import 'package:sabalearning/models/SabaWord.dart';
import 'package:sabalearning/models/WordPair.dart';
import 'package:sabalearning/views/learn/add-new-word.dart';
import 'package:sabalearning/views/user-settings/edit.dart';
import 'package:sabalearning/widgets/add-new-word-dialog.dart';

class FloatingActionRefreshButtonWrapper extends StatelessWidget {
  final Function callback;
  FloatingActionRefreshButtonWrapper(this.callback);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FloatingActionButton(
        heroTag: null,
        onPressed: () {
          this.callback();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
