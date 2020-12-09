import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localstorage/localstorage.dart';
import 'package:sabalearning/models/SabaWord.dart';
import 'package:sabalearning/models/WordPair.dart';
import 'package:sabalearning/services/firestore-database.service.dart';
import 'package:sabalearning/utils/database-keys.dart';

class LocalStorageService {
  LocalStorage localStorage;
  LocalStorageService(String userId) {
    localStorage = new LocalStorage(userId + '.json');
  }

  getAllWordsForCurrentUser(String userId) async {
    //clearLocalStorage();
    var wordsForCurrentUser = new List<SabaWord>();
    var isStorageReady = await this.isStorageReady();

    if (isStorageReady) {
      var wordsFromStorage = await this.getStoredDataFromStorage(userId);
      if (wordsFromStorage != null && wordsFromStorage.length > 0) {
        wordsFromStorage.forEach(
            (word) => wordsForCurrentUser.add(SabaWord.fromJson(word)));
      } else {
        wordsForCurrentUser = await this.getStoredWordsFromFirestore(userId);
      }
      return wordsForCurrentUser;
    }
  }

  Future<bool> isStorageReady() async {
    var isReady = await this.localStorage.ready;
    return isReady;
  }

  getStoredDataFromStorage(String userId) async {
    if (localStorage.getItem(DatabaseKeys.WORD_KEY) == null) {
      List<SabaWord> words = await this.getStoredWordsFromFirestore(userId);
      saveWordsToLocalStorage(words);
    }
    return localStorage.getItem(DatabaseKeys.WORD_KEY);
  }

  getCategoriesFromStorage(String userId) async {
    if (localStorage.getItem(DatabaseKeys.CATEGORIES_KEY) == null) {
      var categories = await FirestoreDatabaseService()
          .getAllCategoriesForCurrentUser(userId);
      saveCategoriesToLocalStorage(categories);
    }

    return localStorage.getItem(DatabaseKeys.CATEGORIES_KEY);
  }

  Future<List<SabaWord>> getStoredWordsFromFirestore(String uid) async {
    CollectionReference users = FirebaseFirestore.instance.collection(uid);
    var val = await users.doc(DatabaseKeys.WORD_KEY).get();
    var data = val.data();
    if (data == null || data[DatabaseKeys.WORD_KEY] == null) {
      data = new Map();
      return [];
    }

    var values = new List<SabaWord>();

    var word = await data[DatabaseKeys.WORD_KEY];

    word.forEach((val) => {values.add(SabaWord.fromJson(val))});
    return values;
  }

  getStoredCategoriesForCurrentuser(String userId) async {
    var categoriesForCurrentUser = new List<String>();
    var isStorageReady = await this.isStorageReady();

    if (isStorageReady) {
      var categoriesFromStorage = await this.getCategoriesFromStorage(userId);

      if (categoriesFromStorage != null && categoriesFromStorage.length > 0) {
        categoriesFromStorage
            .forEach((word) => categoriesForCurrentUser.add(word));
      }
      return categoriesForCurrentUser;
    }
  }

  WordPair readWordPairFromStorage() {
    if (localStorage.getItem(DatabaseKeys.WORD_OF_THE_DAY_KEY) == null) {
      return new WordPair();
    }
    return WordPair.fromJson(
        localStorage.getItem(DatabaseKeys.WORD_OF_THE_DAY_KEY));
  }

  saveWordOfTheDayToLocalStorage(WordPair item) {
    localStorage.ready.then(
        (_) => localStorage.setItem(DatabaseKeys.WORD_OF_THE_DAY_KEY, item));
  }

  saveWordsToLocalStorage(List<SabaWord> words) {
    localStorage.ready
        .then((_) => localStorage.setItem(DatabaseKeys.WORD_KEY, words));
  }

  saveCategoriesToLocalStorage(words) {
    localStorage.ready
        .then((_) => localStorage.setItem(DatabaseKeys.CATEGORIES_KEY, words));
  }

  addNewWord(String userId, SabaWord word) async {
    try {
      await this._addNewWordToLocalStorage(word);
      this._addNewWordInFireStore(userId, word);
    } catch (e) {
      throw new Exception();
    }
  }

  Future<void> _addNewWordToLocalStorage(SabaWord word) async {
    var words;
    var isDuplicate = false;
    await localStorage.ready;
    words = localStorage.getItem(DatabaseKeys.WORD_KEY);

    if (words == null) {
      words = [];
      words.add(word.toJson());
      localStorage.setItem(DatabaseKeys.WORD_KEY, words);
    } else {
      words.forEach((val) => {
            if (val['originalWord'] == word.originalWord) {isDuplicate = true}
          });
      if (!isDuplicate) {
        words.add(word.toJson());
        localStorage.setItem(DatabaseKeys.WORD_KEY, words);
      } else {
        throw Exception("This is the error");
      }
    }
  }

  _addNewWordInFireStore(String userId, SabaWord word) async {
    FirestoreDatabaseService().addNewSabaWordToCollection(userId, word);
  }

  clearLocalStorage() {
    localStorage.clear();
  }

  saveCategory(String userId, String newCategory) async {
    try {
      await this._saveCategoryInStorage(userId, newCategory);
      this._saveCategoryInFireStore(userId, newCategory);
    } catch (e) {
      throw new Exception();
    }
  }

  _saveCategoryInStorage(String userId, String newCategory) async {
    var words;
    var isDuplicate = false;
    await localStorage.ready;
    words = localStorage.getItem(DatabaseKeys.CATEGORIES_KEY);
    words.forEach((val) => {
          if (words.contains(newCategory)) {isDuplicate = true}
        });
    if (!isDuplicate) {
      words.add(newCategory);
      localStorage.setItem(DatabaseKeys.CATEGORIES_KEY, words);
    } else {
      throw new Exception();
    }
  }

  _saveCategoryInFireStore(String userId, String newCategory) {
    FirestoreDatabaseService().addNewWordCategory(userId, newCategory);
  }

  favoriteWord(String userId, String originalWord) async {
    try {
      await this._toggleFavoriteWordInStorage(originalWord);
      this._toggleFavoriteWordInfireStore(userId, originalWord);
    } catch (e) {
      throw new Exception();
    }
  }

  _toggleFavoriteWordInStorage(String originalWord) async {
    var words;
    var found = false;
    await localStorage.ready;
    words = localStorage.getItem(DatabaseKeys.WORD_KEY);

    words.forEach((val) => {
          if (val['originalWord'] == originalWord)
            {
              val['isFavorite'] =
                  val['isFavorite'] == null ? true : !val['isFavorite'],
              found = true
            }
        });
    if (found) {
      localStorage.setItem(DatabaseKeys.WORD_KEY, words);
    } else {
      throw new Exception();
    }
  }

  _toggleFavoriteWordInfireStore(String userId, String originalWord) {
    FirestoreDatabaseService().toggleFavoriteWord(userId, originalWord);
  }

  updateWord(String userId, SabaWord originalWord) async {
    try {
      await this._updateWordInStorage(originalWord);
      this._updateWordInfireStore(userId, originalWord);
    } catch (e) {
      throw new Exception();
    }
  }

  _updateWordInStorage(SabaWord originalWord) async {
    var words;
    var found = false;
    await localStorage.ready;
    words = localStorage.getItem(DatabaseKeys.WORD_KEY);

    words.forEach((val) => {
          if (val['originalWord'] == originalWord.originalWord)
            {
              val['translatedWord'] = originalWord.translatedWord,
              val['category'] = originalWord.category,
              val['additionalInfo'] = originalWord.additionalInfo,
              found = true
            }
        });
    if (found) {
      localStorage.setItem(DatabaseKeys.WORD_KEY, words);
    } else {
      throw new Exception();
    }
  }

  _updateWordInfireStore(String userId, SabaWord originalWord) {
    FirestoreDatabaseService().updateWord(userId, originalWord);
  }

  toggleUnknownWord(String userId, String originalWord) async {
    try {
      await this._toggleUnknownWordInStorage(originalWord);
      this._toggleUnknownWordInfireStore(userId, originalWord);
    } catch (e) {
      throw new Exception();
    }
  }

  _toggleUnknownWordInStorage(String originalWord) async {
    var words;
    var filteredWords;
    await localStorage.ready;
    words = localStorage.getItem(DatabaseKeys.WORD_KEY);

    filteredWords =
        words.where((val) => val['originalWord'] != originalWord).toList();

    if (filteredWords.length != words.length) {
      localStorage.setItem(DatabaseKeys.WORD_KEY, filteredWords);
    } else {
      throw new Exception();
    }
  }

  _toggleUnknownWordInfireStore(String userId, String originalWord) {
    FirestoreDatabaseService().toggleUnknownWord(userId, originalWord);
  }

  getLanguagePairForUser(userId) async {
    var isStorageReady = await this.isStorageReady();

    if (isStorageReady) {
      var wordsFromStorage = await this.getlanguagePairFromStorage(userId);

      return wordsFromStorage;
    }
  }

  getlanguagePairFromFirestore(String uid) async {
    CollectionReference users = FirebaseFirestore.instance.collection(uid);
    var val = await users.doc(DatabaseKeys.PREFERRED_LANGUAGES_KEY).get();
    var data = val.data();
    if (data == null) {
      data = new Map();
      return [];
    }
    return data;
  }

  getlanguagePairFromStorage(String userId) async {
    //if (localStorage.getItem(DatabaseKeys.PREFERRED_LANGUAGES_KEY) == null) {
    var pair = await this.getlanguagePairFromFirestore(userId);
    await saveLanguagePairToLocalStorage(pair);
    //}
    return localStorage.getItem(DatabaseKeys.PREFERRED_LANGUAGES_KEY);
  }

  saveLanguagePairToLocalStorage(words) {
    localStorage.ready.then((_) =>
        localStorage.setItem(DatabaseKeys.PREFERRED_LANGUAGES_KEY, words));
  }

  deleteCategory(String userId, String newCategory) async {
    try {
      await this._deleteCategoryInStorage(userId, newCategory);
      this._deleteCategoryInFireStore(userId, newCategory);
    } catch (e) {
      throw new Exception();
    }
  }

  _deleteCategoryInStorage(String userId, String newCategory) async {
    var words;
    var found = false;
    await localStorage.ready;
    words = localStorage.getItem(DatabaseKeys.CATEGORIES_KEY);
    words.forEach((val) => {
          if (val == newCategory) {found = true}
        });

    if (!found) {
      throw new Exception();
    } else {
      words.remove(newCategory);
      localStorage.setItem(DatabaseKeys.CATEGORIES_KEY, words);
    }
  }

  _deleteCategoryInFireStore(String userId, String newCategory) {
    FirestoreDatabaseService().deleteWordCategory(userId, newCategory);
  }
}
