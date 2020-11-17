import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class WordFilterOptions extends StatelessWidget {
  final Function callback;

  WordFilterOptions({this.callback});
  @override
  Widget build(BuildContext context) {
    return FormBuilderFilterChip(
        attribute: "wordCategory",
        options: [
          FormBuilderFieldOption(child: Text("Verb"), value: "verb"),
          FormBuilderFieldOption(child: Text("Noun"), value: "noun"),
          FormBuilderFieldOption(child: Text("Adjective"), value: "adjective"),
          FormBuilderFieldOption(child: Text("Travel"), value: "travel"),
        ],
        onChanged: (val) {
          this.callback(val);
        });
  }
}
