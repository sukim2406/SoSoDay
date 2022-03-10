import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../globals.dart' as globals;

class StorageController extends GetxController {
  static StorageController instance = Get.find();
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> uploadFile(String filePath, String fileName) async {
    File file = File(filePath);

    try {
      await storage.ref('pictures/$fileName').putFile(file);
    } catch (e) {
      globals.printErrorSnackBar('uploadFile', e);
    }
  }

  Future<String> downloadUrl(String imageName) async {
    try {
      String downloadUrl =
          await storage.ref('pictures/$imageName').getDownloadURL();

      return downloadUrl;
    } catch (e) {
      globals.printErrorSnackBar('downloadUrl', e);
      return '';
    }
  }

  Future<void> deleteImage(url) async {
    try {
      await storage.refFromURL(url).delete();
    } catch (e) {
      globals.printErrorSnackBar('deleteImage', e);
    }
  }
}
