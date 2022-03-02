import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soso_day/controllers/auth_controller.dart';

import '../widgets/log_input.dart';
import '../widgets/log_btn.dart';
import '../main_page.dart';
import '../controllers/user_controller.dart';
import '../controllers/match_controller.dart';

class AccountInfoPage extends StatelessWidget {
  final user;
  final snapshot;
  final matchDocId;

  const AccountInfoPage(
      {Key? key,
      required this.user,
      required this.snapshot,
      required this.matchDocId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final screenNameController = TextEditingController();

    var tempDoc = snapshot.data![0]['userMaps'][user];
    var tempUserDocs;

    // print(snapshot.data![0]['userDocs'][0][user.uid]['name']);
    // print(user.uid);

    // snapshot.data![0]['userDocs'].forEach((userDoc) {
    //   if (userDoc[user] != null) {
    //     tempDoc = userDoc;
    //   }
    // });
    // snapshot.data![0]['userDocs'].forEach((userDoc) {
    //   if (userDoc[user.uid]['name'] == snapshot.data![1]['name']) {
    //     tempDoc = userDoc[user.uid];
    //   }
    // });

    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.all(30),
          child: Text(
            'Account Settings',
            style: TextStyle(
              fontSize: 25,
              color: Color.fromRGBO(85, 74, 53, 1),
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.all(15),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Profile Image',
                style: TextStyle(
                  color: Color.fromRGBO(85, 74, 53, 1),
                ),
              ),
              Row(
                children: [
                  Expanded(child: Container()),
                  Column(
                    children: [
                      CircleAvatar(
                          backgroundColor: Color.fromRGBO(242, 236, 217, 1),
                          radius: MediaQuery.of(context).size.width * .14,
                          backgroundImage: (tempDoc['profilePicture'] == '')
                              ? AssetImage('img/profile.png')
                              : NetworkImage(tempDoc['profilePicture'])
                                  as ImageProvider),
                      TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text('Unset Profile Picture?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          tempUserDocs =
                                              snapshot.data![0]['userMaps'];
                                          tempUserDocs[user]['profilePicture'] =
                                              '';
                                          MatchController.instance
                                              .updateMatchDocument(matchDocId,
                                                  'userMaps', tempUserDocs);
                                          Get.offAll(() => MainPage(
                                              user: user,
                                              connected: true,
                                              matchDocId: matchDocId));
                                          // snapshot.data![0]['userDocs']
                                          //     .forEach((userDoc) {
                                          //   if (userDoc[user] != null) {
                                          //     userDoc[user]['profilePicture'] =
                                          //         '';
                                          //     tempUserDocs.add(userDoc);
                                          //   } else
                                          //     tempUserDocs.add(userDoc);
                                          // });
                                          // MatchController.instance
                                          //     .updateMatchDocument(
                                          //         snapshot.data![0].id,
                                          //         'userDocs',
                                          //         tempUserDocs);
                                          // Get.offAll(() => MainPage(
                                          //     user: user,
                                          //     connected: true,
                                          //     matchDocId: matchDocId));
                                        },
                                        child: Text(
                                          'OK',
                                        ),
                                      )
                                    ],
                                  ));

                          // tempDoc[user.uid]['profilePicture'] = '';
                        },
                        child: Text(
                          'click to unset',
                          style: TextStyle(
                            color: Color.fromRGBO(85, 74, 53, 1),
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(child: Container())
                ],
              )
            ])),
        Container(
          margin: EdgeInsets.all(15),
          // height:
          //     MediaQuery.of(context).size.height * .06,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'E-mail',
                style: TextStyle(
                  color: Color.fromRGBO(85, 74, 53, 1),
                ),
              ),
              TextField(
                style: TextStyle(
                  color: Color.fromRGBO(85, 74, 53, 1),
                ),
                enabled: false,
                controller: emailController,
                obscureText: false,
                decoration: InputDecoration(
                    hintText: tempDoc['email'],
                    hintStyle: TextStyle(color: Color.fromRGBO(85, 74, 53, 1)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(85, 74, 53, 1)))),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.all(15),
          // height:
          //     MediaQuery.of(context).size.height * .06,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Screen Name',
                style: TextStyle(
                  color: Color.fromRGBO(85, 74, 53, 1),
                ),
              ),
              TextField(
                style: TextStyle(
                  color: Color.fromRGBO(85, 74, 53, 1),
                ),
                controller: screenNameController,
                obscureText: false,
                decoration: InputDecoration(
                    hintText: tempDoc['name'],
                    hintStyle: TextStyle(color: Color.fromRGBO(85, 74, 53, 1)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(85, 74, 53, 1))),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(85, 74, 53, 1)))),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            // var userDocs = snapshot.data![0]['userDocs'];
            // userDocs.forEach((myDoc) {
            //   if (myDoc[user.uid] != null) {
            //     myDoc[user.uid]['name'] = screenNameController.text;
            //   }
            // });
            // var screenNames = snapshot.data![0]['screenNames'];
            // var newScreenNames = [];
            // UserController.instance.updateUserDocument(
            //     snapshot.data![1].id, 'name', screenNameController.text);
            // MatchController.instance
            //     .updateMatchDocument(matchDocId, 'userDocs', userDocs);
            // screenNames.forEach((user) {
            //   print('user');
            //   print(user);
            //   print(snapshot.data![1]['name']);
            //   if (user == snapshot.data![1]['name']) {
            //     newScreenNames.add(screenNameController.text);
            //   } else {
            //     newScreenNames.add(user);
            //   }
            // });
            var tempUserMaps = snapshot.data![0]['userMaps'];
            tempUserMaps[user]['name'] = screenNameController.text;
            MatchController.instance.updateMatchDocument(
                snapshot.data![0].id, 'userMaps', tempUserMaps);
            UserController.instance
                .updateUserDocument(user, 'name', screenNameController.text);
            Get.offAll(() =>
                MainPage(user: user, connected: true, matchDocId: matchDocId));
          },
          child: Container(
            margin: EdgeInsets.all(30),
            alignment: Alignment.center,
            child: Container(
              height: MediaQuery.of(context).size.height * .04,
              width: MediaQuery.of(context).size.width * .6,
              child: Image(
                image: AssetImage('img/save-btn.png'),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            AuthController.instance.logout();
          },
          child: Container(
            margin: EdgeInsets.all(30),
            alignment: Alignment.center,
            child: Container(
              height: MediaQuery.of(context).size.height * .04,
              width: MediaQuery.of(context).size.width * .4,
              child: Image(
                image: AssetImage('img/log-out-btn.png'),
              ),
            ),
          ),
        )
      ],
    ));
  }
}
