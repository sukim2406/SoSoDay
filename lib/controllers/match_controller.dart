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
      print('updateImageUrls error');
      print(e.toString());
    }
  }

  Future getEvents(docId) async {
    try {
      return await firestore
          .collection('matches')
          .doc(docId)
          .get()
          .then((DocumentSnapshot ds) {
        return ds['events'];
      });
    } catch (e) {
      print('getEvents error');
      print(e.toString());
    }
  }

  Future<void> addEvent(docId, event) async {
    try {
      var eventsList = await getEvents(docId);
      if (eventsList.isEmpty) {
        List newEventList = [];
        eventsList = newEventList;
      }
      print('add check');
      print(event);
      eventsList.add(event);

      await firestore
          .collection('matches')
          .doc(docId)
          .update({'events': eventsList});
    } catch (e) {
      print('addEvent error');
      print(e.toString());
    }
  }

  Future<void> modifyEvent(docId, event, newData) async {
    try {
      var eventsList = await getEvents(docId);
      eventsList.forEach((originalEvent) {
        if (originalEvent['due'] == event['due']) {
          originalEvent['title'] = newData['title'];
          originalEvent['due'] = newData['due'];
          originalEvent['description'] = newData['description'];
          originalEvent['completed'] = newData['completed'];
        }
      });
      await firestore
          .collection('matches')
          .doc(docId)
          .update({'events': eventsList});
    } catch (e) {
      print('modifyEvent error');
      print(e.toString());
    }
  }

  void setEventComplete(docId, event) async {
    try {
      var eventsList = await getEvents(docId);
      eventsList.forEach((originalEvent) {
        print(originalEvent);
        print(event);
        if (originalEvent['due'] == event.due) {
          originalEvent['completed'] = true;
          print('hello');
        }
      });
      await firestore
          .collection('matches')
          .doc(docId)
          .update({'events': eventsList});
    } catch (e) {
      print('setEventComplete error');
      print(e.toString());
    }
  }

  Future<void> deleteEvent(docId, event) async {
    try {
      var eventsList = await getEvents(docId);
      eventsList
          .removeWhere((originalEvent) => originalEvent['due'] == event.due);
      await firestore
          .collection('matches')
          .doc(docId)
          .update({'events': eventsList});
    } catch (e) {
      print('deleteEvent error');
      print(e.toString());
    }
  }
}
