class RandomGermanWordWrapper {
  int id;
  String l1Text;
  String l2Text;
  String wortart;
  String synonyme1;
  String synonyme2;
  int freq;

  RandomGermanWordWrapper(
      {this.id,
      this.l1Text,
      this.l2Text,
      this.wortart,
      this.synonyme1,
      this.synonyme2,
      this.freq});

  RandomGermanWordWrapper.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    l1Text = json['l1_text'];
    l2Text = json['l2_text'];
    wortart = json['wortart'];
    synonyme1 = json['synonyme1'];
    synonyme2 = json['synonyme2'];
    freq = json['freq'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['l1_text'] = this.l1Text;
    data['l2_text'] = this.l2Text;
    data['wortart'] = this.wortart;
    data['synonyme1'] = this.synonyme1;
    data['synonyme2'] = this.synonyme2;
    data['freq'] = this.freq;
    return data;
  }
}
