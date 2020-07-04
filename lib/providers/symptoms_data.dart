import 'dart:convert';

import 'package:flutter/foundation.dart';
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
  double weight;
  double length;
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
}

class Symptoms with ChangeNotifier {
  bool _isIGetIt = false;
  int _index = 0;
  String _msgShow = "";

  void setMsgShow(String newMsgShow) {
    _msgShow = newMsgShow;
    notifyListeners();
  }

  Future<void> newStart() async {
    await loadSymptomsData();
    notifyListeners();
  }

  String get getMsgShow {
    return _msgShow;
  }

  void setIndex({bool isPass}) {
    if (isPass) {
      _index += 2;
    } else {
      _index++;
    }
    notifyListeners();
  }

  int get getIndex {
    return _index;
  }

  bool get getIsIGetIt {
    return _isIGetIt;
  }

  set setIsGetIt(bool isIGetIt) {
    _isIGetIt = isIGetIt;
    notifyListeners();
  }

  List<SymptomsData> _symptomsData = [];

  List<SymptomsData> get getSymptomsData {
    return _symptomsData;
  }

  Future<void> loadSymptomsData() async {
    _msgShow = "";
    _symptomsData = [];
    _isIGetIt = false;
    _index = 0;
    final jsonSymptoms =
        await rootBundle.loadString('assets/symptoms/symptoms_data.json');
    final mappedJson = json.decode(jsonSymptoms) as List<dynamic>;

    mappedJson.forEach((element) {
      final tempSymptoms =
          SymptomsData.fromJson(element as Map<String, dynamic>);
      _symptomsData.add(tempSymptoms);
    });
  }
}
