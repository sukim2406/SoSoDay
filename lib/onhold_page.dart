import 'package:flutter/material.dart';

class OnholdPage extends StatelessWidget {
  const OnholdPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        'Waiting for Him/Her',
        style: TextStyle(fontSize: 60),
      ),
    );
  }
}
