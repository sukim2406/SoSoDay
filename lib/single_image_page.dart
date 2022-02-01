import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soso_day/main_page_subpages/photo_page.dart';

import './main_page.dart';
import './controllers/match_controller.dart';
import './controllers/storage_controller.dart';

class SingleImagePage extends StatelessWidget {
  final image;
  final matchDocId;
  final user;
  final imageUrl;
  const SingleImagePage(
      {Key? key,
      required this.image,
      required this.matchDocId,
      required this.user,
      required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                setProfileDialog(context);
              },
              child: const Text('Set as Profile'),
              style: TextButton.styleFrom(
                  primary: Theme.of(context).colorScheme.onPrimary)),
          TextButton(
              onPressed: () {
                deleteDialog(context);
              },
              child: const Text('Delete'),
              style: TextButton.styleFrom(
                  primary: Theme.of(context).colorScheme.onSecondary))
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * .7,
        width: MediaQuery.of(context).size.width,
        child: image,
      ),
    );
  }

  void setProfileDialog(BuildContext context) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set this image as profile image?'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.pop(context, "OK");
                MatchController.instance
                    .updateMatchDocument(matchDocId, 'profileImage', imageUrl);
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, "Cancel");
              },
            ),
          ],
        );
      },
    );
  }

  void deleteDialog(BuildContext context) async {
    List imageUrls = await MatchController.instance.getImageUrls(matchDocId);
    var profileImage = '';
    await MatchController.instance.getProfileUrl(matchDocId).then((result) {
      if (result != null) {
        profileImage = result;
      }
    });
    var result = await showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete this image?'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                if (profileImage == imageUrl) {
                  MatchController.instance
                      .updateMatchDocument(matchDocId, 'profileImage', null);
                }
                imageUrls.removeWhere((element) => element == imageUrl);
                MatchController.instance
                    .updateMatchDocument(matchDocId, 'images', imageUrls);
                StorageController.instance.deleteImage(imageUrl);
                Get.off(() => MainPage(
                    user: user, connected: true, matchDocId: matchDocId));
                // Get.to(() {
                //   MainPage(user: user, connected: true, matchDocId: matchDocId);
                // });
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, 'Cancel');
              },
            ),
          ],
        );
      },
    );
  }
}
