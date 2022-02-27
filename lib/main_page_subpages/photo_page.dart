import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/user_controller.dart';
import '../controllers/storage_controller.dart';
import '../widgets/log_btn.dart';
import '../controllers/match_controller.dart';
import '../single_image_page.dart';
import '../widgets/image_upload_page.dart';
import '../widgets/image_tile.dart';
import '../widgets/comment_page.dart';

class PhotoPage extends StatefulWidget {
  final matchDocId;
  final user;
  const PhotoPage({Key? key, required this.matchDocId, required this.user})
      : super(key: key);

  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  bool listView = true;
  var path;
  var fileName;
  late var userName;
  late var userDoc;
  late var userDocs;
  late var curUserDoc;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    path = '';
    fileName = '';
    getUserDoc();
    getUserName();
    getUserDocs();
    // getUserDocsIndex();
    // TODO: implement initState
  }

  void setPosition() {
    scrollController.animateTo(scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  void getUserDoc() async {
    await UserController.instance.getUserDoc(widget.user).then((data) {
      setState(() {
        userDoc = data;
        userDoc['uid'] = widget.user;
      });
    });
  }

  void getUserDocs() async {
    await MatchController.instance.getUserDocs(widget.matchDocId).then((data) {
      setState(() {
        userDocs = data;
      });
    });
    getUserDocsIndex();
  }

  void getUserDocsIndex() {
    userDocs.forEach((doc) {
      if (doc[widget.user] != null) {
        setState(() {
          curUserDoc = doc[widget.user];
        });
      }
    });
  }

  void getUserName() async {
    userName = await UserController.instance.getUsername(widget.user);
  }

  Stream<QuerySnapshot> getStream() async* {
    yield* FirebaseFirestore.instance
        .collection('matches')
        .where('couple', arrayContains: widget.user)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(255, 222, 158, 1),
          leading: GestureDetector(
              onTap: () async {
                final result = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType.custom,
                    allowedExtensions: ['png', 'jpg']);

                if (result == null) {
                  Get.snackbar('File Picker', 'File message',
                      backgroundColor: Colors.redAccent,
                      snackPosition: SnackPosition.BOTTOM,
                      titleText: const Text(
                        'No file selected',
                        style: TextStyle(color: Colors.white),
                      ));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImageUploadPage(
                                path: result!.files.single.path,
                                fileName: result!.files.single.name,
                                matchDocId: widget.matchDocId,
                                creatorUid: widget.user,
                              )));
                }
              },
              child: Icon(
                Icons.upload,
                color: Color.fromRGBO(85, 74, 53, 1),
              )),
          actions: [
            (listView)
                ? GestureDetector(
                    onTap: () async {
                      setState(() {
                        listView = false;
                      });
                    },
                    child: Icon(
                      Icons.grid_on,
                      color: Color.fromRGBO(85, 74, 53, 1),
                    ))
                :
                // Text(
                //   'pa',
                //   style: TextStyle(color: Color.fromRGBO(255, 222, 158, 1)),
                // ),
                GestureDetector(
                    onTap: () async {
                      setState(() {
                        listView = true;
                      });
                    },
                    child: Icon(
                      Icons.menu,
                      color: Color.fromRGBO(85, 74, 53, 1),
                    )),
            Text(
              'padd',
              style: TextStyle(color: Color.fromRGBO(255, 222, 158, 1)),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<dynamic>(
            future: UserController.instance.getUserDoc(widget.user),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('test');
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Container(
                      height: MediaQuery.of(context).size.height * .8,
                      width: MediaQuery.of(context).size.width,
                      child: Center(child: CircularProgressIndicator()));
                case ConnectionState.done:
                  if (snapshot.hasError) return Text('error');
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * .75,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: getStream(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error');
                            }
                            if (!snapshot.hasData) {
                              return Text('Empty');
                            }
                            if (snapshot.data!.docs.first['images'].length ==
                                0) {
                              return Center(
                                  child: Text('Upload your first images'));
                            }
                            // if (snapshot.connectionState == ConnectionState.active ||
                            //     snapshot.connectionState == ConnectionState.waiting) {
                            //   return CircularProgressIndicator();
                            // }
                            return (listView)
                                ? ListView.builder(
                                    // reverse: true,
                                    shrinkWrap: true,
                                    itemCount: snapshot
                                        .data!.docs.first['images'].length,
                                    itemBuilder: (context, index) {
                                      print('userDoc = ');
                                      print(curUserDoc);
                                      return Container(
                                        padding: EdgeInsets.only(
                                            bottom: 15, top: 15),
                                        child: ImageTile(
                                            data: snapshot.data!.docs.first,
                                            matchDocId: widget.matchDocId,
                                            userDoc: curUserDoc,
                                            userId: widget.user,
                                            index: index),
                                      );
                                    },
                                  )
                                : GridView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot
                                        .data!.docs.first['images'].length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10,
                                    ),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CommentPage(
                                                          userId: widget.user,
                                                          matchDocId:
                                                              widget.matchDocId,
                                                          user: curUserDoc,
                                                          data: snapshot
                                                              .data!.docs.first,
                                                          index: index)));
                                        },
                                        child: Container(
                                          child: Image.network(snapshot
                                                  .data!.docs.first['images']
                                              [index]['downloadUrl']),
                                        ),
                                      );
                                    },
                                  );
                            // : GridView.count(
                            //     crossAxisCount: 4,
                            //     shrinkWrap: true,
                            //     children: List<Widget>.generate(snapshot.data!.docs.first['images'].length, (index) => null),
                            //   );
                          },
                        ),
                      ),
                    ],
                  );
              }
            },
          ),
        ));
  }
}
