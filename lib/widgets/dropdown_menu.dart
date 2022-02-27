import 'package:flutter/material.dart';
import 'package:soso_day/controllers/match_controller.dart';
import '../controllers/user_controller.dart';

class DropdownMenu extends StatelessWidget {
  final matchDocId;
  final user;
  final data;
  final index;
  final userId;

  const DropdownMenu(
      {Key? key,
      required this.matchDocId,
      required this.user,
      required this.data,
      required this.index,
      required this.userId})
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
                          var tempUserMaps = data['userMaps'];
                          tempUserMaps[userId]['profilePicture'] =
                              data['images'][index]['downloadUrl'];

                          MatchController.instance.updateMatchDocument(
                              matchDocId, 'userMaps', tempUserMaps);
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
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Delete this iamge?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                        onPressed: () async {
                          MatchController.instance.deleteAnImage(
                              matchDocId, data['images'][index]['downloadUrl']);
                          Navigator.pop(context);
                        },
                        child: Text('OK')),
                  ],
                ));
      },
    ];
    return Container(
        child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
          icon: const Icon(
            Icons.more_vert,
            color: Color.fromRGBO(85, 74, 53, 1),
          ),
          items: (data['images'][index]['creator'] == userId)
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
