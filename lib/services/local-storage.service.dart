import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localstorage/localstorage.dart';
import 'package:sabalearning/models/LocalStorageDTO.dart';
import 'package:sabalearning/models/SabaWord.dart';
import 'package:sabalearning/models/WordPair.dart';

class LocalStorageService {
  LocalStorageDTO storage = new LocalStorageDTO();
  final WORD_KEY = "words";
  final WORD_OF_THE_DAY_KEY = "wod";
  final LocalStorage localStorage = new LocalStorage('saba.json');

  getAllWordsForCurrentUser(String userId) async {
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
    word.forEach((val) => values.add(SabaWord.fromJson(val)));

    return values;
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

  clearLocalStorage() {
    localStorage.clear();
  }
}
