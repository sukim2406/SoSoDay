import 'package:flutter/material.dart';
import 'package:soso_day/controllers/match_controller.dart';

import '../controllers/user_controller.dart';

class CommentTile extends StatelessWidget {
  final matchDocId;
  final user;
  final imageData;
  final imageIndex;
  final commentIndex;

  const CommentTile(
      {Key? key,
      required this.matchDocId,
      required this.user,
      required this.imageData,
      required this.imageIndex,
      required this.commentIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(bottom: 15),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(right: 15),
              child: CircleAvatar(
                  radius: 20,
                  child: Image(image: AssetImage('img/profile.png'))),
            ),
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * .7,
                  child: Text(imageData['images'][imageIndex]['comments']
                      [commentIndex]['comment']),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .7,
                  child: Row(
                    children: [
                      Container(
                        child: Text(
                            imageData['images'][imageIndex]['comments']
                                    [commentIndex]['time']
                                .toDate()
                                .toString()
                                .substring(0, 16),
                            style: TextStyle(color: Colors.grey[500])),
                      ),
                      Expanded(child: Container())
                    ],
                  ),
                ),
              ],
            ),
            (imageData['images'][imageIndex]['comments'][commentIndex]
                        ['creator'] ==
                    user['name'])
                ? Container(
                    child: GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                      title: Text('Delete Comment?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                            onPressed: () async {
                                              await MatchController.instance
                                                  .deleteComments(matchDocId,
                                                      imageIndex, commentIndex);
                                            },
                                            child: Text('OK'))
                                      ]));
                          // await MatchController.instance
                          //     .deleteComments(matchDocId, imageIndex, commentIndex);
                        },
                        child: Icon(Icons.delete)),
                  )
                : Container(
                    child: Icon(Icons.access_alarm),
                  )
          ],
        ));
  }
}
