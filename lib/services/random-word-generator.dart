import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:sabalearning/models/RandomEnglishWordWrapper.dart';
import 'package:sabalearning/models/RandomGermanWordWrapper.dart';
import 'package:sabalearning/models/WordPair.dart';
import 'package:sabalearning/services/local-storage.service.dart';
import 'package:translator/translator.dart';

class RandomWordGenerator {
  final _chars = 'abcdefghijklmnopqrstuvwxyz';
  final Random _rand = Random();
  static const URI_RANDOM_ENGLISH_WORD = 'https://api.datamuse.com/words?sp=';
  static const URI_EN_DE_TRANSLATION =
      'https://lt-translate-test.herokuapp.com/?langpair=en-de&query=';

  static const MINIMUM_WORD_SCORE = 1000;
  static const MAXIMUM_RANDOM_ENGLISH_WORD_LENGTH = 10;
  static const MINIMUM_RANDOM_ENGLISH_WORD_LENGTH = 4;

  LocalStorageService localStorage = new LocalStorageService();

  Future<String> generateRandomEnglishWord() async {
    List<RandomEnglishWordWrapper> randomEnglishWordsCollection;
    var query = generateRandomParamsForApiRequest();

    while (true) {
      final response = await http.get(URI_RANDOM_ENGLISH_WORD + query);

      randomEnglishWordsCollection = (json.decode(response.body) as List)
          .map((i) => RandomEnglishWordWrapper.fromJson(i))
          .toList();

      if (randomEnglishWordsCollection.first.score > MINIMUM_WORD_SCORE) {
        return randomEnglishWordsCollection.first.word;
      }
    }
  }

  Future<String> englishToGermanTranslation(Future<String> englishWord) async {
    var englishWordToTranslate = await englishWord;
    // api is of the format https://lt-translate-test.herokuapp.com/?langpair=en-de&query={wordToTranslate}
    var query = URI_EN_DE_TRANSLATION + englishWordToTranslate;
    final response = await http.get(query);
    if (response.body.length != 0) {
      List<RandomGermanWordWrapper> responseGermanWordWrapper;
      responseGermanWordWrapper = (json.decode(response.body) as List)
          .map((i) => RandomGermanWordWrapper.fromJson(i))
          .toList();

      return responseGermanWordWrapper.first.l1Text;
    }
    return null;
  }

  String generateRandomParamsForApiRequest() {
    // api expects request in format https://api.datamuse.com/words?sp={startLetter}???{endLetter}
    // Number of ? indicates the number of characters between start and length.
    // valid request to find word that starts with a and ends with c and has 4 letters in between is
    // https://api.datamuse.com/words?sp=a????c
    var startLetter = _rand.nextInt(26);
    var wordLength = _rand.nextInt(MAXIMUM_RANDOM_ENGLISH_WORD_LENGTH);

    while (wordLength < MINIMUM_RANDOM_ENGLISH_WORD_LENGTH) {
      wordLength = new Random().nextInt(MAXIMUM_RANDOM_ENGLISH_WORD_LENGTH);
    }

    var queryString = _chars.split('')[startLetter];
    for (var i = 0; i < wordLength; i++) {
      queryString = queryString + '?';
    }

    return queryString;
  }

  Future<WordPair> generateRandomWordPair(
      String uid, bool ignoreTimeStamp) async {
    await localStorage.isStorageReady();
    WordPair enDeWordPair = localStorage.readWordPairFromStorage();

    var langPair = await localStorage.getLanguagePairForUser(uid);
    if (!ignoreTimeStamp) {
      if (enDeWordPair.englishWord != null) {
        if (enDeWordPair.creationDate ==
            DateTime.now().day.toString() +
                DateTime.now().month.toString() +
                DateTime.now().year.toString()) {
          return enDeWordPair;
        }
      }
    }

    enDeWordPair = new WordPair();
    final translator = GoogleTranslator();

    final randomEnglishWord = await generateRandomEnglishWord();

    final translatedGermanWord = await translator.translate(randomEnglishWord,
        from: langPair['source'], to: langPair['target']);

    enDeWordPair.englishWord = translatedGermanWord.source;
    enDeWordPair.germanWord = translatedGermanWord.text;
    enDeWordPair.creationDate = DateTime.now().day.toString() +
        DateTime.now().month.toString() +
        DateTime.now().year.toString();

    localStorage.saveWordOfTheDayToLocalStorage(enDeWordPair);
    return enDeWordPair;
  }
}
