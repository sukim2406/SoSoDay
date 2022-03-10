import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../globals.dart' as globals;
import '../controllers/auth_controller.dart';
import '../controllers/storage_controller.dart';

class MatchController extends GetxController {
  static MatchController instance = Get.find();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void createMatchDocument(matchMap) async {
    try {
      await firestore.collection('matches').add(matchMap);
    } catch (e) {
      globals.printErrorSnackBar('createMatchDocument', e);
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
          return true;
        } else {
          return false;
        }
      });
    } catch (e) {
      globals.printErrorSnackBar('findMatchDocument', e);
    }
  }

  Future getMatchDocument(uid) async {
    try {
      return await firestore
          .collection('matches')
          .where('couple', arrayContains: uid)
          .get();
    } catch (e) {
      globals.printErrorSnackBar('getMatchDocument', e);
    }
  }

  Future<void> updateMatchDocument(docId, key, value) async {
    try {
      await firestore.collection('matches').doc(docId).update({key: value});
    } catch (e) {
      globals.printErrorSnackBar('updateMatchDocument', e);
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
      globals.printErrorSnackBar('sendMessage', e);
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
      globals.printErrorSnackBar('getMessages', e);
    }
  }

  Future getCoupleIds(docId) async {
    try {
      return await firestore
          .collection('matches')
          .doc(docId)
          .get()
          .then((DocumentSnapshot ds) {
        return ds['couple'];
      });
    } catch (e) {
      globals.printErrorSnackBar('getCoupleIds', e);
    }
  }

  Future getImages(docId) async {
    try {
      return await firestore
          .collection('matches')
          .doc(docId)
          .get()
          .then((DocumentSnapshot ds) {
        return ds['images'];
      });
    } catch (e) {
      globals.printErrorSnackBar('getImages', e);
    }
  }

  Future addImage(docId, newImage) async {
    try {
      var imageList = await getImages(docId);
      imageList.add(newImage);
      await firestore
          .collection('matches')
          .doc(docId)
          .update({'images': imageList});
    } catch (e) {
      globals.printErrorSnackBar('addImage', e);
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
      globals.printErrorSnackBar('getImageUrls', e);
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
      globals.printErrorSnackBar('updateImageUrls', e);
    }
  }

  Future getCommentsFromImage(docId, index) async {
    try {
      var imageList = await getImages(docId);
      return imageList[index]['comments'];
    } catch (e) {
      globals.printErrorSnackBar('getCommentsFromImage', e);
    }
  }

  Future<void> deleteComments(docId, imageIndex, commentIndex) async {
    try {
      var commentsList = await getCommentsFromImage(docId, imageIndex);
      var imageList = await getImages(docId);

      commentsList.removeAt(commentIndex);
      imageList[imageIndex]['comments'] = commentsList;
      await firestore
          .collection('matches')
          .doc(docId)
          .update({'images': imageList});
    } catch (e) {
      globals.printErrorSnackBar('deleteComments', e);
    }
  }

  Future<void> updateComments(docId, index, commentData) async {
    try {
      var commentList = await getCommentsFromImage(docId, index);
      if (commentList.length == 0) {
        commentList = [commentData];
      } else {
        commentList.add(commentData);
      }
      var imageList = await getImages(docId);
      imageList[index]['comments'] = commentList;
      await firestore
          .collection('matches')
          .doc(docId)
          .update({'images': imageList});
    } catch (e) {
      globals.printErrorSnackBar('updateComments', e);
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
      globals.printErrorSnackBar('getEvents', e);
    }
  }

  Future<void> addEvent(docId, event) async {
    try {
      var eventsList = await getEvents(docId);
      if (eventsList.isEmpty) {
        List newEventList = [];
        eventsList = newEventList;
      }
      eventsList.add(event);

      await firestore
          .collection('matches')
          .doc(docId)
          .update({'events': eventsList});
    } catch (e) {
      globals.printErrorSnackBar('addEvent', e);
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
      globals.printErrorSnackBar('modifyEvent', e);
    }
  }

  void setEventComplete(docId, event) async {
    try {
      var eventsList = await getEvents(docId);
      eventsList.forEach((originalEvent) {
        if (originalEvent['due'] == event.due) {
          originalEvent['completed'] = true;
        }
      });
      await firestore
          .collection('matches')
          .doc(docId)
          .update({'events': eventsList});
    } catch (e) {
      globals.printErrorSnackBar('setEventComplete', e);
    }
  }

  Future<void> deleteEvent(docId, event) async {
    try {
      var eventsList = await getEvents(docId);
      eventsList
          .removeWhere((originalEvent) => originalEvent['due'] == event['due']);
      await firestore
          .collection('matches')
          .doc(docId)
          .update({'events': eventsList});
    } catch (e) {
      globals.printErrorSnackBar('deleteEvent', e);
    }
  }

  Future<void> deleteMatchDoc(docId) async {
    try {
      await firestore.collection('matches').doc(docId).delete();
    } catch (e) {
      globals.printErrorSnackBar('deleteMatchDoc', e);
    }
  }

  Future<void> deleteUserDoc(docId) async {
    try {
      await firestore.collection('users').doc(docId).delete();
    } catch (e) {
      globals.printErrorSnackBar('deleteUserDoc', e);
    }
  }

  Future<void> clearAllData(docId) async {
    try {
      var imageUrls = await getImageUrls(docId);
      var coupleIds = await getCoupleIds(docId);
      imageUrls.forEach((img) {
        StorageController.instance.deleteImage(img);
      });
      updateMatchDocument(docId, 'images', []);
      coupleIds.forEach((coupleId) {
        deleteUserDoc(coupleId);
      });
      await deleteMatchDoc(docId).then((result) {
        AuthController.instance.logout();
      });
    } catch (e) {
      globals.printErrorSnackBar('clearAllData', e);
    }
  }

  Future<void> deleteAnImage(docId, imageUrl) async {
    try {
      var imageUrls = await getImageUrls(docId);
      var userMaps = await firestore
          .collection('matches')
          .doc(docId)
          .get()
          .then((DocumentSnapshot ds) {
        return ds['userMaps'];
      });
      var couple = await firestore
          .collection('matches')
          .doc(docId)
          .get()
          .then((DocumentSnapshot ds) {
        return ds['couple'];
      });
      var backgroundImage = await firestore
          .collection('matches')
          .doc(docId)
          .get()
          .then((DocumentSnapshot ds) {
        return ds['backgroundImage'];
      });
      if (backgroundImage == imageUrl) {
        backgroundImage = '';
      }
      couple.forEach((uid) {
        if (userMaps[uid]['profilePicture'] == imageUrl) {
          userMaps[uid]['profilePicture'] = '';
        }
      });
      imageUrls.removeWhere((image) => image['downloadUrl'] == imageUrl);
      updateMatchDocument(docId, 'backgroundImage', backgroundImage);
      updateMatchDocument(docId, 'userMaps', userMaps);
      updateMatchDocument(docId, 'images', imageUrls);
      StorageController.instance.deleteImage(imageUrl);
    } catch (e) {
      globals.printErrorSnackBar('deleteAnImage', e);
    }
  }
}
