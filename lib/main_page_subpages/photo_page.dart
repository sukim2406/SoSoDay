import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../controllers/storage_controller.dart';

class PhotoPage extends StatelessWidget {
  const PhotoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getImage(context, 'pictures/give-love.png'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            width: MediaQuery.of(context).size.width * .8,
            height: MediaQuery.of(context).size.height * .8,
            child: snapshot.data as Widget,
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: MediaQuery.of(context).size.width * .8,
            height: MediaQuery.of(context).size.height * .8,
            child: CircularProgressIndicator(),
          );
        }

        return Text('error');
      },
    );
  }

  Future<Widget> _getImage(BuildContext context, String imageName) async {
    Image image = Image.network(
        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg');
    await StorageController.instance
        .loadImage(context, imageName)
        .then((value) {
      image = Image.network(
        value.toString(),
        fit: BoxFit.scaleDown,
      );
    });

    return image;
  }
}
