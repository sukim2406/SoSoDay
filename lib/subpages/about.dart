import 'package:flutter/material.dart';

import '../globals.dart' as globals;

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: globals.tertiaryColor,
      height: globals.getHeight(context) * .8,
      width: globals.getwidth(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '하루종일',
            style: TextStyle(
              color: globals.secondaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          const Text('Personal project developed by'),
          const SizedBox(
            height: 25,
          ),
          RichText(
            text: TextSpan(
              text: 'Soun Sean Kim',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: globals.secondaryColor,
              ),
              children: const [
                TextSpan(
                  text: ' of ',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                TextSpan(
                  text: 'SOSODEV',
                ),
              ],
            ),
          ),
          const Text('ssk.sosodev@gmail.com'),
          const SizedBox(
            height: 25,
          ),
          const Text(
            'Tools used',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text('Frontend : Flutter'),
          const Text('Backend / Storage : Google Firebase'),
          SizedBox(
            width: globals.getwidth(context) * .5,
            child:
                const Text('Image : Heart icons created by Freepik - Flaticon'),
          )
        ],
      ),
    );
  }
}
