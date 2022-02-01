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
      print('main page');
      if (await UserController.instance.findUserDocument()) {
        if (!await MatchController.instance.findMatchDocument(user.uid)) {
          if (!await MatchController.instance.findMatchDocument(user.email)) {
            var halfEmail;
            var userScreenName;
            (await UserController.instance.getUserDocument())
                .docs
                .forEach((doc) {
              halfEmail = doc['halfEmail'];
              userScreenName = doc['name'];
            });

            List<Map<String, dynamic>> chatInitData = [
              {
                'sender': 'System',
                'message': 'Chatroom Created',
                'time': Timestamp.now()
              },
            ];

            Map<String, dynamic> matchInfoMap = {
              'couple': [user.uid, halfEmail],
              'connected': false,
              'chats': chatInitData,
              'screenNames': [userScreenName],
              'since': DateTime.now(),
              'profileImage': null,
            };

            MatchController.instance.createMatchDocument(matchInfoMap);
          } else {
            var userScreenName;
            (await UserController.instance.getUserDocument())
                .docs
                .forEach((doc) {
              userScreenName = doc['name'];
            });
            var docId =
                (await MatchController.instance.getMatchDocument(user.email))
                    .docs[0]
                    .id;
            var couple =
                (await MatchController.instance.getMatchDocument(user.email))
                    .docs[0]['couple'];
            var newCouple = [];
            var screenNames =
                (await MatchController.instance.getMatchDocument(user.email))
                    .docs[0]['screenNames'];
            couple.forEach((person) {
              if (person == user.email) {
                newCouple.add(user.uid);
                screenNames.add(userScreenName);
              } else {
                newCouple.add(person);
              }
            });
            MatchController.instance
                .updateMatchDocument(docId, 'couple', newCouple);
            MatchController.instance
                .updateMatchDocument(docId, 'connected', true);
            MatchController.instance
                .updateMatchDocument(docId, 'screenNames', screenNames);
          }
        }
        var connected =
            (await MatchController.instance.getMatchDocument(user.uid)).docs[0]
                ['connected'];

        var matchDocId =
            (await MatchController.instance.getMatchDocument(user.uid))
                .docs[0]
                .id;
        Get.offAll(() => MainPage(
              user: user,
              connected: connected,
              matchDocId: matchDocId,
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

  String? getCurUserUid() {
    final user = auth.currentUser;
    return user?.uid;
  }

  void updatePassword(email, curPassword, newPassword) async {
    try {
      var credential =
          EmailAuthProvider.credential(email: email, password: curPassword);
      await auth.currentUser?.reauthenticateWithCredential(credential);
      await auth.currentUser?.updatePassword(newPassword);
    } catch (e) {
      print(e.toString());
    }
  }
}
