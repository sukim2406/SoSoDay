import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

import '../globals.dart' as globals;
import '../subpages/image_upload.dart';
import '../indiviual_widgets/appbar_padding.dart';
import '../indiviual_widgets/single_image_tile.dart';
import '../subpages/comments.dart';

class PhotoPageFinal extends StatefulWidget {
  final matchDocId;
  final myUid;
  final matchDoc;

  const PhotoPageFinal({
    Key? key,
    required this.matchDocId,
    required this.myUid,
    required this.matchDoc,
  }) : super(key: key);

  @override
  State<PhotoPageFinal> createState() => _PhotoPageFinalState();
}

class _PhotoPageFinalState extends State<PhotoPageFinal> {
  var listView;

  @override
  void initState() {
    listView = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('????');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globals.primaryColor,
        leading: GestureDetector(
          onTap: () async {
            final filePicker = await FilePicker.platform.pickFiles(
              allowMultiple: false,
              type: FileType.image,
            );
            if (filePicker == null) {
              Get.snackbar(
                'File Picker',
                'File message',
                backgroundColor: Colors.redAccent,
                snackPosition: SnackPosition.BOTTOM,
                titleText: const Text(
                  'No file selected',
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageUpload(
                      filePicker: filePicker,
                      matchDocId: widget.matchDocId,
                      myUid: widget.myUid),
                ),
              );
            }
          },
          child: Icon(
            Icons.upload,
            color: globals.secondaryColor,
          ),
        ),
        actions: [
          (listView)
              ? GestureDetector(
                  onTap: () async {
                    setState(
                      () {
                        listView = false;
                      },
                    );
                  },
                  child: Icon(Icons.grid_on, color: globals.secondaryColor),
                )
              : GestureDetector(
                  onTap: () async {
                    setState(() {
                      listView = true;
                    });
                  },
                  child: Icon(
                    Icons.menu,
                    color: globals.secondaryColor,
                  ),
                ),
          const AppbarPadding(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: globals.getHeight(context) * .75,
              child: (listView)
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.matchDoc['images'].length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.only(bottom: 15, top: 15),
                          child: SingleImageTile(
                            matchDocId: widget.matchDocId,
                            matchDoc: widget.matchDoc,
                            index: index,
                            myUid: widget.myUid,
                          ),
                        );
                      },
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      itemCount: widget.matchDoc['images'].length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisExtent: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Comments(
                                  matchDoc: widget.matchDoc,
                                  matchDocId: widget.matchDocId,
                                  index: index,
                                  myUid: widget.myUid,
                                  image: widget.matchDoc['images'][index],
                                ),
                              ),
                            );
                          },
                          child: Image.network(
                            widget.matchDoc['images'][index]['downloadUrl'],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
