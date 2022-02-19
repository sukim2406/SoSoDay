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

class PhotoPage extends StatefulWidget {
  final matchDocId;
  final user;
  const PhotoPage({Key? key, required this.matchDocId, required this.user})
      : super(key: key);

  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  var path;
  var fileName;
  late var userName;
  late var userDoc;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    path = '';
    fileName = '';
    getUserDoc();
    getUserName();
    // TODO: implement initState
    super.initState();
  }

  void setPosition() {
    scrollController.animateTo(scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  void getUserDoc() async {
    await UserController.instance.getUserDoc(widget.user.uid).then((data) {
      setState(() {
        userDoc = data;
      });
    });
  }

  void getUserName() async {
    userName = await UserController.instance.getUsername(widget.user.uid);
  }

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
          actions: [
            GestureDetector(
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
                  }

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ImageUploadPage(
                                path: result!.files.single.path,
                                fileName: result!.files.single.name,
                                matchDocId: widget.matchDocId,
                                userData: userDoc['name'],
                              )));
                  // setState(() {
                  //   path = result!.files.single.path;
                  //   fileName = result!.files.single.name;
                  // });

                  // print('file picker test');
                  // print(path);
                  // print(fileName);
                  // String downloadUrl = 'empty';

                  // StorageController.instance
                  //     .uploadFile(path.toString(), fileName)
                  //     .then((value) async {
                  //   downloadUrl =
                  //       await StorageController.instance.downloadUrl(fileName);
                  //   print('download Url = ');
                  //   print(downloadUrl);
                  // }).then((value) {
                  //   MatchController.instance
                  //       .updateImageUrls(widget.matchDocId, downloadUrl);
                  //   print('came here');
                  //   print(widget.matchDocId);
                  // });
                },
                child: Icon(Icons.upload)),
            Text(
              'padd',
              style: TextStyle(color: Colors.blue),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
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
                    if (snapshot.data!.docs.first['images'].length == 0) {
                      return Text('Upload your first images');
                    }
                    if (snapshot.connectionState == ConnectionState.active ||
                        snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    return ListView.builder(
                      // reverse: true,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.first['images'].length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.only(bottom: 30),
                          child: ImageTile(
                              data: snapshot.data!.docs.first,
                              matchDocId: widget.matchDocId,
                              user: userDoc,
                              index: index),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ));
    // (path != '' && fileName != '')
    //     ? Container(
    //         child: ImageUploadPage(
    //           fileName: fileName,
    //           path: path,
    //           matchDocId: widget.matchDocId,
    //         ),
    //       )
    //     : Container(
    //         child: Text('none'),
    //       ));
  }
}

// class PhotoPage extends StatelessWidget {
//   final matchDocId;
//   final user;
//   const PhotoPage({Key? key, required this.matchDocId, required this.user})
//       : super(key: key);

//   Stream<QuerySnapshot> getStream() async* {
//     yield* FirebaseFirestore.instance
//         .collection('matches')
//         .where('couple', arrayContains: user.uid)
//         .snapshots();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           actions: [
//             GestureDetector(
//                 onTap: () async {
//                   final result = await FilePicker.platform.pickFiles(
//                       allowMultiple: false,
//                       type: FileType.custom,
//                       allowedExtensions: ['png', 'jpg']);

//                   if (result == null) {
//                     Get.snackbar('File Picker', 'File message',
//                         backgroundColor: Colors.redAccent,
//                         snackPosition: SnackPosition.BOTTOM,
//                         titleText: const Text(
//                           'No file selected',
//                           style: TextStyle(color: Colors.white),
//                         ));
//                   }

//                   final path = result!.files.single.path;
//                   final fileName = result!.files.single.name;

//                   print('file picker test');
//                   print(path);
//                   print(fileName);
//                   String downloadUrl = 'empty';

//                   StorageController.instance
//                       .uploadFile(path.toString(), fileName)
//                       .then((value) async {
//                     downloadUrl =
//                         await StorageController.instance.downloadUrl(fileName);
//                     print('download Url = ');
//                     print(downloadUrl);
//                   }).then((value) {
//                     MatchController.instance
//                         .updateImageUrls(matchDocId, downloadUrl);
//                     print('came here');
//                     print(matchDocId);
//                   });
//                 },
//                 child: Icon(Icons.upload)),
//             Text(
//               'padd',
//               style: TextStyle(color: Colors.blue),
//             )
//           ],
//         ),
//         body: Container());
//   }
  //   return Column(
  //     children: [
  //       SizedBox(
  //         height: 200,
  //       ),
  //       Container(
  //         height: MediaQuery.of(context).size.height * .5,
  //         child: StreamBuilder<QuerySnapshot>(
  //           stream: getStream(),
  //           builder: (context, snapshot) {
  //             if (snapshot.hasError) {
  //               return Text('Error');
  //             }
  //             if (!snapshot.hasData) {
  //               return Text('Empty');
  //             }
  //             return GridView.count(
  //               shrinkWrap: true,
  //               crossAxisCount: 2,
  //               children: List.generate(
  //                   snapshot.data!.docs.first['images'].length, (index) {
  //                 return GestureDetector(
  //                   onTap: () {
  //                     print(snapshot.data!.docs.first['images'][index]);
  //                     Get.to(() => SingleImagePage(
  //                         imageUrl: snapshot.data!.docs.first['images'][index],
  //                         matchDocId: matchDocId,
  //                         user: user,
  //                         image: Image.network(
  //                             snapshot.data!.docs.first['images'][index])));
  //                   },
  //                   child: Image.network(
  //                     snapshot.data!.docs.first['images'][index],
  //                     height: 100,
  //                     width: 100,
  //                   ),
  //                 );
  //               }),
  //             );
  //           },
  //         ),
  //       ),
  //       GestureDetector(
  //         onTap: () async {
  //           final result = await FilePicker.platform.pickFiles(
  //               allowMultiple: false,
  //               type: FileType.custom,
  //               allowedExtensions: ['png', 'jpg']);

  //           if (result == null) {
  //             Get.snackbar('File Picker', 'File message',
  //                 backgroundColor: Colors.redAccent,
  //                 snackPosition: SnackPosition.BOTTOM,
  //                 titleText: const Text(
  //                   'No file selected',
  //                   style: TextStyle(color: Colors.white),
  //                 ));
  //           }

  //           final path = result!.files.single.path;
  //           final fileName = result!.files.single.name;

  //           print('file picker test');
  //           print(path);
  //           print(fileName);
  //           String downloadUrl = 'empty';

  //           StorageController.instance
  //               .uploadFile(path.toString(), fileName)
  //               .then((value) async {
  //             downloadUrl =
  //                 await StorageController.instance.downloadUrl(fileName);
  //             print('download Url = ');
  //             print(downloadUrl);
  //           }).then((value) {
  //             MatchController.instance.updateImageUrls(matchDocId, downloadUrl);
  //             print('came here');
  //             print(matchDocId);
  //           });
  //         },
  //         child: LogBtn(
  //             btnText: 'Upload Image',
  //             btnWidth: MediaQuery.of(context).size.width * .5,
  //             btnHeight: MediaQuery.of(context).size.height * .03,
  //             btnFontSize: 15),
  //       )
  //     ],
  //   );
  // }
// }
