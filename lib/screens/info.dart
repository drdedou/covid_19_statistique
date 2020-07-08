import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:square_in_app_payments/models.dart' as models;
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:built_collection/built_collection.dart';

import '../models/payment.dart';
import '../localization/demo_localizations.dart';
import '../config/palette.dart';
import '../widgets/custom_app_bar.dart';

class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  int pymentVal = 0;
  int indexDonate = 2;
  int indexShowseDonate = 50;

  Future<void> _initSquarePayment() async {
    await InAppPayments.setSquareApplicationId('sq0idp-eZ9KyiQPWliKNqBphfcVtg');

    // await InAppPayments.setSquareApplicationId(
    //     'sandbox-sq0idb-ywoH7LLxL-3kojolvbV2IQ');
  }

  @override
  void initState() {
    _initSquarePayment();
    super.initState();
  }

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

  void donate(int indexDonate, int indexShowseDonate) async {
    pymentVal = 0;
    if (indexDonate > 0) {
      switch (indexDonate) {
        case 1:
          pymentVal = 35;
          break;
        case 2:
          pymentVal = 50;
          break;
        case 3:
          pymentVal = 80;
          break;
        case 4:
          pymentVal = 150;
          break;
        default:
          pymentVal = 50;
      }
    } else if (indexDonate == 0) {
      pymentVal = indexShowseDonate;
    }

    _onStartCardEntryFlowWithBuyerVerification();
  }

  Future<void> _onStartCardEntryFlowWithBuyerVerification() async {
    var money = models.Money((b) => b
      ..amount = pymentVal
      ..currencyCode = 'USD');

    var contact = models.Contact((b) => b
      ..givenName = "Madjidi"
      ..familyName = "Idris"
      ..addressLines =
          new BuiltList<String>(["bousaada", "bousaada"]).toBuilder()
      ..city = "M'Sila"
      ..countryCode = "DZ"
      ..email = "madjidi.idris.official@gmail.com"
      ..phone = "675918496"
      ..postalCode = "28001");

    await InAppPayments.startCardEntryFlowWithBuyerVerification(
      onBuyerVerificationSuccess: _onBuyerVerificationSuccess,
      onBuyerVerificationFailure: _onBuyerVerificationFailure,
      onCardEntryCancel: _onCancelCardEntryFlow,
      buyerAction: "Charge",
      money: money,
      squareLocationId: 'L1EX3YQMW83DJ',
      //squareLocationId: 'S0MQCS8XDFJZM',
      contact: contact,
      collectPostalCode: true,
    );
  }

  void _onCancelCardEntryFlow() {
    // handle the cancel callback
  }

  void _onBuyerVerificationSuccess(
      models.BuyerVerificationDetails result) async {
    final Payment payment = Payment();

    await payment.setPayment(result, pymentVal);
  }

  void _onBuyerVerificationFailure(models.ErrorInfo errorInfo) async {
    // handle the error
  }

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
                              lang('credits'),
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            InkWell(
                              onTap: () => launch(
                                  'https://documenter.getpostman.com/view/8854915/SzS8rjHv?version=latest'),
                              child: Text(
                                "COVID19 API in Postman",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blue,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            InkWell(
                              onTap: () => launch(
                                  'https://dribbble.com/shots/11015463-Covid-19-App-Free'),
                              child: Text(
                                "App Design in dribbble.com",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blue,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            InkWell(
                              onTap: () => launch(
                                  'https://github.com/MarcusNg/flutter_covid_dashboard_ui'),
                              child: Text(
                                "App Design Source Code in github.com",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blue,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            InkWell(
                              onTap: () => launch(
                                  'https://icons8.com/icons/set/coronavirus'),
                              child: Text(
                                "App Icon in icons8.com",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blue,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            InkWell(
                              onTap: () => launch(
                                  'https://www.pexels.com/photo/silver-iphone-6-near-blue-and-silver-stethoscope-48603/'),
                              child: Text(
                                "Photo in Pexels",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blue,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            InkWell(
                              onTap: () => launch(
                                  'https://delegation-numerique-en-sante.github.io/covid19-algorithme-orientation/'),
                              child: Text(
                                "Pasteur Institute Algorithm Covid-19",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blue,
                                ),
                                textAlign: TextAlign.center,
                              ),
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
  List<String> data = ['', '\$35', '\$50', '\$80', '\$150'];
  List<Color> colors = [
    Colors.blue,
    Colors.blue.shade500,
    Colors.blue.shade600,
    Colors.blue.shade700,
    Colors.blue.shade800,
  ];

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
              color: colors[index],
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
