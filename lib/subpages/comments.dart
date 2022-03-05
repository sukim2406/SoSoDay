import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../globals.dart' as globals;
import '../indiviual_widgets/dropdown_menu.dart';
import '../indiviual_widgets/appbar_padding.dart';
import '../indiviual_widgets/comment.dart';
import '../controllers/match_controller.dart';

class Comments extends StatefulWidget {
  final String matchDocId;
  final Map matchDoc;
  final int index;
  final String myUid;
  final Map image;

  const Comments({
    Key? key,
    required this.matchDocId,
    required this.matchDoc,
    required this.index,
    required this.myUid,
    required this.image,
  }) : super(key: key);

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: globals.secondaryColor,
        ),
        backgroundColor: globals.primaryColor,
        title: Text(
          'Comments',
          style: TextStyle(
            color: globals.secondaryColor,
            fontSize: 15,
          ),
        ),
        actions: [
          DropdownMenu(
            matchDocId: widget.matchDocId,
            myUid: widget.myUid,
            matchDoc: widget.matchDoc,
            index: widget.index,
          ),
          const AppbarPadding(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 15),
                  width: globals.getwidth(context) * .3,
                  child: Text(
                    widget.image['title'],
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                SizedBox(
                  width: globals.getwidth(context) * .3,
                  child: Text(
                    widget.image['time'].toDate().toString().substring(0, 10),
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              ],
            ),
            Image.network(
              widget.image['downloadUrl'],
            ),
            Text(
              widget.image['about'],
            ),
            Container(
              padding: const EdgeInsets.all(15),
              height: globals.getHeight(context) * .45,
              child: ListView.builder(
                itemCount: widget.image['comments'].length,
                itemBuilder: (context, index) {
                  return Comment(
                    matchDoc: widget.matchDoc,
                    matchDocId: widget.matchDocId,
                    myUid: widget.myUid,
                    image: widget.image,
                    index: index,
                    imageIndex: widget.index,
                  );
                },
              ),
            ),
            Container(
              color: globals.tertiaryColor,
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1,
                        ),
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
                            'creator': widget.myUid,
                          };
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: globals.tertiaryColor,
                              title: Text(
                                'Post Comment',
                                style: TextStyle(
                                  color: globals.secondaryColor,
                                ),
                              ),
                              content: Text(commentData['comment']),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: globals.primaryColor,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await MatchController.instance
                                        .updateComments(widget.matchDocId,
                                            widget.index, commentData)
                                        .then((result) {
                                      commentController.clear();
                                    });
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'OK',
                                    style: TextStyle(
                                      color: globals.secondaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: Icon(
                        Icons.send,
                        color: globals.secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
