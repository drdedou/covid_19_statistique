import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class Language with ChangeNotifier {
  static String lang = '';

  String getLang() {
    return lang;
  }

  Future<void> setLang(BuildContext context, String newLang) async {
    final _prefs = await SharedPreferences.getInstance();
    _prefs.setString('lang', newLang);
    lang = newLang;
    _changeLanguage(context, newLang.toLowerCase());
  }

  void _changeLanguage(BuildContext context, String language) {
    Locale _temp;
    switch (language) {
      case 'en':
        _temp = Locale(language, 'US');
        break;
      case 'ar':
        _temp = Locale(language, 'DZ');
        break;

      default:
        _temp = Locale(language, 'US');
    }

    MyApp.setLocal(context, _temp);
  }
}

Future<Locale> getInitLang() async {
  final _prefs = await SharedPreferences.getInstance();
  Locale _temp = Locale('en', 'US');
  if (_prefs.containsKey('lang')) {
    final language = _prefs.getString('lang').toLowerCase();
    switch (language) {
      case 'en':
        _temp = Locale(language, 'US');
        break;
      case 'ar':
        _temp = Locale(language, 'DZ');
        break;

      default:
        _temp = Locale(language, 'US');
    }
    Language.lang = _prefs.getString('lang');
  } else {
    String locale = await Devicelocale.currentLocale;
    if (locale.contains("ar")) {
      _temp = Locale('ar', 'DZ');
      Language.lang = 'AR';
    } else if (locale.contains("en")) {
      _temp = Locale('en', 'US');
      Language.lang = 'EN';
    } else {
      _temp = Locale('en', 'US');
      Language.lang = 'EN';
    }
  }

  return _temp;
}
