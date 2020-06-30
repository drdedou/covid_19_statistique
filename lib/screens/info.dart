import 'package:flutter/material.dart';

import '../config/palette.dart';
import '../widgets/custom_app_bar.dart';

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.primaryColor,
      appBar: CustomAppBar(),
      body: Container(
        child: Container(),
      ),
    );
  }
}
