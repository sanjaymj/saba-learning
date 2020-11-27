import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:sabalearning/models/SabaWord.dart';
import 'package:sabalearning/models/user.dart';
import 'package:sabalearning/services/firestore-database.service.dart';
import 'package:sabalearning/services/local-storage.service.dart';
import 'package:sabalearning/services/translate.service.dart';
import 'package:sabalearning/widgets/primary-button.dart';
import 'package:sabalearning/widgets/secondary-button.dart';
import 'package:sabalearning/widgets/snackbar.dart';

class AddNewWord extends StatefulWidget {
  @override
  _AddNewWord createState() => _AddNewWord();
}

class _AddNewWord extends State<AddNewWord> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  LocalStorageService localstorage = new LocalStorageService();
  bool automaticTranslation = true;
  bool newCategoryTextFieldVisible = false;
  SabaWord testWord = new SabaWord();
  String newCategory;
  final globalKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    var snackbarText;

    var categories = localstorage.getStoredCategoriesForCurrentuser(user.uid);
    test() async {
      if (this.testWord.originalWord == null) {
        snackbarText = 'Cannot add empty word. Please enter a new word here!!';
        showSnackBar(snackbarText, context);
      } else {
        try {
          if (this.testWord.translatedWord == null) {
            var translatedWord = await Translate()
                .translateWord(this.testWord.originalWord, 'de', 'en');
            this.testWord.translatedWord = translatedWord;
          }

          if (this.testWord.category == null) {
            this.testWord.category = [];
          }
          FirestoreDatabaseService()
              .addNewSabaWordToCollection(user.uid, this.testWord);
          await localstorage.addNewWordToLocalStorage(this.testWord);
          snackbarText = 'Added ${testWord.originalWord} to word collection';

          showSnackBar(snackbarText, context);
        } catch (e) {
          snackbarText = 'Unable to add new word!!';
          showSnackBar(snackbarText, context);
        }
      }
    }

    toggleTranslation(isEnabled) {
      setState(() {
        this.automaticTranslation = isEnabled;
      });
    }

    updateWordToAdd(isEnabled) {
      setState(() {
        this.testWord.originalWord = isEnabled;
      });
    }

    updateCategory(isEnabled) {
      this.testWord.category = isEnabled.cast<String>();
    }

    updateTranslation(translatedWord) {
      setState(() {
        this.testWord.translatedWord = translatedWord;
      });
    }

    toggleCategoryTextBox() {
      setState(() {
        this.newCategoryTextFieldVisible = true;
      });
    }

    updateInDB() {
      setState(() {
        this.newCategoryTextFieldVisible = false;
      });
    }

    addNewCategory(newCategory) async {
      setState(() async {
        if (newCategory != "") {
          try {
            this.newCategory = newCategory;
            await localstorage.saveCategory(user.uid, this.newCategory);
          } catch (e) {
            showSnackBar("Failed to add new category", context);
          }
        }
      });
    }

    List<Widget> children;
    children = <Widget>[
      FormBuilderTextField(
          attribute: "word",
          decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
              labelText: "Enter new word here"),
          validators: [
            FormBuilderValidators.required(),
            FormBuilderValidators.max(70),
          ],
          onChanged: (val) {
            updateWordToAdd(val);
          }),
      Column(children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          FutureBuilder(
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
                      child: GestureDetector(
                        child: FormBuilderFilterChip(
                            attribute: "wordCategory",
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "Select categories"),
                            options: dummy(snapshot.data),
                            onChanged: (val) {
                              updateCategory(val);
                            }),
                        onLongPress: () {
                          print('LONG PRESSED');
                        },
                      ),
                    );
              }
            },
          ),
          Visibility(
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  toggleCategoryTextBox();
                },
              ),
              visible: !this.newCategoryTextFieldVisible),
          Visibility(
              child: IconButton(
                icon: Icon(Icons.check_circle),
                onPressed: () {
                  updateInDB();
                },
              ),
              visible: this.newCategoryTextFieldVisible)
        ]),
        Visibility(
            child: FormBuilderTextField(
                attribute: "newCategory",
                decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Color(0xfff3f3f4),
                    filled: true,
                    labelText: "Enter new category"),
                validators: [
                  FormBuilderValidators.max(70),
                ],
                onFieldSubmitted: (val) {
                  addNewCategory(val);
                }),
            visible: this.newCategoryTextFieldVisible),
      ]),
      FormBuilderSwitch(
          label: Text('Translate automatically'),
          decoration: InputDecoration(border: InputBorder.none),
          attribute: "automaticTranslation",
          initialValue: this.automaticTranslation,
          onChanged: (val) {
            toggleTranslation(val);
          }),
      Visibility(
          child: FormBuilderTextField(
              attribute: "translatedWord",
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true,
                  labelText: "Enter translated word here"),
              validators: [
                FormBuilderValidators.max(70),
              ],
              onChanged: (val) {
                updateTranslation(val);
              }),
          visible: !this.automaticTranslation),
      PrimaryButton(onButtonClick: () => {test()}, buttonText: 'Submit'),
      SecondaryButton(
          onButtonClick: () => {_fbKey.currentState.reset()},
          buttonText: 'Reset'),
    ];
    return Scaffold(
        key: globalKey,
        appBar: AppBar(title: Text("Add new word")),
        body: FormBuilder(
            key: _fbKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(children: children),
              ),
            )));
  }

  dummy(data) {
    List<FormBuilderFieldOption> widgets = [];
    data.forEach((val) =>
        {widgets.add(FormBuilderFieldOption(child: Text(val), value: val))});
    return widgets;
  }
}
