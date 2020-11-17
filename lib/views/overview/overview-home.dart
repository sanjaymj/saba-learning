import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sabalearning/models/SabaWord.dart';
import 'package:sabalearning/models/user.dart';
import 'package:sabalearning/services/local-storage.service.dart';
import 'package:sabalearning/views/overview/word-filter-options.dart';
import 'package:sabalearning/widgets/card-with-buttons.dart';
import 'package:sabalearning/widgets/search-item.dart';

class OverviewHome extends StatefulWidget {
  LocalStorageService service = new LocalStorageService();

  @override
  _OverviewHomeState createState() => _OverviewHomeState();
}

class _OverviewHomeState extends State<OverviewHome> {
  List<dynamic> filters = [];
  List<SabaWord> values = [];

  updateFilters(val) {
    setState(() {
      filters = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    var futureBuilder = new FutureBuilder(
      future: widget.service.getAllWordsForCurrentUser(user.uid),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Text('loading...');
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return createListView(context, snapshot);
        }
      },
    );

    return Scaffold(
        appBar: AppBar(actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: SearchImpl(values));
              }),
        ], centerTitle: true, title: Text('search')),
        body: SingleChildScrollView(
            child: Column(children: [
          WordFilterOptions(callback: updateFilters),
          futureBuilder
        ])));
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot != null) {
      values = snapshot.data;
    }
    isVisible(arr1, arr2) {
      Set<String> vals = new Set<String>();
      if (arr2.length == 0 || arr1.length == 0) {
        return true;
      }

      arr1.forEach((val1) => {vals.add(val1)});
      arr2.forEach((val2) => {vals.add(val2)});

      return vals.length != arr1.length + arr2.length;
    }

    return ListView.builder(
        shrinkWrap: true,
        itemCount: values.length,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  height: isVisible(values[index].category, filters) ? 150 : 0,
                  width: double.maxFinite,
                  child: Visibility(
                      visible: isVisible(values[index].category, filters),
                      child: CardWithButtons(values[index].originalWord,
                          values[index].translatedWord))),
            ],
          );
        });
  }
}

/* showAlertDialog(BuildContext context, String additionalInfo) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        print('ok pressed');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("My title"),
      content: FormBuilderTextField(
          attribute: "word",
          decoration: InputDecoration(labelText: additionalInfo),
          onChanged: (val) {
            print(val);
          }),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  } */
