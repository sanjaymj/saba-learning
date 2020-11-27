import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';
import 'package:sabalearning/exceptions/saba-exceptions.dart';
import 'package:sabalearning/models/LocalStorageDTO.dart';
import 'package:sabalearning/models/SabaWord.dart';
import 'package:sabalearning/models/WordPair.dart';
import 'package:sabalearning/services/firestore-database.service.dart';
import 'package:sabalearning/utils/database-keys.dart';

class LocalStorageService {
  LocalStorageDTO storage = new LocalStorageDTO();
  final WORD_KEY = "words";
  final WORD_OF_THE_DAY_KEY = "wod";
  final LocalStorage localStorage = new LocalStorage('saba.json');

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
    if (localStorage.getItem(WORD_KEY) == null) {
      List<SabaWord> words = await this.getStoredWordsFromFirestore(userId);
      saveWordsToLocalStorage(words);
    }
    return localStorage.getItem(WORD_KEY);
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
    var val = await users.doc(WORD_KEY).get();
    var data = val.data();
    if (data == null || data[WORD_KEY] == null) {
      data = new Map();
      return [];
    }

    var values = new List<SabaWord>();

    var word = await data[WORD_KEY];

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
      } else {
        categoriesForCurrentUser = await FirestoreDatabaseService()
            .getAllCategoriesForCurrentUser(userId);
      }
      return categoriesForCurrentUser;
    }
  }

  WordPair readWordPairFromStorage() {
    if (localStorage.getItem(WORD_OF_THE_DAY_KEY) == null) {
      return new WordPair();
    }
    return WordPair.fromJson(localStorage.getItem(WORD_OF_THE_DAY_KEY));
  }

  saveWordOfTheDayToLocalStorage(WordPair item) {
    localStorage.ready
        .then((_) => localStorage.setItem(WORD_OF_THE_DAY_KEY, item));
  }

  saveWordsToLocalStorage(List<SabaWord> words) {
    localStorage.ready.then((_) => localStorage.setItem(WORD_KEY, words));
  }

  saveCategoriesToLocalStorage(words) {
    localStorage.ready
        .then((_) => localStorage.setItem(DatabaseKeys.CATEGORIES_KEY, words));
  }

  Future<void> addNewWordToLocalStorage(SabaWord word) async {
    clearLocalStorage();
    var words;
    var isDuplicate = false;
    await localStorage.ready;
    words = localStorage.getItem(WORD_KEY);

    words.forEach((val) => {
          if (val['originalWord'] == word.originalWord) {isDuplicate = true}
        });
    if (!isDuplicate) {
      words.add(word.toJson());
      localStorage.setItem(WORD_KEY, words);
    } else {
      throw Exception("This is the error");
    }
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
    var found = false;
    await localStorage.ready;
    words = localStorage.getItem(DatabaseKeys.WORD_KEY);

    words.forEach((val) => {
          if (val['originalWord'] == originalWord)
            {
              val['isUnknown'] =
                  val['isUnknown'] == null ? true : !val['isUnknown'],
              found = true
            }
        });
    if (found) {
      localStorage.setItem(DatabaseKeys.WORD_KEY, words);
    } else {
      throw new Exception();
    }
  }

  _toggleUnknownWordInfireStore(String userId, String originalWord) {
    FirestoreDatabaseService().toggleUnknownWord(userId, originalWord);
  }
}