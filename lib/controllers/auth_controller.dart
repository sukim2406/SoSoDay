import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../login_page.dart';
import '../stepper_page.dart';
import './user_controller.dart';
import '../main_page.dart';
import './match_controller.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
    ever(_user, _initialScreen);
  }

  _initialScreen(User? user) async {
    if (user == null) {
      print('login page');
      Get.offAll(() => const LoginPage());
    } else {
      var connected = false;
      print('main page');
      if (await UserController.instance.findUserDocument()) {
        if (!await MatchController.instance.findMatchDocument(user.uid)) {
          if (!await MatchController.instance.findMatchDocument(user.email)) {
            var tempHalf = await UserController.instance.getUserDocument();
            Map<String, List> matchInitMap = {
              'couple': [user.uid, tempHalf.docs[0]['halfEmail']]
            };
            MatchController.instance.createMatchDocument(matchInitMap);
            connected = false;
          } else {
            Map<String, List> temp;
            var tempDoc = (await MatchController.instance
                .getUserDocumentByEmail(user.email));
            tempDoc.forEach((doc) {
              temp = doc['couple'];
              // doc.reference.updateData(<String, List>{'couple': });
            });
          }
        }
        Get.offAll(() => MainPage(
              user: user,
              connected: connected,
            ));
      } else {
        Get.offAll(() => StepperPage(user: user));
      }
    }
  }

  void register(String email, password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print('register error');
      Get.snackbar('About User', 'User message',
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          titleText: const Text(
            'Account creation faild',
            style: TextStyle(color: Colors.white),
          ),
          messageText: Text(
            e.toString(),
            style: TextStyle(color: Colors.white),
          ));
    }
  }

  void login(String email, password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print('login error');
      Get.snackbar('About Login', 'Login message',
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          titleText: const Text(
            'Login faild',
            style: TextStyle(color: Colors.white),
          ),
          messageText: Text(
            e.toString(),
            style: const TextStyle(color: Colors.white),
          ));
    }
  }

  void logout() async {
    await auth.signOut();
  }

  String? getCurUserEmail() {
    final user = auth.currentUser;
    return user?.email;
  }
}
