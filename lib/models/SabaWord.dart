class SabaWord {
  String originalWord;
  String translatedWord;
  List<String> category;
  String gender;
  String additionalInfo;

  SabaWord(
      {this.originalWord,
      this.translatedWord,
      this.category,
      this.gender,
      this.additionalInfo});

  SabaWord.fromJson(Map<String, dynamic> json) {
    originalWord = json['originalWord'];
    translatedWord = json['translatedWord'];
    category = json['category'].cast<String>();
    gender = json['gender'];
    additionalInfo = json['additionalInfo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['originalWord'] = this.originalWord;
    data['translatedWord'] = this.translatedWord;
    data['category'] = this.category;
    data['gender'] = this.gender;
    data['additionalInfo'] = this.additionalInfo;
    return data;
  }
}
