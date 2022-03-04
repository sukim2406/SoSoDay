import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import '../globals.dart' as globals;
import '../controllers/storage_controller.dart';
import '../controllers/match_controller.dart';
import '../indiviual_widgets/appbar_padding.dart';

class ImageUpload extends StatefulWidget {
  final filePicker;
  final myUid;
  final matchDocId;

  const ImageUpload({
    Key? key,
    required this.filePicker,
    required this.myUid,
    required this.matchDocId,
  }) : super(key: key);

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  var title;
  var about;

  @override
  void initState() {
    title = '';
    about = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: globals.secondaryColor,
        ),
        backgroundColor: globals.primaryColor,
        actions: [
          GestureDetector(
            onTap: () async {
              String downloadUrl = '';
              StorageController.instance
                  .uploadFile(widget.filePicker.files.single.path,
                      widget.filePicker.files.single.name)
                  .then((value) async {
                downloadUrl = await StorageController.instance
                    .downloadUrl(widget.filePicker.files.single.name);
              }).then((value) {
                Map<String, dynamic> imageData = {
                  'title': title,
                  'about': about,
                  'time': Timestamp.now(),
                  'comments': [],
                  'creator': widget.myUid,
                  'downloadUrl': downloadUrl,
                };
                MatchController.instance.addImage(widget.matchDocId, imageData);
              }).then((value) {
                Navigator.pop(context);
              });
            },
            child: Icon(
              Icons.check,
              color: globals.secondaryColor,
            ),
          ),
          const AppbarPadding(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              child: TextFormField(
                decoration: globals.textFieldDecoration('title'),
                onChanged: (val) {
                  setState(() {
                    title = val;
                  });
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              child: Image.file(
                File(widget.filePicker.files.single.path),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              child: TextFormField(
                style: TextStyle(color: globals.secondaryColor),
                cursorColor: globals.secondaryColor,
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                decoration: globals.textFieldDecoration('...'),
                onChanged: (val) {
                  setState(() {
                    about = val;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
