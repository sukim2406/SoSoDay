import 'package:flutter/material.dart';

import '../controllers/match_controller.dart';
import '../globals.dart' as globals;

class DropdownMenu extends StatelessWidget {
  final String matchDocId;
  final String myUid;
  final Map matchDoc;
  final int index;

  const DropdownMenu({
    Key? key,
    required this.matchDocId,
    required this.myUid,
    required this.matchDoc,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List dropdownList = [
      () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Set as profile picture?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                        onPressed: () async {
                          var tempUserMaps = matchDoc['userMaps'];
                          tempUserMaps[myUid]['profilePicture'] =
                              matchDoc['images'][index]['downloadUrl'];

                          MatchController.instance.updateMatchDocument(
                              matchDocId, 'userMaps', tempUserMaps);
                          Navigator.pop(context);
                        },
                        child: const Text('OK'))
                  ],
                ));
      },
      () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                    title: const Text('Set as background picture?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                          onPressed: () async {
                            MatchController.instance.updateMatchDocument(
                                matchDocId,
                                'backgroundImage',
                                matchDoc['images'][index]['downloadUrl']);
                            Navigator.pop(context);
                          },
                          child: const Text('OK'))
                    ]));
      },
      () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Delete this iamge?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                        onPressed: () async {
                          MatchController.instance.deleteAnImage(matchDocId,
                              matchDoc['images'][index]['downloadUrl']);
                          Navigator.pop(context);
                        },
                        child: const Text('OK')),
                  ],
                ));
      },
    ];
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        icon: Icon(
          Icons.more_vert,
          color: globals.secondaryColor,
        ),
        items: (matchDoc['images'][index]['creator'] == myUid)
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
        },
      ),
    );
  }
}
