import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sabalearning/models/SabaWord.dart';
import 'package:sabalearning/models/user.dart';
import 'package:sabalearning/services/local-storage.service.dart';
import 'package:sabalearning/views/overview/overview_bloc.dart';
import 'package:sabalearning/views/overview/word-filter-options.dart';
import 'package:sabalearning/widgets/card-with-buttons.dart';
import 'package:sabalearning/widgets/search-item.dart';
import 'package:sabalearning/widgets/snackbar.dart';

/*class OverviewHome extends StatefulWidget {
  LocalStorageService service = new LocalStorageService();
  List<dynamic> filters = [];
  List<SabaWord> values = [];
  @override
  _OverviewHomeState createState() => _OverviewHomeState();
}

class _OverviewHomeState extends State<OverviewHome> {
  var user;
  updateFilters(val) {
    setState(() {
      widget.filters.add(val);
    });
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);

    var futureBuilder = (val) => new FutureBuilder(
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
                  return createListView(context, snapshot, val);
            }
          },
        );

    return Scaffold(
        appBar: AppBar(actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context, delegate: SearchImpl(widget.values));
              }),
        ], centerTitle: true, title: Text('search')),
        body: SingleChildScrollView(
            child: Column(children: [
          WordFilterOptions(updateFilters, widget.filters),
          futureBuilder(widget.filters)
        ])));
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot, val) {
    if (snapshot != null) {
      widget.values = snapshot.data;
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
        await widget.service.favoriteWord(user.uid, originalWord);
        showSnackBar(
            "$originalWord has been marked set/unset as favorite ", context);
      } catch (e) {
        showSnackBar("Failed to set/unset $originalWord as favorite", context);
      }
    }

    unknownWordCallback(originalWord) async {
      try {
        await widget.service.toggleUnknownWord(user.uid, originalWord);
        showSnackBar("$originalWord has been set/unset as unknown ", context);
      } catch (e) {
        showSnackBar("Failed to set/unset $originalWord as unknown", context);
      }
    }

    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.values.length,
        itemBuilder: (context, index) {
          return Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              height: isVisible(widget.values[index].category, val) ? 150 : 0,
              width: double.maxFinite,
              child: Visibility(
                  visible: isVisible(widget.values[index].category, val),
                  child: CardWithButtons(widget.values[index],
                      favoriteWordCallback, unknownWordCallback)));
        });
  }
}*/

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

class OverviewHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<OverviewBloc>(
      create: (context) => OverviewBloc(),
      child: OverviewWrapper(),
    );
  }
}

class SabaWordListRenderer extends StatelessWidget {
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
    this.filters = Provider.of<OverviewBloc>(context).filters;

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

class OverviewWrapper extends StatelessWidget {
  LocalStorageService service = new LocalStorageService();
  List<dynamic> filters = [];
  List<SabaWord> values = [];

  var user;
  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);

    updateFilters(val) {
      final val1 = Provider.of<OverviewBloc>(context, listen: false);
      val1.filters = val;
    }

    return Scaffold(
      appBar: AppBar(actions: <Widget>[
        IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: SearchImpl(this.values));
            }),
      ], centerTitle: true, title: Text('search')),
      body: SingleChildScrollView(
          child: Column(children: [
        WordFilterOptions(updateFilters, this.filters),
        SabaWordListRenderer(),
      ])),
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot != null) {
      this.values = snapshot.data;
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
        itemCount: this.values.length,
        itemBuilder: (context, index) {
          return Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              height: isVisible(this.values[index].category, filters) ? 150 : 0,
              width: double.maxFinite,
              child: Visibility(
                  visible: isVisible(this.values[index].category, filters),
                  child: CardWithButtons(this.values[index],
                      favoriteWordCallback, unknownWordCallback)));
        });
  }
}
