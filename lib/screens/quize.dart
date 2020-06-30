import 'package:flutter/material.dart';

import '../config/palette.dart';
import '../config/styles.dart';
import '../localization/demo_localizations.dart';
import '../widgets/custom_app_bar.dart';

class Quize extends StatefulWidget {
  @override
  _QuizeState createState() => _QuizeState();
}

class _QuizeState extends State<Quize> {
  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;
    final lang = DemoLocalizations.of(context).getTraslat;
    return Scaffold(
      backgroundColor: Palette.primaryColor,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomCenter,
              overflow: Overflow.visible,
              children: [
                Container(
                  height: widthScreen / 2,
                  width: widthScreen,
                  color: Palette.primaryColor,
                  child: ClipImage(widthScreen: widthScreen),
                ),
                Positioned(
                  bottom: -55,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.shade600,
                    ),
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      lang('pastor_title'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 23.0,
                        fontWeight: FontWeight.w200,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(top: 70, bottom: 20),
              width: widthScreen * 0.8,
              child: Text(
                lang('pastor_discription'),
                style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 50),
              child: FlatButton.icon(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 20.0,
                ),
                onPressed: () {},
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                icon: const Icon(
                  Icons.event_note,
                  color: Colors.white,
                ),
                label: Text(
                  lang('ask_btn'),
                  style: Styles.buttonTextStyle,
                ),
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClipImage extends StatelessWidget {
  const ClipImage({
    Key key,
    @required this.widthScreen,
  }) : super(key: key);

  final double widthScreen;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(0),
        bottomRight: Radius.circular(0),
      ),
      child: Container(
        height: (widthScreen / 2),
        width: widthScreen,
        child: Image(
          image: AssetImage('assets/images/pasteur.jpg'),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      ),
    );
  }
}
