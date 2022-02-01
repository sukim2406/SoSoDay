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

  Future getMatchDocument(uid) async {
    try {
      return await firestore
          .collection('matches')
          .where('couple', arrayContains: uid)
          .get();
    } catch (e) {
      print(e.toString());
    }
  }

  void updateMatchDocument(docId, key, value) async {
    try {
      await firestore.collection('matches').doc(docId).update({key: value});
    } catch (e) {
      print(e.toString());
    }
  }

  void sendMessage(docId, chat) async {
    try {
      var chatList = await getMessages(docId);
      chatList.add(chat);
      await firestore
          .collection('matches')
          .doc(docId)
          .update({'chats': chatList});
    } catch (e) {
      print(e.toString());
    }
  }

  Future getMessages(docId) async {
    try {
      return await firestore
          .collection('matches')
          .doc(docId)
          .get()
          .then((DocumentSnapshot ds) {
        return ds['chats'];
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future getMessageStream(docId) async {
    try {
      return await firestore
          .collection('matches')
          .doc(docId)
          .collection('chats');
    } catch (e) {
      print(e.toString());
    }
  }

  getConversationMessages(docId) async {
    try {
      return await firestore
          .collection('matches')
          .doc(docId)
          .collection('chats')
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
  }

  getMyScreenName(docId) async {
    try {
      return await firestore
          .collection('matches')
          .doc(docId)
          .collection('couple')
          .snapshots();
    } catch (e) {
      print(e.toString());
    }
  }

  getMatchDocById(matchDocId) async {
    try {
      return await firestore.collection('matches').doc(matchDocId).get();
    } catch (e) {
      print(e.toString());
    }
  }

  Future getProfileUrl(docId) async {
    try {
      return await firestore
          .collection('matches')
          .doc(docId)
          .get()
          .then((DocumentSnapshot ds) {
        return ds['profileImage'];
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future getImageUrls(docId) async {
    try {
      return await firestore
          .collection('matches')
          .doc(docId)
          .get()
          .then((DocumentSnapshot ds) {
        return ds['images'];
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void updateImageUrls(docId, url) async {
    try {
      var urlList = await getImageUrls(docId);
      urlList.add(url);
      await firestore
          .collection('matches')
          .doc(docId)
          .update({'images': urlList});
    } catch (e) {
      print(e.toString());
    }
  }
}
