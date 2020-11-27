import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SabaFilterChip extends StatelessWidget {
  final Function onPressCallback;
  final Function onLongPressCallback;
  final data;

  SabaFilterChip(this.data, this.onPressCallback, this.onLongPressCallback);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: FormBuilderFilterChip(
          attribute: "wordCategory",
          decoration: InputDecoration(
              border: InputBorder.none,
              helperMaxLines: 3,
              helperText:
                  "Select categories. Click on + to add new categories. Long press to delete categories"),
          options: buildAllFilterChips(data),
          onChanged: (val) {
            this.onPressCallback(val);
          }),
    );
  }

  buildAllFilterChips(data) {
    List<FormBuilderFieldOption> widgets = [];
    data.forEach((val) => {
          widgets.add(FormBuilderFieldOption(
              child: GestureDetector(
                  child: Text(val),
                  onLongPress: () => this.onLongPressCallback(val)),
              value: val))
        });
    return widgets;
  }
}
