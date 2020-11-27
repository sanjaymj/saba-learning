import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sabalearning/exceptions/saba-exceptions.dart';
import 'package:sabalearning/models/SabaWord.dart';
import 'package:sabalearning/models/WordPair.dart';
import 'package:sabalearning/models/user.dart';
import 'package:sabalearning/services/firestore-database.service.dart';
import 'package:sabalearning/services/local-storage.service.dart';
import 'package:sabalearning/services/random-word-generator.dart';
import 'package:sabalearning/widgets/floating-action-button-wrapper.dart';
import 'package:sabalearning/widgets/floating-action-refresh-button.dart';
import 'package:sabalearning/widgets/snackbar.dart';

class WordOfTheDay extends StatefulWidget {
  LocalStorageService localstorage = new LocalStorageService();
  bool ignoreTimeStamp = false;
  @override
  _WordOfTheDayState createState() => _WordOfTheDayState();
}

class _WordOfTheDayState extends State<WordOfTheDay> {
  @override
  Widget build(BuildContext context) {
    //widget.localstorage.clearLocalStorage();
    final user = Provider.of<User>(context);
    var translatedGermanWord;
    RandomWordGenerator rd = new RandomWordGenerator();
    translatedGermanWord = rd.generateRandomWordPair(widget.ignoreTimeStamp);

    FirestoreDatabaseService().addNewWordOfTheDayToCollectionIfNecessary(
        user.uid, translatedGermanWord);

    addWordOftheDayToMyWordsList(WordPair createdWord) async {
      SabaWord word = new SabaWord();
      word.originalWord = createdWord.germanWord;
      word.translatedWord = createdWord.englishWord;
      word.category = [];
      var snackbarText;
      FirestoreDatabaseService().addNewSabaWordToCollection(user.uid, word);
      //widget.localstorage.addNewWordToLocalStorage(word);

      try {
        await widget.localstorage.addNewWordToLocalStorage(word);
        snackbarText = 'Added ${word.originalWord} to word collection';
        showSnackBar(snackbarText, context);
        widget.ignoreTimeStamp = false;
      } catch (e) {
        snackbarText = 'Unable to add ${word.originalWord} to word collection';
        showSnackBar(snackbarText, context);
      }
    }

    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline2,
      textAlign: TextAlign.center,
      child: FutureBuilder<WordPair>(
        future: translatedGermanWord,
        builder: (BuildContext context, AsyncSnapshot<WordPair> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Word of the day: ${snapshot.data.germanWord}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Roboto',
                        letterSpacing: 0.5,
                        fontSize: 30,
                      ),
                    ),
                    Container(
                      height: 40.0,
                    ),
                    Text(
                      '${snapshot.data.englishWord}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Roboto',
                        letterSpacing: 0.5,
                        fontSize: 40,
                      ),
                    ),
                    Container(height: 40.0),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          FloatingActionButtonWrapper(
                              addWordOftheDayToMyWordsList, snapshot.data),
                          FloatingActionRefreshButtonWrapper(
                            () => {
                              setState(() {
                                widget.ignoreTimeStamp = true;
                              })
                            },
                          ),
                        ]),
                  ],
                ),
              ),
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            children = <Widget>[
              SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              )
            ];
          }
          return Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: children,
              ));
        },
      ),
    );
  }
}
