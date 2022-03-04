import 'package:flutter/material.dart';

import '../globals.dart' as globals;
import './circle_profile_picture.dart';
import './show_dialog.dart';
import '../controllers/match_controller.dart';

class Comment extends StatelessWidget {
  final String matchDocId;
  final Map matchDoc;
  final String myUid;
  final Map image;
  final int index;
  final int imageIndex;

  const Comment({
    Key? key,
    required this.matchDocId,
    required this.myUid,
    required this.image,
    required this.index,
    required this.imageIndex,
    required this.matchDoc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(right: 15),
            child: CircleProfilePicture(
              backgroundImage: matchDoc['userMaps']
                  [image['comments'][index]['creator']]['profilePicture'],
              radius: 20,
            ),
          ),
          Column(
            children: [
              SizedBox(
                width: globals.getwidth(context) * .7,
                child: Text(
                  image['comments'][index]['comment'],
                ),
              ),
              SizedBox(
                width: globals.getwidth(context) * .7,
                child: Row(
                  children: [
                    Text(
                      image['comments'][index]['time']
                          .toDate
                          .toString()
                          .substring(0, 16),
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          (image['comments'][index]['creator'] == myUid)
              ? ShowDialog(
                  title: 'Delete Comment?',
                  function: MatchController.instance
                      .deleteComments(matchDocId, imageIndex, index),
                  icon: Icons.delete)
              : const Icon(Icons.access_alarm),
        ],
      ),
    );
  }
}
