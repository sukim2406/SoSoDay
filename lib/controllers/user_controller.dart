import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import './auth_controller.dart';
import '../main_page.dart';

class UserController extends GetxController {
  static UserController instance = Get.find();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void createUserDocument(userMap) async {
    try {
      await firestore.collection('users').add(userMap).then((result) {
        Get.offAll(() => MainPage(
              user: AuthController.instance.auth.currentUser,
              connected: false,
            ));
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future findUserDocument() async {
    try {
      return await firestore
          .collection('users')
          .where('email', isEqualTo: AuthController.instance.getCurUserEmail())
          .get()
          .then((QuerySnapshot ds) {
        if (ds.docs.isNotEmpty) {
          return true;
        } else {
          return false;
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future getUserDocument() async {
    try {
      return await firestore
          .collection('users')
          .where('email', isEqualTo: AuthController.instance.getCurUserEmail())
          .get();
      //     .then((QuerySnapshot ds) {
      //   ds.docs.forEach((element) {
      //     print('this works');
      //     print(element['halfEmail']);
      //   });
      // });
    } catch (e) {
      print(e.toString());
    }
  }
}
