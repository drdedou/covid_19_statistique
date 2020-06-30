import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Flags with ChangeNotifier {
  Map<String, String> myFlags;
  Map<String, String> countryName;
  Map<String, String> countryNameAr;
  Map<String, String> countryServer;
  static String country = 'US';
  Future<Map<String, String>> getFlags() async {
    final _country = await SharedPreferences.getInstance();
    if (_country.containsKey('cnt')) {
      country = _country.getString('cnt');
    }

    if (myFlags == null) {
      await load();
    }
    return myFlags;
  }

  Map<String, String> get getCountryName {
    return countryName;
  }

  Map<String, String> get getCountryNameAr {
    return countryNameAr;
  }

  Map<String, String> get getCountryServer {
    return countryServer;
  }

  Future<void> setCountry(String newCounry) async {
    country = newCounry;
    final _country = await SharedPreferences.getInstance();
    _country.setString('cnt', newCounry);
    notifyListeners();
  }

  String getCountry() {
    notifyListeners();
    return country;
  }

  Future<void> load() async {
    String jsonStringValues =
        await rootBundle.loadString('assets/flags/contry.json');

    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);

    myFlags = mappedJson.map((key, value) => MapEntry(key, value.toString()));

    await loadCountryName();
    await loadCountryNameAr();
    await loadCountryServer();
  }

  Future<void> loadCountryName() async {
    String jsoncountryName =
        await rootBundle.loadString('assets/flags/country_name.json');
    Map<String, dynamic> mappedJson = json.decode(jsoncountryName);
    countryName =
        mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  Future<void> loadCountryNameAr() async {
    String jsoncountryName =
        await rootBundle.loadString('assets/flags/country_name_ar.json');
    Map<String, dynamic> mappedJson = json.decode(jsoncountryName);
    countryNameAr =
        mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  Future<void> loadCountryServer() async {
    String jsoncountryName =
        await rootBundle.loadString('assets/flags/country_server.json');
    Map<String, dynamic> mappedJson = json.decode(jsoncountryName);
    countryServer =
        mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }
}
