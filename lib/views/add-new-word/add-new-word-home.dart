import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:sabalearning/models/SabaWord.dart';
import 'package:sabalearning/models/user.dart';
import 'package:sabalearning/services/local-storage.service.dart';
import 'package:sabalearning/services/translate.service.dart';
import 'package:sabalearning/views/add-new-word/add-new-word-change-notifier.dart';
import 'package:sabalearning/views/add-new-word/category-list.dart';
import 'package:sabalearning/views/add-new-word/saba-filter-chip.dart';
import 'package:sabalearning/views/add-new-word/saba-input-field.dart';
import 'package:sabalearning/widgets/primary-button.dart';
import 'package:sabalearning/widgets/secondary-button.dart';
import 'package:sabalearning/widgets/snackbar.dart';

class AddNewWordHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddNewWordChangeNotifier>(
      create: (context) => AddNewWordChangeNotifier(),
      child: NewWordWidgetWrapper(),
    );
  }
}

class NewWordWidgetWrapper extends StatelessWidget {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  List<dynamic> filters = [];
  SabaWord wordToAdd = new SabaWord();
  LocalStorageService localstorage;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    localstorage = new LocalStorageService(user.uid);
    final newWordMenuNotifier =
        Provider.of<AddNewWordChangeNotifier>(context, listen: false);

    var snackbarText;
    submit() async {
      if (this.wordToAdd.originalWord == null ||
          this.wordToAdd.originalWord == "") {
        snackbarText = 'Cannot add empty word. Please enter a new word here!!';
        showSnackBar(snackbarText, context);
      } else {
        try {
          if (this.wordToAdd.translatedWord == null ||
              this.wordToAdd.translatedWord == "") {
            var langPair = await localstorage.getLanguagePairForUser(user.uid);
            var translatedWord = await Translate().translateWord(
                this.wordToAdd.originalWord,
                langPair['target'],
                langPair['source']);
            this.wordToAdd.translatedWord = translatedWord;
          }

          if (this.wordToAdd.category == null) {
            this.wordToAdd.category = [];
          }
          await localstorage.addNewWord(user.uid, this.wordToAdd);
          snackbarText = 'Added ${wordToAdd.originalWord} to word collection';

          showSnackBar(snackbarText, context);
        } catch (e) {
          snackbarText = 'Unable to add new word!!';
          showSnackBar(snackbarText, context);
        }
      }
    }

    updateOriginalWord(val) {
      this.wordToAdd.originalWord = val;
    }

    updateCategory(filters) {
      this.wordToAdd.category = filters.cast<String>();
      this.filters = filters;
    }

    createNewCategory(newCategory) async {
      if (newCategory == null || newCategory == "") {
        showSnackBar("cannot add empty category", context);
      } else {
        try {
          await localstorage.saveCategory(user.uid, newCategory);
          newWordMenuNotifier.isAddNewCategory = false;
        } catch (e) {
          showSnackBar("Failed to add new category", context);
        }
      }
    }

    deleteCategory(category) async {
      try {
        await localstorage.deleteCategory(user.uid, category);
        newWordMenuNotifier.isAddNewCategory = false;
        showSnackBar("Deleted category $category", context);
      } catch (e) {
        showSnackBar("Failed to delete new category", context);
      }
    }

    showNewCategoryField() {
      newWordMenuNotifier.isAddNewCategory =
          !newWordMenuNotifier.isAddNewCategory;
    }

    addManualTranslation(translatedWord) {
      newWordMenuNotifier.isAutomaticTranslation = false;
      this.wordToAdd.translatedWord = translatedWord;
    }

    List<Widget> children;
    children = <Widget>[
      SabaInputField("enter new word", false, updateOriginalWord, null),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        CategoryList(updateCategory, deleteCategory),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            showNewCategoryField();
          },
        ),
      ]),
      AddNewCategory(createNewCategory),
      AutomaticTranslationSwitch(),
      TranslationText(addManualTranslation),
      SizedBox(height: 100.0),
      //Expanded(child: Container()),
      PrimaryButton(onButtonClick: submit, buttonText: 'Submit'),
      SizedBox(height: 10.0),
      SecondaryButton(
          onButtonClick: () => {_fbKey.currentState.reset()},
          buttonText: 'Reset'),
    ];
    return Container(
      //decoration: backgroundDecoration,
      child: FormBuilder(
          key: _fbKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(children: children)),
            ),
          )),
    );
  }
}

class AddNewCategory extends StatelessWidget {
  final Function callback;
  AddNewCategory(this.callback);

  @override
  Widget build(BuildContext context) {
    final newWordMenuNotifier = Provider.of<AddNewWordChangeNotifier>(context);

    return Visibility(
        child: SabaInputField("enter new category", false, null, this.callback),
        visible: newWordMenuNotifier.isAddNewCategory);
  }
}

class AutomaticTranslationSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final newWordMenuNotifier = Provider.of<AddNewWordChangeNotifier>(context);
    return FormBuilderSwitch(
        label: Text('Translate automatically'),
        decoration: InputDecoration(border: InputBorder.none),
        attribute: "automaticTranslation",
        initialValue: newWordMenuNotifier.isAutomaticTranslation,
        onChanged: (val) {
          newWordMenuNotifier.isAutomaticTranslation = val;
        });
  }
}

class TranslationText extends StatelessWidget {
  final Function callback;

  TranslationText(this.callback);
  @override
  Widget build(BuildContext context) {
    final newWordMenuNotifier = Provider.of<AddNewWordChangeNotifier>(context);
    return Visibility(
        child: SabaInputField("enter translation", false, null, this.callback),
        visible: !newWordMenuNotifier.isAutomaticTranslation);
  }
}
