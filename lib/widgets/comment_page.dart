import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import './comment_tile.dart';
import '../controllers/user_controller.dart';
import './dropdown_menu.dart';

class CommentPage extends StatefulWidget {
  final matchDocId;
  final user;
  final data;
  final index;
  const CommentPage(
      {Key? key,
      required this.matchDocId,
      required this.user,
      required this.data,
      required this.index})
      : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
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
        title: Text('Comments'),
        actions: [
          DropdownMenu(
              matchDocId: widget.matchDocId,
              user: widget.user,
              data: widget.data,
              index: widget.index),
          Text(
            'pa',
            style: TextStyle(color: Colors.blue),
          )
        ],
      ),
      body: Column(
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
                    child: Text(widget.data['images'][widget.index]['creator'],
                        style:
                            TextStyle(fontSize: 15, color: Colors.grey[500]))),
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
                      style: TextStyle(fontSize: 15, color: Colors.grey[500])),
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
              height: MediaQuery.of(context).size.height * .5,
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
              ))
        ],
      ),
    );
  }
}
