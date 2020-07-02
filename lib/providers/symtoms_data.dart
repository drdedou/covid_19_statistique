import 'dart:convert';

import 'package:flutter/services.dart';

class SymptomsData {
  String questionCode;
  String subMsg;
  List<ListButton> listButton;

  SymptomsData({this.questionCode, this.subMsg, this.listButton});

  SymptomsData.fromJson(Map<String, dynamic> json) {
    questionCode = json['question_code'];
    subMsg = json['sub_msg'];
    if (json['list_button'] != null) {
      listButton = new List<ListButton>();
      json['list_button'].forEach((v) {
        listButton.add(new ListButton.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question_code'] = this.questionCode;
    data['sub_msg'] = this.subMsg;
    if (this.listButton != null) {
      data['list_button'] = this.listButton.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListButton {
  String buttonText;
  bool counterMinorGravityFactor;
  bool prognosticFactors;
  bool majorGravityFactors;
  bool isCough;
  bool isPains;
  bool isFever;
  bool isDiarrhea;
  bool isAnosmie;
  int weight;
  int length;
  String age;
  bool pass;

  ListButton(
      {this.buttonText,
      this.counterMinorGravityFactor,
      this.prognosticFactors,
      this.majorGravityFactors,
      this.isCough,
      this.isPains,
      this.isFever,
      this.isDiarrhea,
      this.isAnosmie,
      this.weight,
      this.length,
      this.age,
      this.pass});

  ListButton.fromJson(Map<String, dynamic> json) {
    buttonText = json['button_text'];
    counterMinorGravityFactor = json['counterMinorGravityFactor'];
    prognosticFactors = json['prognosticFactors'];
    majorGravityFactors = json['majorGravityFactors'];
    isCough = json['isCough'];
    isPains = json['isPains'];
    isFever = json['isFever'];
    isDiarrhea = json['isDiarrhea'];
    isAnosmie = json['isAnosmie'];
    weight = json['weight'];
    length = json['length'];
    age = json['age'];
    pass = json['pass'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['button_text'] = this.buttonText;
    data['counterMinorGravityFactor'] = this.counterMinorGravityFactor;
    data['prognosticFactors'] = this.prognosticFactors;
    data['majorGravityFactors'] = this.majorGravityFactors;
    data['isCough'] = this.isCough;
    data['isPains'] = this.isPains;
    data['isFever'] = this.isFever;
    data['isDiarrhea'] = this.isDiarrhea;
    data['isAnosmie'] = this.isAnosmie;
    data['weight'] = this.weight;
    data['length'] = this.length;
    data['age'] = this.age;
    data['pass'] = this.pass;
    return data;
  }
}

class Symptoms {
  SymptomsData _symptomsData;

  get getSymptomsData {
    return _symptomsData;
  }

  Future<void> loadSymptomsData() async {
    String jsoncountryName =
        await rootBundle.loadString('assets/flags/country_server.json');
    Map<String, dynamic> mappedJson = json.decode(jsoncountryName);
    _symptomsData = SymptomsData.fromJson(mappedJson);
  }
}
