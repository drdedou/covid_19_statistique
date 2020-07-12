import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

import '../models/featureConst.dart';
import '../localization/demo_localizations.dart';
import '../providers/covs.dart';
import '../providers/covs_week.dart';
import '../config/styles.dart';

class CovidBarChart extends StatefulWidget {
  final Function onPageChange;

  const CovidBarChart({this.onPageChange});
  @override
  _CovidBarChartState createState() => _CovidBarChartState();
}

class _CovidBarChartState extends State<CovidBarChart> {
  int indexWeeks;
  int maxIndexWeek;
  int getNumberOfWeek() {
    final firstDate = DateTime(2020, 2);
    final temp = DateTime.now().difference(firstDate);
    final weeks = temp.inDays / 7;
    return weeks.toInt();
  }

  @override
  void initState() {
    indexWeeks = getNumberOfWeek();
    maxIndexWeek = indexWeeks;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final covsWeeks = Provider.of<CovsWeeks>(context);
    final covs = Provider.of<Covs>(context, listen: false);
    final lang = DemoLocalizations.of(context).getTraslat;
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
            child: Text(
              covsWeeks.getStatusTitle(context),
              style: const TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            height: 40,
            width: 160,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey.shade100,
            ),
            child: DescribedFeatureOverlay(
              barrierDismissible: false,
              featureId: chooseWeek6,
              tapTarget: const Icon(Icons.calendar_today),
              backgroundColor: colorFeature[6],
              contentLocation: ContentLocation.below,
              onComplete: () async {
                Future.delayed(
                  Duration(milliseconds: 500),
                  () {
                    covs.setIsCountry(1);
                    widget.onPageChange(1);
                  },
                );

                return true;
              },
              title: Text(lang("intro_chooseWeek6")),
              child: NumberPicker.horizontal(
                initialValue: indexWeeks,
                minValue: 1,
                maxValue: getNumberOfWeek(),
                onChanged: (val) {
                  setState(() {
                    indexWeeks = val;
                  });
                },
              ),
            ),
          ),
          FutureBuilder(
            future: covsWeeks.loadeCountry(maxIndexWeek - indexWeeks + 1),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              try {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    width: 200,
                    height: MediaQuery.of(context).size.height / 2,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                final dataPiker = covsWeeks.getDataPicker;
                final devided = covsWeeks.getDevided;

                if (dataPiker.isNotEmpty) {
                  return barChart(context, covsWeeks.covsDataByDay..removeAt(0),
                      devided, (devided * 5).toDouble(), dataPiker);
                }

                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Text(
                    lang('error_info'),
                    style: TextStyle(
                      fontSize: 21,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              } catch (e) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Text(
                    lang('er_country'),
                    style: TextStyle(
                      fontSize: 21,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Container barChart(BuildContext context, List<CovCountry> dataTime,
      int devided, double maxDevided, List<double> datePiker) {
    final scale = maxDevided;
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: scale > 5 ? scale + 1 : scale,
          minY: 0,
          barTouchData: BarTouchData(
            enabled: true,
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              margin: 10.0,
              showTitles: true,
              textStyle: Styles.chartLabelsTextStyle,
              rotateAngle: 35.0,
              getTitles: (double value) {
                return DateFormat('MMM dd')
                    .format(dataTime[value.toInt()].date);
              },
            ),
            leftTitles: SideTitles(
              margin: 10.0,
              interval: devided.toDouble(),
              showTitles: true,
              textStyle: Styles.chartLabelsTextStyle,
              getTitles: (value) {
                return '${NumberFormat.compact().format(value)}';
              },
            ),
          ),
          gridData: FlGridData(
            show: true,
            horizontalInterval: devided.toDouble(),
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.black12,
                strokeWidth: 1.0,
                dashArray: [5],
              );
            },
          ),
          borderData: FlBorderData(show: false),
          barGroups: datePiker
              .asMap()
              .map((key, value) => MapEntry(
                  key,
                  BarChartGroupData(
                    x: key,
                    barRods: [
                      BarChartRodData(
                        y: value,
                        color: Colors.red,
                        width: 10,
                      ),
                    ],
                  )))
              .values
              .toList(),
        ),
      ),
    );
  }
}
