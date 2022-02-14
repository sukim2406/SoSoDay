import 'dart:io';

import '../controllers/storage_controller.dart';
import '../controllers/match_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './log_btn.dart';

class ImageUploadPage extends StatefulWidget {
  final path;
  final fileName;
  final matchDocId;
  const ImageUploadPage(
      {Key? key,
      required this.path,
      required this.fileName,
      required this.matchDocId})
      : super(key: key);

  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  var title;
  var about;

  @override
  void initState() {
    // TODO: implement initState
    title = '';
    about = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
              onTap: () async {
                print('test');
                String downloadUrl = '';
                StorageController.instance
                    .uploadFile(widget.path, widget.fileName)
                    .then((value) async {
                  downloadUrl = await StorageController.instance
                      .downloadUrl(widget.fileName);
                }).then((value) {
                  Map<String, dynamic> imageData = {
                    'title': title,
                    'about': about,
                    'time': Timestamp.now(),
                    'downloadUrl': downloadUrl,
                    'comments': [],
                  };
                  MatchController.instance
                      .addImage(widget.matchDocId, imageData);
                }).then((value) {
                  Navigator.pop(context);
                });
              },
              child: Icon(Icons.check)),
          Text('padding', style: TextStyle(color: Colors.blue))
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Title',
              ),
              onChanged: (val) {
                setState(() {
                  title = val;
                });
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(15),
            child: Image.file(File(widget.path)),
          ),
          Container(
            padding: EdgeInsets.all(15),
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: '...',
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: (val) {
                setState(() {
                  about = val;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
