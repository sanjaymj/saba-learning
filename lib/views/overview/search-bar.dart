import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sabalearning/models/SabaWord.dart';
import 'package:sabalearning/views/overview/overview_bloc.dart';
import 'package:sabalearning/widgets/search-item.dart';

class SearchBar extends StatelessWidget implements PreferredSizeWidget {
  List<SabaWord> values;
  @override
  Widget build(BuildContext context) {
    this.values = Provider.of<OverviewBloc>(context).values;
    return AppBar(actions: <Widget>[
      IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            showSearch(context: context, delegate: SearchImpl(this.values));
          }),
    ], centerTitle: true, title: Text('search'));
  }

  @override
  Size get preferredSize => new Size.fromHeight(50);
}
