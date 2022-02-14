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
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('img/profile.png'),
                ),
                Text(data['images'][index]['title'])
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(15),
            child: Image.network(data['images'][index]['downloadUrl']),
          ),
          Container(
            padding: EdgeInsets.all(15),
            child: Text(data['images'][index]['about']),
          ),
          Container(child: Text('comments here')),
        ],
      ),
    );
  }
}
