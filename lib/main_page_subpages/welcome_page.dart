/*
for love icon img
Paste this link on the website where your app is available for download or in the description section of the platform or marketplace you’re using.
<a href="https://www.flaticon.com/free-icons/love" title="love icons">Love icons created by Freepik - Flaticon</a>
<a href="https://www.flaticon.com/free-icons/heart" title="heart icons">Heart icons created by Freepik - Flaticon</a>
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:soso_day/controllers/auth_controller.dart';
import 'package:soso_day/controllers/match_controller.dart';
import 'package:soso_day/controllers/user_controller.dart';

import '../widgets/log_btn.dart';

class WelcomePage extends StatelessWidget {
  final user;
  final matchDocId;
  const WelcomePage({Key? key, required this.user, required this.matchDocId})
      : super(key: key);

  Future getMyScreenName() async {
    var doc = await FirebaseFirestore.instance
        .collection('matches')
        .where('couple', arrayContains: matchDocId)
        .get();

    return doc.docs[0]['couple'];
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);

    return (to.difference(from).inHours / 24).round();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('matches')
          .doc(matchDocId)
          .snapshots(),
      // future: MatchController.instance.getMatchDocById(matchDocId),
      // future: getMyScreenName(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError || !snapshot.hasData) {
          return Text('error');
        }
        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;
        return Column(
          children: [
            Container(
              width: width,
              height: height * .60,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: (data['backgroundImage'] == '')
                    ? AssetImage('img/welcomepage.png')
                    : NetworkImage(data['backgroundImage']) as ImageProvider,
                // image: AssetImage('img/signup.png'),
                fit: BoxFit.cover,
              )),
              // child: Column(
              //   children: [
              //     SizedBox(
              //       height: height * .30,
              //     ),
              //     CircleAvatar(
              //       backgroundColor: Colors.white70,
              //       radius: 80,
              //       backgroundImage: (data['profileImage'] == null)
              //           ? AssetImage('img/profile.png')
              //           : NetworkImage(data['profileImage']) as ImageProvider,
              //     ),
              //     Row()
              //   ],
              // ),
            ),
            Container(
              width: width,
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
                          text: data['since']
                              .toDate()
                              .toString()
                              .substring(0, 10)),
                      TextSpan(
                          text: ' counting ',
                          style: TextStyle(color: Colors.grey[500])),
                      TextSpan(
                          text: daysBetween(
                                  data['since'].toDate(), DateTime.now())
                              .toString()),
                      TextSpan(text: ' days!'),
                    ],
                  ))
                ],
              ),
            ),
            Container(
              width: width,
              height: height * .20,
              color: Colors.white,
              // decoration: BoxDecoration(color: Colors.grey),
              child: Row(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                    width: width * .3,
                    // decoration: BoxDecoration(color: Colors.amber),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey[500],
                          radius: width * .14,
                          backgroundImage: (data['userDocs'][0]
                                          [data['couple'][0]]['profilePicture']
                                      .toString() ==
                                  '')
                              ? AssetImage('img/profile.png')
                              : NetworkImage(data['userDocs'][0]
                                      [data['couple'][0]]['profilePicture'])
                                  as ImageProvider,
                        ),
                        Text(
                          data['userDocs'][0][data['couple'][0]]['name']
                              .toString(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Container(
                      width: width * .1,
                      // decoration: BoxDecoration(color: Colors.blue),
                      child: Image(
                        image: AssetImage('img/heart-small.png'),
                      )),
                  Container(
                    width: width * .3,
                    // decoration: BoxDecoration(color: Colors.amber),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey[500],
                          radius: width * .14,
                          backgroundImage: (data['userDocs'][1]
                                      [data['couple'][1]]['profilePicture'] ==
                                  '')
                              ? AssetImage('img/profile.png')
                              : NetworkImage(data['userDocs'][1]
                                      [data['couple'][1]]['profilePicture'])
                                  as ImageProvider,
                        ),
                        Text(
                          data['userDocs'][1][data['couple'][1]]['name']
                              .toString(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(color: Colors.white),
            )
          ],
        );
      },
    );
  }
}
