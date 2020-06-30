import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../localization/demo_localizations.dart';
import '../localization/flags.dart';
import './covs.dart';

enum Status { confirmed, deaths, recovered, active }

class CovsWeeks with ChangeNotifier {
  var status = Status.confirmed;
  List<CovCountry> _covsDatabyDay = [];
  int _devided;

  void setStatus(int index) {
    switch (index) {
      case 1:
        status = Status.confirmed;
        break;

      case 2:
        status = Status.deaths;
        break;

      case 3:
        status = Status.recovered;
        break;

      case 4:
        status = Status.active;
        break;
      default:
        status = Status.confirmed;
    }

    notifyListeners();
  }

  String getStatusTitle(BuildContext context) {
    final lang = DemoLocalizations.of(context).getTraslat;
    switch (status) {
      case Status.confirmed:
        return lang('confirmed');
        break;

      case Status.deaths:
        return lang('deaths');
        break;

      case Status.recovered:
        return lang('recovered');
        break;

      case Status.active:
        return lang('active');
        break;
      default:
        return lang('confirmed');
    }
  }

  int get getDevided {
    return _devided;
  }

  List<CovCountry> get covsDataByDay {
    return _covsDatabyDay;
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

  List<double> get getDataPicker {
    double tempDevided;
    List<double> tempCases = [];
    switch (status) {
      case Status.confirmed:
        for (var i = 0; i < _covsDatabyDay.length; i++) {
          tempCases.add(_covsDatabyDay[i].confirmed.toDouble());
        }
        break;

      case Status.deaths:
        for (var i = 0; i < _covsDatabyDay.length; i++) {
          tempCases.add(_covsDatabyDay[i].deaths.toDouble());
        }
        break;

      case Status.recovered:
        for (var i = 0; i < _covsDatabyDay.length; i++) {
          tempCases.add(_covsDatabyDay[i].recovered.toDouble());
        }
        break;

      case Status.active:
        for (var i = 0; i < _covsDatabyDay.length; i++) {
          tempCases.add(_covsDatabyDay[i].active.toDouble());
        }
        break;
      default:
        for (var i = 0; i < _covsDatabyDay.length; i++) {
          tempCases.add(_covsDatabyDay[i].confirmed.toDouble());
        }
    }
    final isNigative = tempCases.where((element) => element < 0);
    if (isNigative.isNotEmpty) {
      return [];
    }
    tempCases.removeAt(0);
    tempDevided = tempCases.reduce(max);

    int number = tempDevided.toInt();

    while ((number % 5) != 0) {
      number++;
    }
    int devided = (number ~/ 5);
    _devided = devided > 1 ? devided : 1;
    return tempCases;
  }

  Future<void> loadeCountry([int weekIndex = 1]) async {
    try {
      final Flags falgs = Flags();
      final Map<String, String> mapFlags = await falgs.getFlags();
      final countryName = mapFlags[Flags.country];
      DateTime now =
          DateTime.now().subtract(Duration(days: 1 + ((weekIndex - 1) * 7)));
      now = DateTime(now.year, now.month, now.day);
      DateTime beforeweek = now.subtract(Duration(days: 8));
      final url =
          "https://api.covid19api.com/total/country/$countryName?from=${beforeweek.toIso8601String()}Z&to=${now.toIso8601String()}Z";
      //"https://api.covid19api.com/total/country/algeria?from=2020-06-24T00:00:00.000Z&to=2020-06-28T00:00:00.000Z";
      //print(url);
      final response = await http.get(url);
      final extractResponse = json.decode(response.body) as List<dynamic>;
      List<CovCountry> covs = [];
      extractResponse.forEach((cov) {
        covs.add(CovCountry.fromJson(cov));
      });

      _covsDatabyDay = covCountryByDay(covs);
    } catch (e) {
      _covsDatabyDay = [];
    }
  }
}
