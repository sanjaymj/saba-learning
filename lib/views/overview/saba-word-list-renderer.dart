import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sabalearning/models/SabaWord.dart';
import 'package:sabalearning/models/user.dart';
import 'package:sabalearning/services/local-storage.service.dart';
import 'package:sabalearning/views/overview/edit-saba-word.dart';
import 'package:sabalearning/views/overview/overview_bloc.dart';
import 'package:sabalearning/widgets/card-with-buttons.dart';
import 'package:sabalearning/widgets/primary-button.dart';
import 'package:sabalearning/widgets/snackbar.dart';

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
      Provider.of<OverviewBloc>(context).values = values;
    }
    isVisible(arr1, arr2, word) {
      if (word.isUnknown == true) {
        return false;
      }
      Set<String> vals = new Set<String>();
      if (arr2.length == 0) {
        return true;
      }

      // show favorite words. Hacky implementation
      if (arr2.contains("favorites")) {
        if (word.isFavorite) {
          return true;
        }
      }

      if (arr1.length == 0) {
        return false;
      }

      arr1.forEach((val1) => {vals.add(val1)});
      arr2.forEach((val2) => {vals.add(val2)});

      return vals.length != arr1.length + arr2.length;
    }

    favoriteWordCallback(originalWord) async {
      try {
        await this.service.favoriteWord(user.uid, originalWord);
        showSnackBar("$originalWord has been set/unset as favorite ", context);
      } catch (e) {
        showSnackBar("Failed to set/unset $originalWord as favorite", context);
      }
    }

    updateFilters() {
      final val1 = Provider.of<OverviewBloc>(context, listen: false);
      val1.filters = this.filters;
    }

    deleteWordCallback(originalWord) {
      showAlertDialog(BuildContext context) {
        // set up the buttons
        Widget cancelButton = FlatButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        );
        Widget continueButton = FlatButton(
          child: Text("yes"),
          onPressed: () async {
            try {
              await this.service.toggleUnknownWord(user.uid, originalWord);
              showSnackBar("$originalWord has been deleted ", context);
              updateFilters();
              Navigator.pop(context);
            } catch (e) {
              showSnackBar("Failed to delete $originalWord", context);
            }
          },
        );

        // set up the AlertDialog
        AlertDialog alert = AlertDialog(
          title: Text("Delete word"),
          content: Text("Are you sure you want to delete $originalWord?"),
          actions: [
            cancelButton,
            continueButton,
          ],
        );

        // show the dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      }

      showAlertDialog(context);
    }

    getcategoryAsString(List<String> categories) {
      var categoriesString = "";
      categories
          .forEach((val) => {categoriesString = categoriesString + val + ' '});
      return categoriesString;
    }

    saveChanges(sabaWord) async {
      try {
        await this.service.updateWord(user.uid, sabaWord);
        Navigator.pop(context);
        showSnackBar("updated ${sabaWord.originalWord}", context);
        updateFilters();
      } catch (e) {
        showSnackBar("Failed to update ${sabaWord.originalWord}", context);
      }
    }

    moreInfoButtonCallback(SabaWord sabaWord) async {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return EditSabaWord(sabaWord, saveChanges);
          });
      /*showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              scrollable: true,
              title: Text(
                sabaWord.originalWord,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.g_translate),
                            hintText: "translated word",
                          ),
                          initialValue: sabaWord.translatedWord,
                          onChanged: (val) {
                            sabaWord.translatedWord = val;
                          }),
                      TextFormField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.subject),
                            hintText: "categories",
                          ),
                          initialValue: getcategoryAsString(
                            sabaWord.category,
                          ),
                          onChanged: (val) {
                            sabaWord.category = val.split(' ');
                          }),
                      TextFormField(
                          decoration: InputDecoration(
                            icon: Icon(Icons.note_add),
                            hintText: "add extra information",
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          initialValue: sabaWord.additionalInfo,
                          onChanged: (val) {
                            sabaWord.additionalInfo = val;
                          }),
                    ],
                  ),
                ),
              ),
              actions: [
                PrimaryButton(
                    onButtonClick: () => saveChanges(sabaWord),
                    buttonText: 'Save Changes')
              ],
            );
          });*/
    }

    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: values.length,
        itemBuilder: (context, index) {
          return Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              height: isVisible(values[index].category, filters, values[index])
                  ? 150
                  : 0,
              width: double.maxFinite,
              child: Visibility(
                  visible:
                      isVisible(values[index].category, filters, values[index]),
                  child: CardWithButtons(values[index], favoriteWordCallback,
                      deleteWordCallback, moreInfoButtonCallback)));
        });
  }
}
