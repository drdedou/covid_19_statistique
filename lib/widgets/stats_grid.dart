import 'package:covid_19_statistique/models/featureConst.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/covs.dart';
import '../localization/demo_localizations.dart';
import '../providers/covs_week.dart';

class StatsGrid extends StatelessWidget {
  final Covs covsData;
  final GlobalKey<EnsureVisibleState> ensureKeychartBar;

  const StatsGrid({this.covsData, this.ensureKeychartBar});
  @override
  Widget build(BuildContext context) {
    final lang = DemoLocalizations.of(context).getTraslat;
    final covsCountryToutal = covsData.getCountryToutal;
    final covsCountryLastDay = covsData.getCountryLastDay;
    final covsWorld = covsData.getCovsWorld;

    var confirmed;
    var deaths;
    var recovered;
    var active;

    if (!covsData.getIscountry) {
      confirmed = covsWorld.totalConfirmed;
      deaths = covsWorld.totalDeaths;
      recovered = covsWorld.totalRecovered;
    } else if (covsData.getIscountryTotal) {
      confirmed = covsCountryToutal.confirmed;
      deaths = covsCountryToutal.deaths;
      recovered = covsCountryToutal.recovered;
      active = covsCountryToutal.active;
    } else {
      confirmed = covsCountryLastDay.confirmed;
      deaths = covsCountryLastDay.deaths;
      recovered = covsCountryLastDay.recovered;
      active = covsCountryLastDay.active;
    }

    return Container(
      height: 210,
      margin: covsData.getIscountry
          ? const EdgeInsets.only(top: 0)
          : const EdgeInsets.only(top: 20),
      child: Column(
        children: <Widget>[
          Flexible(
            child: Row(
              children: [
                _buildStatCard(
                  lang('confirmed'),
                  '${NumberFormat.compact().format(confirmed)}',
                  Colors.orange,
                  1,
                  context,
                  ensureKeychartBar,
                ),
                _buildStatCard(
                  lang('deaths'),
                  '${NumberFormat.compact().format(deaths)}',
                  Colors.red,
                  2,
                  context,
                  ensureKeychartBar,
                ),
              ],
            ),
          ),
          !covsData.getIscountry
              ? Flexible(
                  child: Row(
                    children: [
                      _buildStatCard(
                        lang('recovered'),
                        '${NumberFormat.compact().format(recovered)}',
                        Colors.green,
                        3,
                        context,
                        ensureKeychartBar,
                      ),
                    ],
                  ),
                )
              : Flexible(
                  child: Row(
                    children: [
                      _buildStatCard(
                        lang('recovered'),
                        '${NumberFormat.compact().format(recovered)}',
                        Colors.green,
                        3,
                        context,
                        ensureKeychartBar,
                      ),
                      _buildStatCard(
                        lang('active'),
                        '${NumberFormat.compact().format(active)}',
                        Colors.lightBlue,
                        4,
                        context,
                        ensureKeychartBar,
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Expanded _buildStatCard(
    String title,
    String count,
    MaterialColor color,
    int status,
    BuildContext context,
    GlobalKey<EnsureVisibleState> ensureKeychartBar,
  ) {
    final lang = DemoLocalizations.of(context).getTraslat;
    return Expanded(
      child: DescribedFeatureOverlay(
        onComplete: () async {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              ensureKeychartBar.currentState.ensureVisible(
                duration: const Duration(
                  milliseconds: 600,
                ),
              );
            },
          );
          return true;
        },
        featureId: confirmedClick5,
        tapTarget: const Icon(Icons.check_box),
        backgroundColor: colorFeature[5],
        contentLocation: ContentLocation.below,
        title: Text(lang("intro_confirmedClick5")),
        child: InkWell(
          onTap: !covsData.getIscountry
              ? null
              : () {
                  Provider.of<CovsWeeks>(context, listen: false)
                      .setStatus(status);
                },
          child: Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  count,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
