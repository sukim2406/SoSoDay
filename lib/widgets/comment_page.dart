import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import './comment_tile.dart';
import '../controllers/user_controller.dart';

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
  var userDoc;
  late List dropdownList;

  @override
  void initState() {
    dropdownList = [
      () {
        print('hi1');
      },
      () {
        print('hi2');
      },
      () {
        print('hi3');
      },
    ];
    setuserDoc();
    super.initState();
  }

  void setuserDoc() async {
    userDoc = await UserController.instance.getUserDoc(widget.user.uid);
  }

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
        .where('couple', arrayContains: widget.user.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
        actions: [
          DropdownButton<String>(
              icon: const Icon(Icons.more_vert),
              items: [
                'Set as profile image',
                'Set as background image',
                'Delete image'
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
          Text(
            'pa',
            style: TextStyle(color: Colors.blue),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            child: RichText(
                text: TextSpan(
                    text: widget.data['images'][widget.index]['title'],
                    style: TextStyle(fontSize: 15),
                    children: [
                  TextSpan(
                    text: widget.data['images'][widget.index]['time']
                        .toDate()
                        .toString()
                        .substring(0, 10),
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  TextSpan(
                      text: widget.data['images'][widget.index]['creator'],
                      style: TextStyle(color: Colors.grey[500]))
                ])),
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
                      print(userDoc);
                      return CommentTile(
                        matchDocId: widget.matchDocId,
                        user: userDoc,
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
