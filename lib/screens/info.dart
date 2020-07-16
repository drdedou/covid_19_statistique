import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../localization/demo_localizations.dart';
import '../config/palette.dart';
import '../widgets/custom_app_bar.dart';

class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
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
                              "Madjidi Idris",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "madjidi.idris.official@gmail.com",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade900,
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
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Text(
                              lang('thanks_discription'),
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade900,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/Univ.png',
                                  height: 100,
                                  width: 100,
                                ),
                                Image.asset(
                                  'assets/images/MI.png',
                                  height: 100,
                                  width: 100,
                                ),
                              ],
                            )
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
