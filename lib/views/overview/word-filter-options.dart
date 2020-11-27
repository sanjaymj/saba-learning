import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:sabalearning/models/user.dart';
import 'package:sabalearning/services/local-storage.service.dart';

class WordFilterOptions extends StatelessWidget {
  final Function callback;
  final filters;
  WordFilterOptions(this.callback, this.filters);
  LocalStorageService localstorage = new LocalStorageService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    var categories = localstorage.getStoredCategoriesForCurrentuser(user.uid);
    return FutureBuilder(
      future: categories,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          default:
            if (snapshot.hasError)
              return new Container(width: 0.0, height: 0.0);
            else if (snapshot.data == null)
              return new Container(width: 0.0, height: 0.0);
            else
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: FormBuilderFilterChip(
                    attribute: "wordCategory",
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "filter categories"),
                    options: buildAllFilterChips(snapshot.data),
                    onChanged: (val) {
                      this.callback(val);
                    }),
              );
        }
      },
    );
  }

  buildAllFilterChips(data) {
    List<FormBuilderFieldOption> widgets = [];
    data.forEach((val) =>
        {widgets.add(FormBuilderFieldOption(child: Text(val), value: val))});

    // add a new chip to show favorites
    widgets.add(
        FormBuilderFieldOption(child: Text("favorites"), value: "favorites"));
    return widgets;
  }
}
