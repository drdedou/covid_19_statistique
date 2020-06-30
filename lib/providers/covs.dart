import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../localization/flags.dart';

class CovCountry {
  String country;
  String countryCode;
  String province;
  String city;
  String cityCode;
  String lat;
  String lon;
  int confirmed;
  int deaths;
  int recovered;
  int active;
  DateTime date;

  CovCountry(
      {this.country,
      this.countryCode,
      this.province,
      this.city,
      this.cityCode,
      this.lat,
      this.lon,
      this.confirmed,
      this.deaths,
      this.recovered,
      this.active,
      this.date});

  CovCountry.fromJson(dynamic json) {
    country = json['Country'];
    countryCode = json['CountryCode'];
    province = json['Province'];
    city = json['City'];
    cityCode = json['CityCode'];
    lat = json['Lat'];
    lon = json['Lon'];
    confirmed = json['Confirmed'];
    deaths = json['Deaths'];
    recovered = json['Recovered'];
    active = json['Active'];
    date = DateTime.parse(json['Date']);
  }
}

class CovsWorld {
  int totalConfirmed;
  int totalDeaths;
  int totalRecovered;

  CovsWorld({this.totalConfirmed, this.totalDeaths, this.totalRecovered});

  CovsWorld.fromJson(Map<String, dynamic> json) {
    totalConfirmed = json['TotalConfirmed'];
    totalDeaths = json['TotalDeaths'];
    totalRecovered = json['TotalRecovered'];
  }
}

class Covs with ChangeNotifier {
  List<CovCountry> _covsDatabyDay = [];
  CovCountry _covCountryGlobal = CovCountry();
  static bool _isCountry = true;
  static bool _isCountryTotal = true;

  void setIscountryTotal(int index) {
    if (index == 0) {
      _isCountryTotal = true;
      notifyListeners();
    } else if (index == 1) {
      _isCountryTotal = false;
      notifyListeners();
    } else {
      _isCountryTotal = true;
    }
  }

  void setIsCountry(int index) {
    if (index == 0) {
      _isCountry = true;
      notifyListeners();
    } else if (index == 1) {
      _isCountry = false;
      notifyListeners();
    } else {
      _isCountry = true;
    }
  }

  bool get getIscountry {
    return _isCountry;
  }

  bool get getIscountryTotal {
    return _isCountryTotal;
  }

  CovCountry get getCountryToutal {
    return _covCountryGlobal;
  }

  List<CovCountry> get covsDataByDay {
    return _covsDatabyDay;
  }

  CovCountry get getCountryLastDay {
    if (_covsDatabyDay.isEmpty) {
      return CovCountry();
    }
    return _covsDatabyDay.last;
  }

  Future<void> refrush() async {
    notifyListeners();
  }

  List<CovCountry> covCountryByDay(List<CovCountry> newCov) {
    List<CovCountry> cvs = [];
    for (var i = 1; i < newCov.length; i++) {
      CovCountry tempcnv = CovCountry();
      tempcnv.confirmed = newCov[i].confirmed - newCov[i - 1].confirmed;
      tempcnv.deaths = newCov[i].deaths - newCov[i - 1].deaths;
      tempcnv.recovered = newCov[i].recovered - newCov[i - 1].recovered;
      tempcnv.active = newCov[i].active;
      tempcnv.date = newCov[i].date;

      cvs.add(tempcnv);
    }

    return cvs;
  }

  Future<void> loadeCountry() async {
    try {
      final Flags falgs = Flags();
      final Map<String, String> mapFlags = await falgs.getFlags();
      final countryName = mapFlags[Flags.country];
      DateTime now = DateTime.now().subtract(Duration(days: 1));
      now = DateTime(now.year, now.month, now.day);
      DateTime beforeweek = now.subtract(Duration(days: 2));
      final url =
          "https://api.covid19api.com/total/country/$countryName?from=${beforeweek.toIso8601String()}Z&to=${now.toIso8601String()}Z";
      final response = await http.get(url);
      final extractResponse = json.decode(response.body) as List<dynamic>;
      List<CovCountry> covs = [];
      extractResponse.forEach((cov) {
        covs.add(CovCountry.fromJson(cov));
      });

      _covsDatabyDay = covCountryByDay(covs);
      _covCountryGlobal = covs[_covsDatabyDay.length];
    } catch (e) {
      _covsDatabyDay = [];
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  CovsWorld _covsWorld;

  CovsWorld get getCovsWorld {
    return _covsWorld;
  }

  Future<void> loadeWorld() async {
    try {
      final url = "https://api.covid19api.com/world/total";
      final response = await http.get(url);

      final extractResponse =
          json.decode(response.body) as Map<String, dynamic>;

      _covsWorld = CovsWorld.fromJson(extractResponse);
    } catch (e) {
      _covsWorld = null;
    }
  }
}
