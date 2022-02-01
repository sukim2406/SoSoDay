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
              height: height * .35,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('img/signup.png'), fit: BoxFit.cover)),
              child: Column(
                children: [
                  SizedBox(
                    height: height * .15,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white70,
                    radius: 80,
                    backgroundImage: (data['profileImage'] == null)
                        ? AssetImage('img/profile.png')
                        : NetworkImage(data['profileImage']) as ImageProvider,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 70,
            ),
            Container(
                width: width,
                margin: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .3,
                          child: Text(
                            data['screenNames'][0].toString(),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .2,
                          child: CircleAvatar(
                            backgroundColor: Colors.white70,
                            radius: 30,
                            backgroundImage: AssetImage('img/heart.png'),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .3,
                          child: Text(
                            data['screenNames'][1].toString(),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.left,
                          ),
                        )
                      ],
                    )
                  ],
                )),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  RichText(
                      text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: [
                      TextSpan(text: 'Together since '),
                      TextSpan(
                          text: data['since']
                              .toDate()
                              .toString()
                              .substring(0, 10)),
                      TextSpan(text: ' counting '),
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
            SizedBox(height: 200),
            GestureDetector(
                onTap: () {
                  AuthController.instance.logout();
                },
                child: LogBtn(
                  btnText: 'SignOut',
                  btnHeight: height * .08,
                  btnWidth: width * .5,
                  btnFontSize: 36,
                ))
          ],
        );
      },
    );
    // return Column(
    //   children: [
    //     Container(
    //       width: width,
    //       height: height * .35,
    //       decoration: BoxDecoration(
    //           image: DecorationImage(
    //               image: AssetImage('img/signup.png'), fit: BoxFit.cover)),
    //       child: Column(
    //         children: [
    //           SizedBox(
    //             height: height * .15,
    //           ),
    //           CircleAvatar(
    //             backgroundColor: Colors.white70,
    //             radius: 60,
    //             backgroundImage: AssetImage('img/profile.png'),
    //           )
    //         ],
    //       ),
    //     ),
    //     SizedBox(
    //       height: 70,
    //     ),
    //     Container(
    //         width: width,
    //         margin: const EdgeInsets.only(left: 20),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text('Welcome',
    //                 style: TextStyle(
    //                   fontSize: 36,
    //                   fontWeight: FontWeight.bold,
    //                   color: Colors.black,
    //                 )),
    //             Row(
    //               children: [
    //                 Text(
    //                   'haha',
    //                   style: TextStyle(
    //                     fontSize: 18,
    //                     color: Colors.grey[500],
    //                   ),
    //                 ),
    //               ],
    //             )
    //           ],
    //         )),
    //     SizedBox(height: 200),
    //     GestureDetector(
    //         onTap: () {
    //           AuthController.instance.logout();
    //         },
    //         child: LogBtn(
    //           btnText: 'SignOut',
    //           btnHeight: height * .08,
    //           btnWidth: width * .5,
    //           btnFontSize: 36,
    //         ))
    //   ],
    // );
  }
}
