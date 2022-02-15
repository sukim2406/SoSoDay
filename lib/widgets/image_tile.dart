import 'dart:io';

import 'package:flutter/material.dart';

class ImageTile extends StatelessWidget {
  final data;
  final index;
  final matchDocId;
  final user;
  const ImageTile(
      {Key? key,
      required this.data,
      required this.matchDocId,
      required this.user,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                )
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
            child: Image.network(data['images'][index]['downloadUrl']),
          ),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Text(data['images'][index]['about']),
          ),
          Container(
              padding: EdgeInsets.only(left: 15),
              child: Row(
                children: [
                  TextButton(
                      onPressed: () {
                        print('hi?');
                      },
                      child: Text('view comments here')),
                ],
              )),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(fontSize: 15, height: 1),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'write comments here'),
                  ),
                ),
                Icon(Icons.send),
              ],
            ),
          )
        ],
      ),
    );
  }
}
