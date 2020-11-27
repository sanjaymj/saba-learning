import 'package:flutter/material.dart';
import 'package:sabalearning/models/SabaWord.dart';
import 'package:sabalearning/widgets/saba-text-label.dart';

class SearchImpl extends SearchDelegate {
  String selectedResult;
  String translatedResult;
  List<SabaWord> recent = [];
  List<String> filters = ['verb'];
  var items;
  SearchImpl(this.items);

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: SabaTextLabel(selectedResult, 40.0),
          ),
          SizedBox(height: 12.0),
          Center(child: SabaTextLabel(translatedResult, 30.0)),
        ]);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var suggestions = [];
    if (query.isNotEmpty) {
      items.forEach((item) => {
            if (item.originalWord.contains(query)) {suggestions.add(item)}
          });
    }

    /*query.isEmpty
        ? suggestions = recent
        : suggestions.addAll(
            items.where((element) => element.originalWord.contains(query)));*/

    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return ListTile(
              title: Text(suggestions[index].originalWord),
              onTap: () {
                selectedResult = suggestions[index].originalWord;
                translatedResult = suggestions[index].translatedWord;
                showResults(context);
              });
        });
  }
}
