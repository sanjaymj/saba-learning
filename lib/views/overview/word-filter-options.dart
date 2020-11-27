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
            return new Text('loading...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: FormBuilderFilterChip(
                    attribute: "wordCategory",
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "Select categories"),
                    options: dummy(snapshot.data),
                    onChanged: (val) {
                      this.callback(val);
                    }),
              );
        }
      },
    );
  }

  dummy(data) {
    List<FormBuilderFieldOption> widgets = [];
    data.forEach((val) =>
        {widgets.add(FormBuilderFieldOption(child: Text(val), value: val))});
    return widgets;
  }
}

/*class WordFilterOptions extends StatefulWidget {
  final Function callback;
  final filters;
  WordFilterOptions(this.callback, this.filters);
  @override
  _WordFilterOptionsState createState() => _WordFilterOptionsState();
}

class _WordFilterOptionsState extends State<WordFilterOptions> {
  LocalStorageService localstorage = new LocalStorageService();
  var categories;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    setState(() {
      categories = localstorage.getStoredCategoriesForCurrentuser(user.uid);
    });

    return FutureBuilder(
      future: categories,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Text('loading...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: FormBuilderFilterChip(
                    attribute: "wordCategory",
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    options: dummy(snapshot.data),
                    initialValue: widget.filters,
                    onChanged: (val) {
                      widget.callback();
                    }),
              );
        }
      },
    );
  }

  dummy(data) {
    List<FormBuilderFieldOption> widgets = [];
    data.forEach((val) =>
        {widgets.add(FormBuilderFieldOption(child: Text(val), value: val))});
    return widgets;
  }
}*/
