import 'package:flutter/material.dart';

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

                // RichText(
                //     text: TextSpan(
                //         text: 'Test Id',
                //         style: TextStyle(
                //             fontWeight: FontWeight.bold, color: Colors.black),
                //         children: [
                //       TextSpan(
                //           text: 'comment herreasdasd',
                //           style: TextStyle(color: Colors.grey[500]))
                //     ])),
                // Text('time here'),
              ],
            ),
            Container(
              child: Icon(Icons.delete),
            )
          ],
        ));
  }
}
