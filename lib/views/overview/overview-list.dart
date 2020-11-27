import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sabalearning/models/SabaWord.dart';
import 'package:sabalearning/models/user.dart';
import 'package:sabalearning/services/local-storage.service.dart';
import 'package:sabalearning/views/overview/overview_bloc.dart';
import 'package:sabalearning/widgets/card-with-buttons.dart';
import 'package:sabalearning/widgets/snackbar.dart';

class OverviewListView extends StatelessWidget {
  LocalStorageService service = new LocalStorageService();
  List<SabaWord> values = [];
  List<dynamic> filters = [];
  var user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);

    return FutureBuilder(
      future: this.service.getAllWordsForCurrentUser(user.uid),
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
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    this.filters = Provider.of<OverviewBloc>(context, listen: false).filters;
    if (snapshot != null) {
      values = snapshot.data;
      Provider.of<OverviewBloc>(context).values = values;
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

    favoriteWordCallback(originalWord) async {
      try {
        await this.service.favoriteWord(user.uid, originalWord);
        showSnackBar(
            "$originalWord has been marked set/unset as favorite ", context);
      } catch (e) {
        showSnackBar("Failed to set/unset $originalWord as favorite", context);
      }
    }

    unknownWordCallback(originalWord) async {
      try {
        await this.service.toggleUnknownWord(user.uid, originalWord);
        showSnackBar("$originalWord has been set/unset as unknown ", context);
      } catch (e) {
        showSnackBar("Failed to set/unset $originalWord as unknown", context);
      }
    }

    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: values.length,
        itemBuilder: (context, index) {
          return Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              height: isVisible(values[index].category, filters) ? 150 : 0,
              width: double.maxFinite,
              child: Visibility(
                  visible: isVisible(values[index].category, filters),
                  child: CardWithButtons(values[index], favoriteWordCallback,
                      unknownWordCallback)));
        });
  }
}
