import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';

import '../localization/demo_localizations.dart';
import '../screens/info.dart';
import '../screens/quize.dart';
import '../models/featureConst.dart';

import './home_screen.dart';
import './stats_screen.dart';

class BottomNavScreen extends StatefulWidget {
  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  void changePage(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FeatureDiscovery.discoverFeatures(
        context,
        const <String>{
          gps1,
          language2,
          chooseCountry3,
          testNow4,
          confirmedClick5,
          chooseWeek6,
          global7,
          iGetIt8
        },
      );
    });
    super.initState();
  }

  int _currentIndex = 0;

  getPagebyIndex(int index) {
    switch (index) {
      case 0:
        return HomeScreen(onPageChange: changePage);
        break;
      case 1:
        return StatsScreen(onPageChange: changePage);
        break;
      case 2:
        return Quize(onPageChange: changePage);
        break;
      case 3:
        return Info();
        break;
      default:
        return HomeScreen(onPageChange: changePage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final closeTxt = DemoLocalizations.of(context).getTraslat("tab_close");
    return Scaffold(
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          content: Text(
            '$closeTxt',
            textAlign: TextAlign.center,
          ),
        ),
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: getPagebyIndex(_currentIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: changePage,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        elevation: 0.0,
        items: [Icons.home, Icons.insert_chart, Icons.assignment, Icons.info]
            .asMap()
            .map((key, value) => MapEntry(
                  key,
                  BottomNavigationBarItem(
                    title: Text(''),
                    icon: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6.0,
                        horizontal: 16.0,
                      ),
                      decoration: BoxDecoration(
                        color: _currentIndex == key
                            ? Colors.blue[600]
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Icon(value),
                    ),
                  ),
                ))
            .values
            .toList(),
      ),
    );
  }
}
