import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:sabalearning/models/SabaWord.dart';
import 'package:sabalearning/models/user.dart';
import 'package:sabalearning/services/firebase-auth.service.dart';
import 'package:sabalearning/services/firestore-database.service.dart';

class AddNewWord extends StatefulWidget {
  @override
  _AddNewWord createState() => _AddNewWord();
}

class _AddNewWord extends State<AddNewWord> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  bool automaticTranslation = true;
  SabaWord testWord = new SabaWord();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    test() {
      FirestoreDatabaseService()
          .addNewSabaWordToCollection(user.uid, this.testWord);
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
      setState(() {
        this.testWord.category = isEnabled.cast<String>();
      });
    }

    updateTranslation(isEnabled) {
      setState(() {
        this.testWord.translatedWord = isEnabled;
      });
    }

    List<Widget> children;
    children = <Widget>[
      FormBuilderTextField(
          attribute: "word",
          decoration: InputDecoration(labelText: "Enter new word here"),
          validators: [
            FormBuilderValidators.required(),
            FormBuilderValidators.max(70),
          ],
          onChanged: (val) {
            updateWordToAdd(val);
          }),
      FormBuilderFilterChip(
          attribute: "wordCategory",
          options: [
            FormBuilderFieldOption(child: Text("Verb"), value: "verb"),
            FormBuilderFieldOption(child: Text("Noun"), value: "noun"),
            FormBuilderFieldOption(
                child: Text("Adjective"), value: "adjective"),
            FormBuilderFieldOption(child: Text("Travel"), value: "travel"),
          ],
          onChanged: (val) {
            updateCategory(val);
          }),
      FormBuilderSwitch(
          label: Text('Translate automatically'),
          attribute: "automaticTranslation",
          initialValue: this.automaticTranslation,
          onChanged: (val) {
            toggleTranslation(val);
          }),
      Visibility(
          child: FormBuilderTextField(
              attribute: "translatedWord",
              decoration:
                  InputDecoration(labelText: "Enter translated word here"),
              validators: [
                FormBuilderValidators.max(70),
              ],
              onChanged: (val) {
                updateTranslation(val);
              }),
          visible: !this.automaticTranslation),
      Row(
        children: [
          MaterialButton(
            child: Text("Submit"),
            onPressed: () {
              if (_fbKey.currentState.saveAndValidate()) {
                print(_fbKey.currentState.value);
                test();
              }
            },
          ),
          MaterialButton(
            child: Text("Reset"),
            onPressed: () {
              _fbKey.currentState.reset();
            },
          ),
        ],
      )
    ];
    return Scaffold(
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
}
