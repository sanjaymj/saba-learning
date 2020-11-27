import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sabalearning/models/SabaWord.dart';
import 'package:sabalearning/models/user.dart';
import 'package:sabalearning/services/local-storage.service.dart';
import 'package:sabalearning/views/overview/overview-list.dart';
import 'package:sabalearning/views/overview/overview_bloc.dart';
import 'package:sabalearning/views/overview/search-bar.dart';
import 'package:sabalearning/views/overview/word-filter-options.dart';
import 'package:sabalearning/widgets/search-item.dart';

class OverViewHomeTemp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OverviewBloc>(
      create: (context) => OverviewBloc(),
      child: OverviewWrapper(),
    );
  }
}

class OverviewWrapper extends StatelessWidget {
  LocalStorageService service = new LocalStorageService();
  List<dynamic> filters = [];

  var user;
  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);

    updateFilters(val) {
      final val1 = Provider.of<OverviewBloc>(context, listen: false);
      val1.filters = val;
    }

    return Scaffold(
      //appBar: SearchBar(),
      body: SingleChildScrollView(
          child: Column(children: [
        WordFilterOptions(updateFilters, this.filters),
        OverviewListView(),
      ])),
    );
  }
}
