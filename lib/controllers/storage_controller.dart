import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../controllers/match_controller.dart';

class StorageController extends GetxController {
  static StorageController instance = Get.find();
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> printList() async {
    try {
      ListResult result = await storage.ref().listAll();
      result.items.forEach((element) {
        print('File = $element');
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> uploadFile(String filePath, String fileName) async {
    File file = File(filePath);

    try {
      await storage.ref('pictures/$fileName').putFile(file);
    } catch (e) {
      print('uploadFile Error');
      print(e.toString());
    }
  }

  Future<ListResult> listFiles() async {
    ListResult results = await storage.ref('pictures').listAll();

    results.items.forEach((Reference ref) {
      print('file ref: $ref');
    });

    return results;
  }

  Future<String> downloadUrl(String imageName) async {
    String downloadUrl =
        await storage.ref('pictures/$imageName').getDownloadURL();

    return downloadUrl;
  }

  Future<void> deleteImage(url) async {
    try {
      await storage.refFromURL(url).delete();
      print('deleted');
    } catch (e) {
      print('deleteImage error');
      print(e.toString());
    }
    // Reference ref = storage.refFromURL(url);
    // ref.delete().then((result) {
    //   print('success');
    // }).catchError((error) {
    //   print(error.toString());
    // });
  }
}
