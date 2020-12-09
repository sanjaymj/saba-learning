import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sabalearning/models/SabaWord.dart';
import 'package:sabalearning/models/user.dart';
import 'package:sabalearning/services/local-storage.service.dart';
import 'package:sabalearning/utils/background-decoration.dart';
import 'package:sabalearning/views/overview/overview_bloc.dart';
import 'package:sabalearning/views/overview/saba-word-list-renderer.dart';
import 'package:sabalearning/views/overview/word-filter-options.dart';
import 'package:sabalearning/widgets/card-with-buttons.dart';
import 'package:sabalearning/widgets/primary-button.dart';
import 'package:sabalearning/widgets/search-item.dart';
import 'package:sabalearning/widgets/snackbar.dart';

class OverviewHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OverviewBloc>(
      create: (context) => OverviewBloc(),
      child: Container(
        //decoration: backgroundDecoration,
        child: OverviewWrapper(),
      ),
    );
  }
}

class OverviewWrapper extends StatelessWidget {
  LocalStorageService service;
  List<dynamic> filters = [];
  List<SabaWord> values = [];

  var user;
  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    service = new LocalStorageService(user.uid);
    final val1 = Provider.of<OverviewBloc>(context, listen: false);
    updateFilters(val) {
      val1.filters = val;
    }

    searchRender() {
      //final val1 = Provider.of<OverviewBloc>(context, listen: false);

      showSearch(context: context, delegate: SearchImpl(val1.values));
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blueAccent[700],
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  searchRender();
                }),
          ],
          centerTitle: true,
          title: Text('search')),
      body: Container(
        //decoration: backgroundDecoration,
        child: SingleChildScrollView(
            child: Column(children: [
          WordFilterOptions(updateFilters, this.filters),
          SabaWordListRenderer(),
        ])),
      ),
    );
  }
}
