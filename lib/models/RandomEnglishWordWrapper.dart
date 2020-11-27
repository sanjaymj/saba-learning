class RandomEnglishWordWrapper {
  String word;
  int score;

  RandomEnglishWordWrapper({this.word, this.score});

  RandomEnglishWordWrapper.fromJson(Map<String, dynamic> json) {
    word = json['word'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['word'] = this.word;
    data['score'] = this.score;
    return data;
  }
}
