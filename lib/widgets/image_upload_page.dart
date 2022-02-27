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
  final creatorUid;

  const ImageUploadPage(
      {Key? key,
      required this.path,
      required this.fileName,
      required this.matchDocId,
      required this.creatorUid})
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
        iconTheme: IconThemeData(
          color: Color.fromRGBO(85, 74, 53, 1),
        ),
        backgroundColor: Color.fromRGBO(255, 222, 158, 1),
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
                    'creator': widget.creatorUid,
                  };
                  MatchController.instance
                      .addImage(widget.matchDocId, imageData);
                }).then((value) {
                  Navigator.pop(context);
                });
              },
              child: Icon(
                Icons.check,
                color: Color.fromRGBO(85, 74, 53, 1),
              )),
          Text('padd',
              style: TextStyle(color: Color.fromRGBO(255, 222, 158, 1)))
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
              style: const TextStyle(
                color: Color.fromRGBO(85, 74, 53, 1),
              ),
              cursorColor: Color.fromRGBO(85, 74, 53, 1),
              keyboardType: TextInputType.multiline,
              maxLines: 10,
              decoration: InputDecoration(
                labelText: '...',
                border: InputBorder.none,
                filled: true,
                fillColor: Color.fromRGBO(242, 236, 217, 1),
                labelStyle: TextStyle(color: Color.fromRGBO(85, 74, 53, 1)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(85, 74, 53, 1)),
                ),
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
