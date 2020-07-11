import 'dart:io';

import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:provider/provider.dart';

import '../widgets/list_country_order.dart';
import '../localization/demo_localizations.dart';
import '../localization/flags.dart';
import '../providers/covs.dart';
import '../config/palette.dart';
import '../config/styles.dart';
import '../widgets/widgets.dart';

class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen>
    with TickerProviderStateMixin {
  GlobalKey<EnsureVisibleState> ensureKeychartBar;

  TabController _tabControllerIsCountry;
  TabController _tabControllerIsTotal;
  int weeksIndex = 1;
  Future<bool> cnx() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  @override
  void initState() {
    ensureKeychartBar = GlobalKey<EnsureVisibleState>();

    _tabControllerIsCountry = TabController(
        vsync: this,
        length: 2,
        initialIndex:
            Provider.of<Covs>(context, listen: false).getIscountry ? 0 : 1);

    _tabControllerIsTotal = TabController(
        vsync: this,
        length: 2,
        initialIndex:
            Provider.of<Covs>(context, listen: false).getIscountryTotal
                ? 0
                : 1);
    super.initState();
  }

  @override
  void dispose() {
    _tabControllerIsCountry.dispose();
    _tabControllerIsTotal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final lang = DemoLocalizations.of(context).getTraslat;
    final covsData = Provider.of<Covs>(context);

    Provider.of<Flags>(context);
    return Scaffold(
      backgroundColor: Palette.primaryColor,
      appBar: CustomAppBar(),
      body: RefreshIndicator(
        onRefresh: covsData.refrush,
        child: FutureBuilder(
          future: cnx(),
          builder: (BuildContext context, AsyncSnapshot cnxData) {
            if (cnxData.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            bool isCnx = cnxData.data as bool;
            if (!isCnx) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Container(
                    height: screenHeight - 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sync_problem,
                            color: Colors.white,
                            size: 30,
                          ),
                          Text(
                            lang('er_cnx'),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return FutureBuilder(
              future: covsData.getIscountry
                  ? covsData.loadeCountry()
                  : covsData.loadeWorld(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                var isLoaded =
                    !(snapshot.connectionState == ConnectionState.waiting);
                var isNotEmptyCountry = covsData.covsDataByDay.isNotEmpty;
                var isNotEmptyGlobal = covsData.getCovsWorld != null;
                return CustomScrollView(
                  physics: ClampingScrollPhysics(),
                  slivers: <Widget>[
                    _buildHeader(),
                    _buildRegionTabBar(covsData: covsData),
                    if (isNotEmptyCountry && covsData.getIscountry)
                      _buildStatsTabBar(covsData: covsData),
                    if (!isLoaded)
                      SliverPadding(
                        sliver: SliverToBoxAdapter(
                          child: Container(
                            height: 200,
                            width: 200,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                    if (isLoaded)
                      if (!isNotEmptyGlobal && !covsData.getIscountry)
                        buildSliverPaddingErrorEmpty(
                            covsData, screenHeight, lang),
                    if (isLoaded)
                      if (!isNotEmptyCountry && covsData.getIscountry)
                        buildSliverPaddingErrorEmpty(
                            covsData, screenHeight, lang),
                    if (isLoaded)
                      if ((isNotEmptyCountry && covsData.getIscountry) ||
                          (isNotEmptyGlobal && !covsData.getIscountry))
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          sliver: SliverToBoxAdapter(
                            child: StatsGrid(
                              covsData: covsData,
                              ensureKeychartBar: ensureKeychartBar,
                            ),
                          ),
                        ),
                    if (isLoaded && !covsData.getIscountry)
                      SliverPadding(
                        padding: const EdgeInsets.only(top: 20.0),
                        sliver: SliverToBoxAdapter(
                          child: ListCountryOrder(),
                        ),
                      ),
                    if (isLoaded && covsData.getIscountry && isNotEmptyCountry)
                      SliverPadding(
                        padding: const EdgeInsets.only(top: 20.0),
                        sliver: SliverToBoxAdapter(
                          child: EnsureVisible(
                            key: ensureKeychartBar,
                            child: CovidBarChart(),
                          ),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  SliverPadding buildSliverPaddingErrorEmpty(
      Covs covsData, double screenHeight, String lang(String key)) {
    return SliverPadding(
      sliver: SliverToBoxAdapter(
        child: RefreshIndicator(
          onRefresh: covsData.refrush,
          child: Container(
            height: screenHeight - 300,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Container(
                  height: screenHeight - 300,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sync_problem,
                          color: Colors.white,
                          size: 30,
                        ),
                        Text(
                          lang('er_country'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
    );
  }

  SliverPadding _buildHeader() {
    final lang = DemoLocalizations.of(context).getTraslat;
    return SliverPadding(
      padding: const EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 20),
      sliver: SliverToBoxAdapter(
        child: Text(
          lang('statistics'),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildRegionTabBar({Covs covsData}) {
    final isCountry = covsData.getIscountry;
    final lang = DemoLocalizations.of(context).getTraslat;
    return SliverToBoxAdapter(
      child: DefaultTabController(
        initialIndex: isCountry ? 0 : 1,
        length: 2,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          height: 50.0,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: TabBar(
            controller: _tabControllerIsCountry,
            indicator: BubbleTabIndicator(
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
              indicatorHeight: 40.0,
              indicatorColor: Colors.white,
            ),
            labelStyle: Styles.tabTextStyle,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.white,
            tabs: <Widget>[
              Container(
                height: 40,
                child: Center(
                  child: Text(
                    lang('my_country'),
                  ),
                ),
              ),
              Container(
                height: 40,
                child: Center(
                  child: Text(
                    lang('global'),
                  ),
                ),
              ),
            ],
            onTap: (index) {
              covsData.setIsCountry(index);
            },
          ),
        ),
      ),
    );
  }

  SliverPadding _buildStatsTabBar({Covs covsData}) {
    final lang = DemoLocalizations.of(context).getTraslat;
    final isCountryTotal = covsData.getIscountryTotal;
    final isCountry = covsData.getIscountry;

    return !isCountry
        ? SliverPadding(
            padding: const EdgeInsets.only(top: 20),
          )
        : SliverPadding(
            padding:
                const EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 10),
            sliver: SliverToBoxAdapter(
              child: DefaultTabController(
                initialIndex: isCountryTotal ? 0 : 1,
                length: 2,
                child: TabBar(
                  controller: _tabControllerIsTotal,
                  indicatorColor: Colors.transparent,
                  labelStyle: Styles.tabTextStyle,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  tabs: <Widget>[
                    Container(
                      height: 30,
                      child: Center(
                        child: Text(
                          lang('total'),
                        ),
                      ),
                    ),
                    Container(
                      height: 30,
                      child: Center(
                        child: Text(
                          lang('yesterday'),
                        ),
                      ),
                    ),
                  ],
                  onTap: (index) {
                    Provider.of<Covs>(context, listen: false)
                        .setIscountryTotal(index);
                  },
                ),
              ),
            ),
          );
  }
}
