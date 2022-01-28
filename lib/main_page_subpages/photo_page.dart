import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../controllers/storage_controller.dart';

class PhotoPage extends StatelessWidget {
  const PhotoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: StorageController.instance.getList(),
      builder: (context, snapshot) {
        if (snapshot.hasError || !snapshot.hasData) {
          return Text('Error Here');
        }
        return Text(snapshot.data.toString());
      },
    );
  }
}
