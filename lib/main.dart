import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import './providers/symptoms_data.dart';
import './providers/summary.dart';
import './screens/bottom_nav_screen.dart';
import './localization/demo_localizations.dart';
import './providers/covs.dart';
import './providers/covs_week.dart';
import './providers/language.dart';
import './localization/flags.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocal(BuildContext context, Locale temp) {
    _MyAppState state = context.findRootAncestorStateOfType<_MyAppState>();
    state.setLocal(temp);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;
  void setLocal(Locale temp) {
    setState(() {
      _locale = temp;
    });
  }

  @override
  void initState() {
    getInitLang().then((value) {
      setState(() {
        _locale = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Covid-19 Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Cairo',
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      locale: _locale,
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ar', 'DZ'),
      ],
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        DemoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeListResolutionCallback: (deviceLocal, suppoetLocal) {
        for (var locale in suppoetLocal) {
          for (var device in deviceLocal) {
            if (locale.languageCode == device.languageCode) {
              return device;
            }
          }
        }
        return suppoetLocal.first;
      },
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Language(),
          ),
          ChangeNotifierProvider.value(
            value: Flags(),
          ),
          ChangeNotifierProvider.value(
            value: Covs(),
          ),
          ChangeNotifierProvider.value(
            value: CovsWeeks(),
          ),
          ChangeNotifierProvider.value(
            value: CovsSummary(),
          ),
          ChangeNotifierProvider.value(
            value: Symptoms(),
          ),
        ],
        child: BottomNavScreen(),
      ),
    );
  }
}
