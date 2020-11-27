import 'package:translator/translator.dart';

class Translate {
  final translator = GoogleTranslator();

  translateWord(
      String currentWord, String sourceLang, String targetLang) async {
    try {
      return (await translator.translate(currentWord,
              from: sourceLang, to: targetLang))
          .text;
    } catch (e) {
      throw new Exception();
    }
  }
}
