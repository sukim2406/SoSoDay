import 'package:flutter/material.dart';

import '../globals.dart' as globals;

class AppbarPadding extends StatelessWidget {
  const AppbarPadding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'padd',
      style: TextStyle(color: globals.primaryColor),
    );
  }
}
