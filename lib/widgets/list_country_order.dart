import 'package:floating_search_bar/floating_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import '../localization/demo_localizations.dart';
import '../localization/flags.dart';
import '../providers/summary.dart';

class ListCountryOrder extends StatefulWidget {
  @override
  _ListCountryOrderState createState() => _ListCountryOrderState();
}

class _ListCountryOrderState extends State<ListCountryOrder> {
  int stateSeach = 1;
  void changeState(int newVal) {
    setState(() {
      stateSeach = newVal;
    });
  }

  @override
  Widget build(BuildContext context) {
    final summary = Provider.of<CovsSummary>(context, listen: false);
    final falgs = Provider.of<Flags>(context, listen: false);
    final isAR = DemoLocalizations.of(context).getTraslat('active') != "Active";
    final screenHeight = MediaQuery.of(context).size.height;
    final screenSize = screenHeight - 160;
    final lang = DemoLocalizations.of(context).getTraslat;
    return FutureBuilder(
      future: summary.loadeSummary(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final isNotLoaded = snapshot.connectionState == ConnectionState.waiting;
        final isSummaryNotEmpty = summary.getSummary != null;
        return Container(
          height: screenSize,
          padding: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            children: [
              ChooseWord(
                changeState: changeState,
                stateSeach: stateSeach,
              ),
              if (isNotLoaded)
                Expanded(
                  child: Center(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
              if (!isNotLoaded)
                !isSummaryNotEmpty
                    ? buildSliverPaddingErrorEmpty(summary, screenHeight, lang)
                    : FutureBuilder(
                        future: falgs.getFlags(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Consumer<Flags>(builder: (ctx, flags, child) {
                            return Container(
                              height: screenSize - 80,
                              padding: const EdgeInsets.only(
                                  top: 20, left: 20, right: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: CountryDropDownSummary(
                                flags: (snapshot.data as Map<String, String>),
                                countryName: isAR
                                    ? falgs.getCountryNameAr
                                    : falgs.getCountryName,
                                countries: summary.getSummary.countries,
                                stateSeach: stateSeach,
                              ),
                            );
                          });
                        },
                      ),
            ],
          ),
        );
      },
    );
  }
}

RefreshIndicator buildSliverPaddingErrorEmpty(
    CovsSummary summary, double screenHeight, String lang(String key)) {
  return RefreshIndicator(
    onRefresh: summary.refrush,
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
                    color: Colors.black,
                    size: 30,
                  ),
                  Text(
                    lang('er_country'),
                    style: TextStyle(
                      color: Colors.grey.shade900,
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
  );
}

class Country {
  final String countryName;
  final int orders;
  final countryCode;

  Country(this.countryName, this.orders, this.countryCode);
}

class CountryDropDownSummary extends StatefulWidget {
  final Map<String, String> flags;
  final Map<String, String> countryName;
  final List<Countries> countries;
  final int stateSeach;

  const CountryDropDownSummary(
      {this.flags, this.countryName, this.countries, this.stateSeach});

  @override
  _CountryDropDownSummaryState createState() => _CountryDropDownSummaryState();
}

class _CountryDropDownSummaryState extends State<CountryDropDownSummary> {
  List<Country> listCountry = [];
  List<Country> listCountryOld = [];

  List<Color> color = [
    Colors.red.shade500,
    Colors.orange.shade500,
    Colors.green.shade500
  ];

  @override
  void initState() {
    if (widget.stateSeach == 0) {}
    final tempCountryName = widget.countryName;
    final tempCountrys = widget.countries;
    for (var i = 0; i < tempCountrys.length; i++) {
      int tempStatus;
      if (widget.stateSeach == 1) {
        tempStatus = tempCountrys[i].totalConfirmed;
      } else if (widget.stateSeach == 0) {
        tempStatus = tempCountrys[i].totalDeaths;
      } else {
        tempStatus = tempCountrys[i].totalRecovered;
      }
      listCountry.add(
        Country(
          tempCountryName[tempCountrys[i].countryCode],
          tempStatus,
          tempCountrys[i].countryCode,
        ),
      );
    }
    Comparator<Country> countryComparator =
        (a, b) => a.orders.compareTo(b.orders);
    listCountry.sort(countryComparator);
    listCountry = listCountry.reversed.toList();
    listCountryOld = listCountry;
    super.initState();
  }

  void searchBar(String newVal) {
    setState(() {
      listCountry = listCountryOld
          .where(
            (element) => element.countryName
                .toLowerCase()
                .contains(newVal.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = DemoLocalizations.of(context).getTraslat;
    return Container(
      child: FloatingSearchBar.builder(
        trailing: Icon(Icons.search),
        onChanged: searchBar,
        onTap: () {},
        decoration: InputDecoration.collapsed(
          hintText: lang('search'),
        ),
        itemCount: listCountry.length,
        itemBuilder: (ctx, index) {
          return Column(
            children: [
              Divider(),
              Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 18.0,
                            backgroundColor: Colors.grey,
                            child: CircleAvatar(
                              radius: 16.0,
                              backgroundImage: AssetImage(
                                'assets/flags/images/${listCountry[index].countryCode.toLowerCase()}.png',
                              ),
                            ),
                          ),
                          const SizedBox(width: 18.0),
                          Flexible(
                            child: RichText(
                              maxLines: 1,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              strutStyle: StrutStyle(
                                fontSize: 16.0,
                              ),
                              text: TextSpan(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo'),
                                text: listCountry[index].countryName,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 30,
                      decoration: BoxDecoration(
                        color: color[widget.stateSeach],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        '${NumberFormat.compact().format(listCountry[index].orders)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ChooseWord extends StatefulWidget {
  final Function changeState;
  final int stateSeach;

  const ChooseWord({this.changeState, this.stateSeach});
  @override
  _ChooseWordState createState() => _ChooseWordState();
}

class _ChooseWordState extends State<ChooseWord> {
  List<String> data = ['deaths', 'confirmed', 'recovered'];
  List<Color> color = [
    Colors.red.shade800,
    Colors.orange.shade800,
    Colors.green.shade800
  ];

  Widget _buildListItem(BuildContext context, int index) {
    final lang = DemoLocalizations.of(context).getTraslat;
    return Container(
      decoration: BoxDecoration(
        color: color[index],
        borderRadius: BorderRadius.circular(30),
      ),
      height: 40,
      width: 120,
      child: Text(
        '${lang(data[index])}',
        style: TextStyle(fontSize: 20, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 40,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: ScrollSnapList(
          initialIndex: 1.0,
          onItemFocus: widget.changeState,
          itemSize: 120,
          itemBuilder: _buildListItem,
          itemCount: data.length,
          reverse: true,
          dynamicItemSize: true,
        ),
      ),
    );
  }
}
