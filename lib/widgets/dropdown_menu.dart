import 'package:flutter/material.dart';
import 'package:soso_day/controllers/match_controller.dart';

class DropdownMenu extends StatelessWidget {
  final matchDocId;
  final user;
  final data;
  final index;
  const DropdownMenu(
      {Key? key,
      required this.matchDocId,
      required this.user,
      required this.data,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List dropdownList = [
      () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Set as profile picture?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                        onPressed: () async {
                          var userDocs = await MatchController.instance
                              .getUserDocs(matchDocId);
                          userDocs.forEach((userDoc) {
                            if (userDoc[user['uid']] != null) {
                              userDoc[user['uid']]['profilePicture'] =
                                  data['images'][index]['downloadUrl'];
                            }
                          });
                          MatchController.instance.updateMatchDocument(
                              matchDocId, 'userDocs', userDocs);
                          Navigator.pop(context);
                        },
                        child: Text('OK'))
                  ],
                ));
      },
      () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                    title: Text('Set as background picture?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                          onPressed: () async {
                            MatchController.instance.updateMatchDocument(
                                matchDocId,
                                'backgroundImage',
                                data['images'][index]['downloadUrl']);
                            Navigator.pop(context);
                          },
                          child: Text('OK'))
                    ]));
      },
      () {
        print('menu 3');
      },
    ];
    return Container(
        child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
          icon: const Icon(Icons.more_vert),
          items: (data['images'][index]['creator'] == user['name'])
              ? [
                  'Set as profile image',
                  'Set as background image',
                  'Delete image'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                      value: value, child: Text(value));
                }).toList()
              : [
                  'Set as profile image',
                  'Set as background image',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                      value: value, child: Text(value));
                }).toList(),
          onChanged: (String? newValue) {
            if (newValue == 'Set as profile image') {
              dropdownList[0]();
            } else if (newValue == 'Set as background image') {
              dropdownList[1]();
            } else {
              dropdownList[2]();
            }
          }),
    ));
  }
}
