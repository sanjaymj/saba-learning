class SabaWord {
  String originalWord;
  String translatedWord;
  List<String> category;
  bool isFavorite = false;
  bool isUnknown = false;
  String gender;
  String additionalInfo;

  SabaWord(
      {this.originalWord,
      this.translatedWord,
      this.category,
      this.isFavorite,
      this.isUnknown,
      this.gender,
      this.additionalInfo});

  SabaWord.fromJson(Map<String, dynamic> json) {
    originalWord = json['originalWord'];
    translatedWord = json['translatedWord'];
    isFavorite = json['isFavorite'];
    isUnknown = json['isUnknown'];
    category = json['category'].cast<String>();
    gender = json['gender'];
    additionalInfo = json['additionalInfo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['originalWord'] = this.originalWord;
    data['translatedWord'] = this.translatedWord;
    data['isFavorite'] = this.isFavorite;
    data['isUnknown'] = this.isUnknown;
    data['category'] = this.category;
    data['gender'] = this.gender;
    data['additionalInfo'] = this.additionalInfo;
    return data;
  }
}
