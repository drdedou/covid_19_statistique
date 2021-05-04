import 'package:country_codes/country_codes.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import '../models/featureConst.dart';
import '../localization/demo_localizations.dart';
import '../localization/flags.dart';
import '../config/palette.dart';
import './drop_down_menu.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  void showLongToast(String msg) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: "$msg",
      toastLength: Toast.LENGTH_LONG,
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> getLocation(BuildContext context) async {
    await CountryCodes
        .init(); // Optionally, you may provide a `Locale` to get countrie's localizadName

    final Locale deviceLocale = CountryCodes.getDeviceLocale();
    print(deviceLocale.languageCode); // Displays en
    print(deviceLocale.countryCode); // Displays US

    //final position = await _determinePosition();

    Provider.of<Flags>(context, listen: false)
        .setCountry(deviceLocale.countryCode);
  }

  @override
  Widget build(BuildContext context) {
    final lang = DemoLocalizations.of(context).getTraslat;
    return AppBar(
      backgroundColor: Palette.primaryColor,
      elevation: 0.0,
      leading: DescribedFeatureOverlay(
        featureId: gps1,
        tapTarget: const Icon(Icons.gps_fixed),
        backgroundColor: colorFeature[1],
        contentLocation: ContentLocation.below,
        title: Text(lang("intro_gps1")),
        child: IconButton(
          icon: const Icon(Icons.gps_fixed),
          iconSize: 26.0,
          onPressed: () async {
            await getLocation(context);
          },
        ),
      ),
      title: Text(
        lang('title'),
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        TextButton(
          child: DescribedFeatureOverlay(
            featureId: language2,
            tapTarget: const Icon(Icons.language),
            backgroundColor: colorFeature[2],
            contentLocation: ContentLocation.below,
            title: Text(lang("intro_language2")),
            child: DropDownMenu(),
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
