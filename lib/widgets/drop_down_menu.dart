import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/language.dart';
import '../config/palette.dart';

class DropDownMenu extends StatefulWidget {
  DropDownMenu({Key key}) : super(key: key);

  @override
  _DropDownMenuState createState() => _DropDownMenuState();
}

class _DropDownMenuState extends State<DropDownMenu> {
  String dropdownValue = 'EN';

  @override
  Widget build(BuildContext context) {
    final langData = Provider.of<Language>(context, listen: false);
    dropdownValue =
        langData.getLang().isEmpty ? dropdownValue : langData.getLang();
    return DropdownButton<String>(
      value: dropdownValue,
      dropdownColor: Palette.primaryColor,
      icon: const Icon(
        Icons.language,
        color: Colors.white,
      ),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.white),
      underline: Container(
        height: 1,
        color: Colors.white,
      ),
      onChanged: (String newValue) {
        langData.setLang(context, newValue);
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['EN', 'AR'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Container(
            height: 18,
            padding: EdgeInsets.only(right: 3),
            child: Text(
              value,
            ),
          ),
        );
      }).toList(),
    );
  }
}
