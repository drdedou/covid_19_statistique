import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

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

  Future<void> getLocation(BuildContext context) async {
    final lang = DemoLocalizations.of(context).getTraslat;
    bool error = false;
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    try {
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      _locationData = await location.getLocation();

      List<Placemark> placemark = await geolocator.placemarkFromCoordinates(
          _locationData.latitude, _locationData.longitude);
      Provider.of<Flags>(context, listen: false)
          .setCountry(placemark.first.isoCountryCode);
    } catch (_) {
      if (error) {
        showLongToast(lang('er_location_disable'));
      } else {
        showLongToast(lang('er_permission'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = DemoLocalizations.of(context).getTraslat;
    return AppBar(
      backgroundColor: Palette.primaryColor,
      elevation: 0.0,
      leading: IconButton(
        icon: const Icon(Icons.gps_fixed),
        iconSize: 26.0,
        onPressed: () async {
          await getLocation(context);
        },
      ),
      title: Text(
        lang('title'),
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        FlatButton(
          child: DropDownMenu(),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
