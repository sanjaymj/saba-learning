import 'package:flutter/material.dart';

class AddNewWordDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddNewWordDialog();
}

class _AddNewWordDialog extends State<AddNewWordDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text('Add new Word'),
        content: Stack(overflow: Overflow.visible, children: <Widget>[
          Form(
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Enter Word",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                  onChanged: (String value) {}),
            ),
          ]))
        ]));
  }
}
