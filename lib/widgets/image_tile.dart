import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:soso_day/controllers/match_controller.dart';
import '../controllers/user_controller.dart';
import '../widgets/comment_page.dart';
import '../widgets/dropdown_menu.dart';

class ImageTile extends StatelessWidget {
  final data;
  final index;
  final matchDocId;
  final userDoc;
  final userId;
  const ImageTile(
      {Key? key,
      required this.userId,
      required this.data,
      required this.matchDocId,
      required this.userDoc,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController commentController = TextEditingController();

    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 15),
            child: Row(
              children: [
                Text(
                  data['images'][index]['title'],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Container(),
                ),
                DropdownMenu(
                    userId: userId,
                    matchDocId: matchDocId,
                    user: userDoc,
                    data: data,
                    index: index)
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 15),
            child: Row(
              children: [
                Expanded(child: Container()),
                Text(
                  data['images'][index]['time']
                      .toDate()
                      .toString()
                      .substring(0, 10),
                  style: TextStyle(color: Colors.grey),
                ),
                Container(
                  width: 20,
                ),
                Text(data['images'][index]['creator']),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Image.network(
              data['images'][index]['downloadUrl'],
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                    child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ));
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Text(data['images'][index]['about']),
          ),
          Container(
              padding: EdgeInsets.only(left: 15, bottom: 0),
              child: Row(
                children: [
                  (data['images'][index]['comments'].length > 0)
                      ? (data['images'][index]['comments'].length == 1)
                          ? Container(
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 15,
                                    backgroundImage:
                                        (userDoc['profilePicture'] == null)
                                            ? AssetImage('img/profile.png')
                                            : NetworkImage(
                                                    userDoc['profilePicture'])
                                                as ImageProvider,
                                    // child: Image(
                                    //   image: (user['profilePicture'] == null)
                                    //       ? AssetImage('img/profile.png')
                                    //       : NetworkImage(user['profilePicture'])
                                    //           as ImageProvider,
                                    // ),
                                  ),
                                  Container(
                                      padding: EdgeInsets.only(left: 10),
                                      width: (data['images'][index]['comments']
                                                  [0]['creator'] ==
                                              userDoc['name'])
                                          ? MediaQuery.of(context).size.width *
                                              .5
                                          : MediaQuery.of(context).size.width *
                                              .6,
                                      // child: Text(data['images'][index]
                                      //     ['comments'][0]['comment']
                                      child: RichText(
                                          text: TextSpan(
                                        text: data['images'][index]['comments']
                                            [0]['comment'],
                                        style: TextStyle(color: Colors.black),
                                      ))),
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          .25,
                                      child: RichText(
                                        text: TextSpan(
                                            text: data['images'][index]
                                                    ['comments'][0]['time']
                                                .toDate()
                                                .toString()
                                                .substring(0, 10),
                                            style: TextStyle(
                                                color: Colors.grey[500])),
                                      )),
                                  (data['images'][index]['comments'][0]
                                              ['creator'] ==
                                          userDoc['name'])
                                      ? Container(
                                          child: GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                          title: Text(
                                                              'Delete Comment?'),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                  'Cancel'),
                                                            ),
                                                            TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  await MatchController
                                                                      .instance
                                                                      .deleteComments(
                                                                          matchDocId,
                                                                          index,
                                                                          0);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    Text('OK')),
                                                          ],
                                                        ));
                                              },
                                              child: Icon(Icons.delete)))
                                      : Container(),
                                ],
                              ),
                            )
                          : TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CommentPage(
                                            userId: userId,
                                            data: data,
                                            index: index,
                                            matchDocId: matchDocId,
                                            user: userDoc)));
                              },
                              child: RichText(
                                text: TextSpan(
                                    text: 'View all ',
                                    style: TextStyle(color: Colors.grey[500]),
                                    children: [
                                      TextSpan(
                                          text: data['images'][index]
                                                  ['comments']
                                              .length
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.grey[500])),
                                      TextSpan(
                                          text: ' comments',
                                          style: TextStyle(
                                              color: Colors.grey[500]))
                                    ]),
                              ))
                      : Text('no comments yet',
                          style: TextStyle(color: Colors.grey[500])),
                ],
              )),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    style: TextStyle(fontSize: 15, height: 1),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'write comments here'),
                  ),
                ),
                GestureDetector(
                    onTap: () async {
                      if (commentController.text.length > 0) {
                        Map<String, dynamic> commentData = {
                          'comment': commentController.text,
                          'time': Timestamp.now(),
                          'creator': userDoc['name'],
                        };

                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                    title: Text('Post Comment'),
                                    content: Text(commentData['comment']),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Cancel')),
                                      TextButton(
                                          onPressed: () async {
                                            await MatchController.instance
                                                .updateComments(matchDocId,
                                                    index, commentData)
                                                .then((result) {
                                              print('hi');
                                              commentController.clear();
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: Text('OK')),
                                    ]));

                        print(commentData);
                      }
                    },
                    child: Icon(
                      Icons.send,
                      color: Color.fromRGBO(85, 74, 53, 1),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
