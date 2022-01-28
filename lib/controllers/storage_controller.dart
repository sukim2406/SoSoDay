import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

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

  Future getList() async {
    try {
      await storage.ref().listAll();
    } catch (e) {
      print('getList error');
      print(e.toString());
    }
  }
}
