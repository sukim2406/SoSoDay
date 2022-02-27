import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import './comment_tile.dart';
import '../controllers/user_controller.dart';
import './dropdown_menu.dart';
import '../controllers/match_controller.dart';

class CommentPage extends StatefulWidget {
  final matchDocId;
  final user;
  final data;
  final index;
  final userId;
  const CommentPage(
      {Key? key,
      required this.userId,
      required this.matchDocId,
      required this.user,
      required this.data,
      required this.index})
      : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  TextEditingController commentController = TextEditingController();
  Map<String, dynamic> dropdownFunctions = {
    'Set as profile image': () {
      print('test1');
    },
    'Set as background image': () {
      print('test2');
    },
    'Delete image': () {
      print('test3');
    }
  };

  Stream<QuerySnapshot> getStream() async* {
    yield* FirebaseFirestore.instance
        .collection('matches')
        .where('couple', arrayContains: widget.user['uid'])
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color.fromRGBO(85, 74, 53, 1),
        ),
        backgroundColor: Color.fromRGBO(255, 222, 158, 1),
        title: Text(
          'Comments',
          style: TextStyle(
            color: Color.fromRGBO(85, 74, 53, 1),
          ),
        ),
        actions: [
          DropdownMenu(
              userId: widget.userId,
              matchDocId: widget.matchDocId,
              user: widget.user,
              data: widget.data,
              index: widget.index),
          Text(
            'pa',
            style: TextStyle(color: Color.fromRGBO(255, 222, 158, 1)),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 15),
                    width: MediaQuery.of(context).size.width * .3,
                    child: Text(
                      widget.data['images'][widget.index]['title'],
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * .3,
                      child: Text(
                          widget.data['userMaps'][widget.data['images']
                              [widget.index]['creator']]['name'],
                          style: TextStyle(
                              fontSize: 15, color: Colors.grey[500]))),
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .3,
                    child: Text(
                        widget.data['images'][widget.index]['time']
                            .toDate()
                            .toString()
                            .substring(0, 10),
                        style:
                            TextStyle(fontSize: 15, color: Colors.grey[500])),
                  )
                ],
              ),
            ),
            Container(
                child: Image.network(
                    widget.data['images'][widget.index]['downloadUrl'])),
            Container(
              child: Text(widget.data['images'][widget.index]['about']),
            ),
            Container(
              padding: EdgeInsets.all(15),
              height: MediaQuery.of(context).size.height * .45,
              child: StreamBuilder<QuerySnapshot>(
                stream: getStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error');
                  }
                  if (!snapshot.hasData) {
                    return Text('Empty');
                  }
                  if (snapshot.data!.docs
                          .first['images'][widget.index]['comments'].length ==
                      0) {
                    return Text('no comments yet');
                  }
                  return ListView.builder(
                    // reverse: true,
                    // shrinkWrap: true,
                    itemCount: snapshot.data!.docs
                        .first['images'][widget.index]['comments'].length,
                    itemBuilder: (context, index) {
                      print('hi?');
                      return CommentTile(
                        matchDocId: widget.matchDocId,
                        userId: widget.userId,
                        user: widget.user,
                        imageData: widget.data,
                        imageIndex: widget.index,
                        commentIndex: index,
                      );
                      // return Text(snapshot.data!.docs.first['images']
                      //     [widget.index]['comments'][index]['comment']);
                    },
                  );
                },
              ),
            ),
            Container(
              color: Color.fromRGBO(255, 222, 158, 1),
              child: Container(
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
                              'creator': widget.userId,
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
                                                    .updateComments(
                                                        widget.matchDocId,
                                                        widget.index,
                                                        commentData)
                                                    .then((result) {
                                                  print('hi');
                                                  commentController.clear();
                                                });
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (context) =>
                                                //             CommentPage(
                                                //                 userId:
                                                //                     widget
                                                //                         .userId,
                                                //                 matchDocId: widget
                                                //                     .matchDocId,
                                                //                 user:
                                                //                     widget.user,
                                                //                 data:
                                                //                     widget.data,
                                                //                 index: widget
                                                //                     .index)));
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
            )
          ],
        ),
      ),
    );
  }
}
