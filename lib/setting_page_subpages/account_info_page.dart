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

    var tempDoc;
    var tempUserDocs = [];

    // print(snapshot.data![0]['userDocs'][0][user.uid]['name']);
    print(user.uid);
    print(snapshot.data![1]['name']);

    snapshot.data![0]['userDocs'].forEach((userDoc) {
      if (userDoc[user.uid] != null) {
        tempDoc = userDoc;
      }
    });
    // snapshot.data![0]['userDocs'].forEach((userDoc) {
    //   if (userDoc[user.uid]['name'] == snapshot.data![1]['name']) {
    //     tempDoc = userDoc[user.uid];
    //   }
    // });

    print(tempDoc);

    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.all(30),
          child: Text('Account Settings',
              style: TextStyle(
                fontSize: 25,
              )),
        ),
        Container(
            margin: EdgeInsets.all(15),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Profile Image'),
              Row(
                children: [
                  Expanded(child: Container()),
                  Column(
                    children: [
                      CircleAvatar(
                          backgroundColor: Colors.grey[500],
                          radius: MediaQuery.of(context).size.width * .14,
                          backgroundImage:
                              (tempDoc[user.uid]['profilePicture'] == '')
                                  ? AssetImage('img/profile.png')
                                  : NetworkImage(
                                          tempDoc[user.uid]['profilePicture'])
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
                                          snapshot.data![0]['userDocs']
                                              .forEach((userDoc) {
                                            if (userDoc[user.uid] != null) {
                                              userDoc[user.uid]
                                                  ['profilePicture'] = '';
                                              tempUserDocs.add(userDoc);
                                            } else
                                              tempUserDocs.add(userDoc);
                                          });
                                          MatchController.instance
                                              .updateMatchDocument(
                                                  snapshot.data![0].id,
                                                  'userDocs',
                                                  tempUserDocs);
                                          Get.offAll(() => MainPage(
                                              user: user,
                                              connected: true,
                                              matchDocId: matchDocId));
                                        },
                                        child: Text(
                                          'OK',
                                        ),
                                      )
                                    ],
                                  ));

                          // tempDoc[user.uid]['profilePicture'] = '';
                        },
                        child: Text('unset'),
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
              ),
              LogInput(
                inputIcon: Icon(Icons.email_rounded),
                inputText: user.email,
                controller: emailController,
                obscure: false,
                enabled: false,
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
              Text('Screen Name'),
              LogInput(
                inputIcon: Icon(Icons.email_rounded),
                inputText: snapshot.data![1]['name'],
                controller: screenNameController,
                obscure: false,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            var userDocs = snapshot.data![0]['userDocs'];
            userDocs.forEach((myDoc) {
              if (myDoc[user.uid] != null) {
                myDoc[user.uid]['name'] = screenNameController.text;
              }
            });
            var screenNames = snapshot.data![0]['screenNames'];
            var newScreenNames = [];
            UserController.instance.updateUserDocument(
                snapshot.data![1].id, 'name', screenNameController.text);
            MatchController.instance
                .updateMatchDocument(matchDocId, 'userDocs', userDocs);
            screenNames.forEach((user) {
              print('user');
              print(user);
              print(snapshot.data![1]['name']);
              if (user == snapshot.data![1]['name']) {
                newScreenNames.add(screenNameController.text);
              } else {
                newScreenNames.add(user);
              }
            });
            MatchController.instance.updateMatchDocument(
                snapshot.data![0].id, 'screenNames', newScreenNames);
            Get.offAll(() =>
                MainPage(user: user, connected: true, matchDocId: matchDocId));
          },
          child: Container(
            margin: EdgeInsets.all(30),
            alignment: Alignment.center,
            child: LogBtn(
                btnText: 'Update',
                btnWidth: MediaQuery.of(context).size.width * .7,
                btnHeight: MediaQuery.of(context).size.height * .05,
                btnFontSize: 20),
          ),
        ),
        GestureDetector(
          onTap: () {
            AuthController.instance.logout();
          },
          child: Container(
            alignment: Alignment.center,
            child: LogBtn(
                btnText: 'Log Out',
                btnWidth: MediaQuery.of(context).size.width * .5,
                btnHeight: MediaQuery.of(context).size.height * .04,
                btnFontSize: 15),
          ),
        )
      ],
    ));
  }
}
