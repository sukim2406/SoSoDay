import 'package:flutter/material.dart';

import '../globals.dart' as globals;
import '../indiviual_widgets/circle_profile_picture.dart';

class WelComePageFinal extends StatelessWidget {
  final matchDoc;
  const WelComePageFinal({Key? key, required this.matchDoc}) : super(key: key);

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);

    return (to.difference(from).inHours / 24).round();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            width: globals.getwidth(context),
            height: globals.getHeight(context) * .6,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: (matchDoc['backgroundImage'] == '')
                    ? const AssetImage('img/welcomepage.png')
                    : NetworkImage(matchDoc['backgroundImage'])
                        as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: globals.getwidth(context),
            color: Colors.white,
            child: Column(
              children: [
                RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      TextSpan(
                          text: 'Together since ',
                          style: TextStyle(color: Colors.grey[500])),
                      TextSpan(
                          text: matchDoc['since']
                              .toDate()
                              .toString()
                              .substring(0, 10)),
                      TextSpan(
                          text: ' counting ',
                          style: TextStyle(color: Colors.grey[500])),
                      TextSpan(
                          text: daysBetween(
                                  matchDoc['since'].toDate(), DateTime.now())
                              .toString()),
                      TextSpan(text: ' days!'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: globals.getwidth(context),
            height: globals.getHeight(context) * .2,
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Container(),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleProfilePicture(
                          radius: globals.getwidth(context) * .14,
                          backgroundImage: matchDoc['userMaps']
                              [matchDoc['couple'][0]]['profilePicture']),
                      Text(
                        matchDoc['userMaps'][matchDoc['couple'][0]]['name']
                            .toString(),
                        style: globals.welcomeUserNameStyle,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: globals.getwidth(context) * .1,
                  child: const Image(
                    image: AssetImage('img/heart-small.png'),
                  ),
                ),
                Container(
                  width: globals.getwidth(context) * .3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleProfilePicture(
                        radius: globals.getwidth(context) * .14,
                        backgroundImage: matchDoc['userMaps']
                            [matchDoc['couple'][1]]['profilePicture'],
                      ),
                      Text(
                        matchDoc['userMaps'][matchDoc['couple'][1]]['name']
                            .toString(),
                        style: globals.welcomeUserNameStyle,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
