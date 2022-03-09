import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../globals.dart' as globals;
import '../indiviual_widgets/circle_profile_picture.dart';
import '../controllers/match_controller.dart';
import '../controllers/user_controller.dart';
import '../controllers/auth_controller.dart';
import '../main_pages/main_landing.dart';

class AccountInfo extends StatelessWidget {
  final Map matchDoc;
  final String matchDocId;
  final String myUid;
  final user;

  const AccountInfo({
    Key? key,
    required this.matchDoc,
    required this.myUid,
    required this.matchDocId,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final nameController = TextEditingController();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(30),
          child: Text(
            'Account Settings',
            style: TextStyle(
              fontSize: 25,
              color: globals.secondaryColor,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile Image',
                style: TextStyle(
                  color: globals.secondaryColor,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  Column(
                    children: [
                      CircleProfilePicture(
                        backgroundImage: matchDoc['userMaps'][myUid]
                            ['profilePicture'],
                        radius: globals.getwidth(context) * .14,
                      ),
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: globals.tertiaryColor,
                              title: Text(
                                'Unset Profile Picture?',
                                style: TextStyle(
                                  color: globals.secondaryColor,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: globals.secondaryColor,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    var tempUserMaps = matchDoc['userMaps'];
                                    tempUserMaps[myUid]['profilePicture'] = '';
                                    MatchController.instance
                                        .updateMatchDocument(matchDocId,
                                            'userMaps', tempUserMaps);
                                    Get.offAll(
                                      () => MainLanding(
                                        user: myUid,
                                        myUid: myUid,
                                        connected: true,
                                        matchDocId: matchDocId,
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'OK',
                                    style: TextStyle(
                                      color: globals.secondaryColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        child: Text(
                          'Click to unset',
                          style: TextStyle(
                            color: globals.secondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'E-mail',
                style: TextStyle(
                  color: globals.secondaryColor,
                ),
              ),
              TextField(
                style: TextStyle(
                  color: globals.secondaryColor,
                ),
                enabled: false,
                controller: emailController,
                obscureText: false,
                decoration: globals.textFieldDecoration(
                  matchDoc['userMaps'][myUid]['email'],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name',
                style: TextStyle(
                  color: globals.secondaryColor,
                ),
              ),
              TextField(
                style: TextStyle(
                  color: globals.secondaryColor,
                ),
                controller: nameController,
                obscureText: false,
                decoration: globals.textFieldDecoration(
                  matchDoc['userMaps'][myUid]['name'],
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            var tempUserMaps = matchDoc['userMaps'];
            tempUserMaps[myUid]['name'] = nameController.text;
            MatchController.instance.updateMatchDocument(
              matchDocId,
              'userMaps',
              tempUserMaps,
            );
            UserController.instance
                .updateUserDocument(myUid, 'name', nameController.text);
            Get.offAll(
              () => MainLanding(
                user: user,
                connected: true,
                matchDocId: matchDocId,
                myUid: myUid,
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.all(30),
            alignment: Alignment.center,
            child: Container(
              height: globals.getHeight(context) * .04,
              width: globals.getwidth(context) * .6,
              child: const Image(
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
            child: SizedBox(
              height: globals.getHeight(context) * .04,
              width: globals.getwidth(context) * .4,
              child: const Image(
                image: AssetImage('img/log-out-btn.png'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
