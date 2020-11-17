import 'package:flutter/material.dart';
import 'package:sabalearning/models/SabaWord.dart';

class SearchImpl extends SearchDelegate {
  String selectedResult;
  List<SabaWord> recent = [];
  List<String> filters = ['verb'];
  final List<SabaWord> items;
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
    return Container(
      child: Center(child: Text(selectedResult)),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<SabaWord> suggestions = [];
    query.isEmpty
        ? suggestions = recent
        : suggestions.addAll(
            items.where((element) => element.originalWord.contains(query)));

    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return ListTile(
              title: Text(suggestions[index].originalWord),
              onTap: () {
                selectedResult = suggestions[index].originalWord;
                showResults(context);
              });
        });
  }
}
