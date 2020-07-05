import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import '../localization/demo_localizations.dart';
import '../config/styles.dart';
import '../config/palette.dart';
import '../widgets/custom_app_bar.dart';

class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  void changeIndexDonate(int newVal) {
    setState(() {
      indexDonate = newVal;
    });
  }

  void changeindexShowseDonate(num newVal) {
    setState(() {
      indexShowseDonate = newVal;
    });
  }

  int indexDonate = 2;
  int indexShowseDonate = 50;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final lang = DemoLocalizations.of(context).getTraslat;
    return Scaffold(
      backgroundColor: Palette.primaryColor,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: width - 20,
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: Container(
              child: Column(
                children: [
                  Card(
                    elevation: 5,
                    child: Container(
                      width: width - 20,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              "Alpha Programming",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "madjidi.idris.official@gmail.com",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade800,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 5,
                    child: Container(
                      width: width - 20,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              lang("donate"),
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              lang("donate_for"),
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade800,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: ChooseWord(
                                changeIndexDonate: changeIndexDonate,
                                changeindexShowseDonate:
                                    changeindexShowseDonate,
                                indexDonate: indexDonate,
                                indexShowseDonate: indexShowseDonate,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 50),
                              child: FlatButton.icon(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 20.0,
                                ),
                                onPressed: () {
                                  donate(indexDonate, indexShowseDonate);
                                },
                                color: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                icon: const Icon(
                                  Icons.payment,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  lang('donate'),
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                textColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void donate(int indexDonate, int indexShowseDonate) {
  print('indexDonate $indexDonate');
  print('indexShowseDonate $indexShowseDonate');
}

class ChooseWord extends StatefulWidget {
  final Function changeIndexDonate;
  final Function changeindexShowseDonate;
  final int indexDonate;
  final int indexShowseDonate;

  const ChooseWord(
      {this.changeIndexDonate,
      this.changeindexShowseDonate,
      this.indexDonate,
      this.indexShowseDonate});
  @override
  _ChooseWordState createState() => _ChooseWordState();
}

class _ChooseWordState extends State<ChooseWord> {
  final int maxInt = 4294967296;
  List<String> data = ['', '35€', '50€', '80€', '150€'];

  Widget _buildListItem(BuildContext context, int index) {
    return data[index].isEmpty
        ? Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(100),
            ),
            height: 90,
            width: 90,
            child: NumberPicker.integer(
              initialValue: widget.indexShowseDonate,
              minValue: 10,
              maxValue: maxInt,
              step: 20,
              onChanged: widget.changeindexShowseDonate,
              decoration: BoxDecoration(
                  //color: Colors.black,

                  ),
            ),
          )
        : Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(100),
            ),
            height: 40,
            width: 90,
            child: Center(
              child: Text(
                '${data[index]}',
                style: TextStyle(fontSize: 22, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 150,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: ScrollSnapList(
          initialIndex: widget.indexDonate.toDouble(),
          onItemFocus: widget.changeIndexDonate,
          itemSize: 85,
          itemBuilder: _buildListItem,
          itemCount: data.length,
          reverse: true,
          dynamicItemSize: true,
        ),
      ),
    );
  }
}
