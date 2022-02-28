import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:soso_day/controllers/auth_controller.dart';
import 'package:soso_day/controllers/user_controller.dart';

import '../controllers/storage_controller.dart';

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
      print('getCoupleIds error');
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
      print('getImages Error');
      print(e.toString());
    }
  }

  Future addImage(docId, newImage) async {
    try {
      var imageList = await getImages(docId);
      print('image data chekc');
      print(newImage);
      imageList.add(newImage);
      await firestore
          .collection('matches')
          .doc(docId)
          .update({'images': imageList});
    } catch (e) {
      print('addImage error');
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

  Future getCommentsFromImage(docId, index) async {
    try {
      var imageList = await getImages(docId);
      return imageList[index]['comments'];
    } catch (e) {
      print('getCommentsFromImage Error');
      print(e.toString());
    }
  }

  Future<void> deleteComments(docId, imageIndex, commentIndex) async {
    try {
      var commentsList = await getCommentsFromImage(docId, imageIndex);
      var imageList = await getImages(docId);

      print(commentsList);
      commentsList.removeAt(commentIndex);
      imageList[imageIndex]['comments'] = commentsList;
      await firestore
          .collection('matches')
          .doc(docId)
          .update({'images': imageList});
    } catch (e) {
      print('delete Comment error');
      print(e.toString());
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
      print('updateComments error');
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
          .removeWhere((originalEvent) => originalEvent['due'] == event['due']);
      await firestore
          .collection('matches')
          .doc(docId)
          .update({'events': eventsList});
    } catch (e) {
      print('deleteEvent error');
      print(e.toString());
    }
  }

  Future<void> deleteMatchDoc(docId) async {
    try {
      await firestore.collection('matches').doc(docId).delete();
    } catch (e) {
      print('deleteMatchDoc Error');
      print(e.toString());
    }
  }

  Future<void> deleteUserDoc(docId) async {
    try {
      await firestore.collection('users').doc(docId).delete();
    } catch (e) {
      print('deleteUserDoc Error');
      print(e.toString());
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
      print('clearAllData eror');
      print(e.toString());
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
      print('deleteAnImage Error');
      print(e.toString());
    }
  }

  Future getUserDocs(docId) async {
    try {
      return await firestore
          .collection('matches')
          .doc(docId)
          .get()
          .then((DocumentSnapshot ds) {
        return ds['userDocs'];
      });
    } catch (e) {
      print('getUserDocs error');
      print(e.toString());
    }
  }

  Future getUserNameById(userId, docId) async {
    try {
      return await firestore
          .collection('matches')
          .doc(docId)
          .get()
          .then((DocumentSnapshot ds) {
        return ds['userMaps'][userId]['name'];
      });
    } catch (e) {
      print('getUserNameById error');
      print(e.toString());
    }
  }

  Future getUserImageById(userId, docId) async {
    try {
      return await firestore
          .collection('matches')
          .doc(docId)
          .get()
          .then((DocumentSnapshot ds) {
        return ds['userMaps'][userId]['profilePicture'];
      });
    } catch (e) {
      print('getUserImageById error');
      print(e.toString());
    }
  }
}
