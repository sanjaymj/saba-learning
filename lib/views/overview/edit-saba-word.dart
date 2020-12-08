import 'package:flutter/material.dart';
import 'package:sabalearning/models/SabaWord.dart';
import 'package:sabalearning/widgets/primary-button.dart';

class EditSabaWord extends StatelessWidget {
  final SabaWord word;
  final Function onSaveCallback;

  EditSabaWord(this.word, this.onSaveCallback);

  @override
  Widget build(BuildContext context) {
    getcategoryAsString(List<String> categories) {
      var categoriesString = "";
      categories
          .forEach((val) => {categoriesString = categoriesString + val + ','});

      // remove final ',' character
      return categoriesString.length != 0
          ? categoriesString.substring(0, categoriesString.length - 1)
          : categoriesString;
    }

    return AlertDialog(
      scrollable: true,
      title: Text(
        word.originalWord,
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
                      helperText: "translated word"),
                  initialValue: word.translatedWord,
                  onChanged: (val) {
                    word.translatedWord = val;
                    //this.onTranslationTextChanged(val);
                  }),
              TextFormField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.subject),
                      hintText: "categories",
                      helperMaxLines: 2,
                      helperText:
                          "Add new categories following a comma if necessary."),
                  initialValue: getcategoryAsString(word.category),
                  onChanged: (val) {
                    // sanity checks: make textbox tolerant for unwanted space characters provided by user
                    word.category = val.replaceAll(" ", "").split(",");
                    //this.onCategoryChanged(val);
                  }),
              TextFormField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.note_add),
                      hintText: "add extra information",
                      helperMaxLines: 2,
                      helperText: "additional information related to word"),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  initialValue: word.additionalInfo,
                  onChanged: (val) {
                    word.additionalInfo = val;
                    //this.onadditionalInfoChanged(val);
                  }),
            ],
          ),
        ),
      ),
      actions: [
        PrimaryButton(
            onButtonClick: () => {this.onSaveCallback(word)},
            buttonText: 'Save Changes')
      ],
    );
  }
}
