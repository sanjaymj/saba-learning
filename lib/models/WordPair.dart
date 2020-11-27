class WordPair {
  String englishWord;
  String germanWord;
  String creationDate;

  WordPair({this.englishWord, this.germanWord, this.creationDate});

  WordPair.fromJson(Map<String, dynamic> json) {
    englishWord = json['englishWord'];
    germanWord = json['germanWord'];
    creationDate = json['creationDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['englishWord'] = this.englishWord;
    data['germanWord'] = this.germanWord;
    data['creationDate'] = this.creationDate;
    return data;
  }
}
