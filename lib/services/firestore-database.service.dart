import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sabalearning/models/SabaWord.dart';
import 'package:sabalearning/models/WordPair.dart';
import 'package:sabalearning/utils/database-keys.dart';

class FirestoreDatabaseService {
  addNewSabaWordToCollection(String userId, SabaWord word) async {
    CollectionReference users = FirebaseFirestore.instance.collection(userId);
    var existingWordsCollection =
        (await users.doc(DatabaseKeys.WORD_KEY).get()).data();

    if (existingWordsCollection == null ||
        existingWordsCollection[DatabaseKeys.WORD_KEY] == null) {
      existingWordsCollection = new Map();
      existingWordsCollection[DatabaseKeys.WORD_KEY] = [];
    }

    existingWordsCollection[DatabaseKeys.WORD_KEY].add(word.toJson());
    _addToFirestore(userId, DatabaseKeys.WORD_KEY, existingWordsCollection);
  }

  Future addNewWordOfTheDayToCollectionIfNecessary(
      String userId, Future<WordPair> pair) async {
    var currentWord = await pair;
    CollectionReference users = FirebaseFirestore.instance.collection(userId);

    var existingWordOfTheCollectionForUser =
        (await users.doc(DatabaseKeys.WORD_OF_THE_DAY_KEY).get()).data();

    if (existingWordOfTheCollectionForUser == null ||
        existingWordOfTheCollectionForUser[DatabaseKeys.WORD_KEY] == null) {
      existingWordOfTheCollectionForUser = new Map();
      existingWordOfTheCollectionForUser[DatabaseKeys.WORD_KEY] = [];
    }

    var addToDatabase = _isWordOfTheDayAlreadyAddedForCurrentDay(
        existingWordOfTheCollectionForUser);

    if (addToDatabase) {
      existingWordOfTheCollectionForUser[DatabaseKeys.WORD_KEY]
          .add(currentWord.toJson());

      _addToFirestore(userId, DatabaseKeys.WORD_OF_THE_DAY_KEY,
          existingWordOfTheCollectionForUser);
    }
  }

  Future<List<SabaWord>> getAllWordsForCurrentUser(String uid) async {
    CollectionReference users = FirebaseFirestore.instance.collection(uid);
    var wordsInDatabase = (await users.doc(DatabaseKeys.WORD_KEY).get()).data();

    if (wordsInDatabase == null ||
        wordsInDatabase[DatabaseKeys.WORD_KEY] == null) {
      wordsInDatabase = new Map();
      return [];
    }

    var wordsToReturn = new List<SabaWord>();

    var word = await wordsInDatabase[DatabaseKeys.WORD_KEY];
    word.forEach((val) => wordsToReturn.add(SabaWord.fromJson(val)));

    return wordsToReturn;
  }

  _isWordOfTheDayAlreadyAddedForCurrentDay(existingWordOfTheCollectionForUser) {
    existingWordOfTheCollectionForUser[DatabaseKeys.WORD_KEY].forEach((item) {
      if (WordPair.fromJson(item).creationDate ==
          DateTime.now().day.toString() +
              DateTime.now().month.toString() +
              DateTime.now().year.toString()) {
        return true;
      }
    });
    return false;
  }

  _addToFirestore(userId, docName, existingWordOfTheCollectionForUser) async {
    await FirebaseFirestore.instance
        .collection(userId)
        .doc(docName)
        .update(existingWordOfTheCollectionForUser);
  }
}
