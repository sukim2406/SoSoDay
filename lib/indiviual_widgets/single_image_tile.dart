import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:soso_day/controllers/match_controller.dart';

import '../globals.dart' as globals;
import '../indiviual_widgets/dropdown_menu.dart';
import '../indiviual_widgets/circle_profile_picture.dart';
import '../indiviual_widgets/show_dialog.dart';

class SingleImageTile extends StatelessWidget {
  final Map matchDoc;
  final String matchDocId;
  final int index;
  final String myUid;

  const SingleImageTile({
    Key? key,
    required this.matchDoc,
    required this.matchDocId,
    required this.index,
    required this.myUid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController commentController = TextEditingController();

    return Container(
      color: globals.primaryColor,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              children: [
                Text(
                  matchDoc['images'][index]['title'],
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Container(),
                ),
                DropdownMenu(
                    matchDocId: matchDocId,
                    myUid: myUid,
                    matchDoc: matchDoc,
                    index: index),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 15),
            child: Row(
              children: [
                Expanded(
                  child: Container(),
                ),
                Text(
                  matchDoc['images'][index]['time']
                      .toDate()
                      .toString()
                      .substring(0, 10),
                  style: const TextStyle(color: Colors.grey),
                ),
                Container(
                  width: 20,
                ),
                Text(
                  matchDoc['userMaps'][matchDoc['images'][index]['creator']]
                      ['name'],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Image.network(
              matchDoc['images'][index]['downloadUrl'],
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Text(matchDoc['images'][index]['about']),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, bottom: 0),
            child: Row(
              children: [
                (matchDoc['images'][index]['comments'].length > 0)
                    ? (matchDoc['images'][index]['comments'].length == 1)
                        ? Row(
                            children: [
                              CircleProfilePicture(
                                backgroundImage: matchDoc['userMaps'][
                                    matchDoc['images'][index]['comments'][0]
                                        ['creator']]['profilePicture'],
                                radius: 15,
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 10),
                                width: (matchDoc['images'][index]['comments'][0]
                                            ['creator'] ==
                                        myUid)
                                    ? globals.getwidth(context) * .5
                                    : globals.getwidth(context) * .6,
                                child: RichText(
                                  text: TextSpan(
                                    text: matchDoc['images'][index]['comments']
                                        [0]['comment'],
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                              Container(
                                width: globals.getwidth(context) * .25,
                                child: RichText(
                                  text: TextSpan(
                                    text: matchDoc['images'][0]['time']
                                        .toDate()
                                        .toString()
                                        .substring(0, 10),
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ),
                              ),
                              (matchDoc['images'][index]['comments'][0]
                                          ['creator'] ==
                                      myUid)
                                  ? ShowDialog(
                                      title: 'Delete Comment?',
                                      function: MatchController.instance
                                          .deleteComments(matchDocId, index, 0),
                                      icon: Icons.delete)
                                  : Container(),
                            ],
                          )
                        : TextButton(
                            onPressed: () {},
                            child: RichText(
                              text: TextSpan(
                                text: 'View all ',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                ),
                                children: [
                                  TextSpan(
                                    text: matchDoc['images'][index]['comments']
                                        .length
                                        .toString(),
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' comments',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                    : Text(
                        'no comments yet',
                        style: TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    style: const TextStyle(fontSize: 15, height: 1),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'write comments here',
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (commentController.text.isNotEmpty) {
                      Map<String, dynamic> commentData = {
                        'comment': commentController.text,
                        'time': Timestamp.now(),
                        'creator': myUid,
                      };
                      ShowDialog(
                        title: 'Post Comment',
                        function: MatchController.instance
                            .updateComments(matchDocId, index, commentData)
                            .then((value) {
                          Navigator.pop(context);
                        }),
                        icon: Icons.send,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
