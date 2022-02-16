import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
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
          )
        ],
      ),
    );
  }
}
