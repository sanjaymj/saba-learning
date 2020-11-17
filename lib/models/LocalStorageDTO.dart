import 'package:sabalearning/models/SabaWord.dart';
import 'package:sabalearning/models/WordPair.dart';

class LocalStorageDTO {
  WordPair wordOfTheDay;
  List<SabaWord> words;

  LocalStorageDTO({this.wordOfTheDay, this.words});

  LocalStorageDTO.fromJson(Map<String, dynamic> json) {
    wordOfTheDay = json['word'];
    words = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wordOfTheDay'] = this.wordOfTheDay.toJson();
    data['words'] = this.words.map((val) => val.toJson());
    return data;
  }
}
