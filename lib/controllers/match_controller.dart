import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class MatchController extends GetxController {
  static MatchController instance = Get.find();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void createMatchDocument(matchMap) async {
    try {
      await firestore.collection('matches').add(matchMap);
    } catch (e) {
      print(e.toString());
    }
  }

  Future findMatchDocument(uid) async {
    try {
      return await firestore
          .collection('matches')
          .where('couple', arrayContains: uid)
          .get()
          .then((QuerySnapshot ds) {
        if (ds.docs.isNotEmpty) {
          print(ds.docs.toString());
          return true;
        } else {
          print('none found');
          return false;
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future getUserDocumentByEmail(email) async {
    try {
      return await firestore
          .collection('matches')
          .where('email', isEqualTo: email)
          .get();
    } catch (e) {
      print(e.toString());
    }
  }
}
