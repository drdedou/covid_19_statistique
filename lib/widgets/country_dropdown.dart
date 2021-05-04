import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:floating_search_bar/floating_search_bar.dart';

import '../localization/demo_localizations.dart';
import '../localization/flags.dart';

class CountryDropdown extends StatelessWidget {
  final Function(String) onChanged;

  const CountryDropdown({
    @required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final falgs = Provider.of<Flags>(context, listen: false);
    final isAR = DemoLocalizations.of(context).getTraslat('active') != "Active";
    return FutureBuilder(
      future: falgs.getFlags(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Consumer<Flags>(builder: (ctx, flags, child) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            height: 40.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => CountryDropDown(
                    flags: (snapshot.data as Map<String, String>),
                    countryName:
                        isAR ? falgs.getCountryNameAr : falgs.getCountryName,
                    countryServer: falgs.getCountryServer,
                    onchange: onChanged,
                  ),
                );
              },
              child: Container(
                  child: Row(
                children: [
                  CircleAvatar(
                    radius: 16.0,
                    backgroundColor: Colors.grey,
                    child: CircleAvatar(
                      radius: 14.0,
                      backgroundImage: AssetImage(
                        'assets/flags/images/${Flags.country.toLowerCase()}.png',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    Flags.country,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 6.0),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey.shade900,
                  )
                ],
              )),
            ),
          );
        });
      },
    );
  }
}

class Country {
  final String countryCode;
  final String countryName;

  Country(this.countryCode, this.countryName);
}

class CountryDropDown extends StatefulWidget {
  final Map<String, String> flags;
  final Map<String, String> countryName;
  final Map<String, String> countryServer;
  final Function onchange;
  const CountryDropDown(
      {this.flags, this.countryName, this.countryServer, this.onchange});

  @override
  _CountryDropDownState createState() => _CountryDropDownState();
}

class _CountryDropDownState extends State<CountryDropDown> {
  List<Country> listCountry = [];
  List<Country> listCountryOld = [];

  @override
  void initState() {
    final tempCountryCode = widget.flags.keys.toList();
    final tempCountryName = widget.countryName;
    final tempCountryServer = widget.countryServer;
    for (var i = 0; i < tempCountryCode.length; i++) {
      if (tempCountryServer.containsKey(tempCountryCode[i])) {
        listCountry.add(
          Country(
            tempCountryCode[i],
            tempCountryName[tempCountryCode[i]],
          ),
        );
      }
    }

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
    return AlertDialog(
      content: Container(
        width: 50,
        height: 400,
        child: FloatingSearchBar.builder(
          padding: EdgeInsets.only(bottom: 20),
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
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    widget.onchange(listCountry[index].countryCode);
                  },
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 16.0,
                          backgroundColor: Colors.grey,
                          child: CircleAvatar(
                            radius: 14.0,
                            backgroundImage: AssetImage(
                              'assets/flags/images/${listCountry[index].countryCode.toLowerCase()}.png',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
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
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Cairo'),
                              text: listCountry[index].countryName,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
