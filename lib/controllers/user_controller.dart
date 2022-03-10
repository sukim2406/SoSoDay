import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import './auth_controller.dart';
import '../globals.dart' as globals;

class UserController extends GetxController {
  static UserController instance = Get.find();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void createUserDocument(userMap) async {
    try {
      await firestore
          .collection('users')
          .doc(AuthController.instance.getCurUserUid())
          .set(userMap);
    } catch (e) {
      globals.printErrorSnackBar('createUserDocument', e);
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
      globals.printErrorSnackBar('findUserDocument', e);
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
      globals.printErrorSnackBar('getUserDocument', e);
    }
  }

  // Future getUserDocumentByEmail(email) async {
  //   try {
  //     return await firestore
  //         .collection('users')
  //         .where('email', isEqualTo: email)
  //         .get();
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  void updateUserDocument(docId, key, value) async {
    try {
      await firestore.collection('users').doc(docId).update({key: value});
    } catch (e) {
      globals.printErrorSnackBar('updateUserDocument', e);
    }
  }

  Future getUserDoc(uid) async {
    try {
      return await firestore
          .collection('users')
          .doc(uid)
          .get()
          .then((DocumentSnapshot ds) {
        return ds.data();
      });
    } catch (e) {
      globals.printErrorSnackBar('getUserDoc', e);
    }
  }
}
