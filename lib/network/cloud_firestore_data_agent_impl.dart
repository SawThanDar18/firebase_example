import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_padc/network/social_data_agent.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../data/vos/news_feed_vo.dart';

const newsFeedCollection = "newsfeed";
const fileUploadRef = "uploads";

class CloudFireStoreDataAgentImpl extends SocialDataAgent {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  Stream<List<NewsFeedVO>> getNewsFeed() {
    // snapshots => querySnapShot => querySnapShot.docs => Lists<QueryDocumentSnapshot> => data() => List<Map<String, dynamic>> => NewsFeedVo.fromJson => List<NewsFeedVO>
    return _fireStore
        .collection(newsFeedCollection)
        .snapshots()
        .map((querySnapShot) {
      return querySnapShot.docs.map<NewsFeedVO>((document) {
        return NewsFeedVO.fromJson(document.data());
      }).toList();
    });
  }

  @override
  Future<void> addNewPost(NewsFeedVO newPost) {
    return _fireStore
        .collection(newsFeedCollection)
        .doc(newPost.id.toString())
        .set(newPost.toJson());
  }

  @override
  Future<void> deletePost(int postId) {
    return _fireStore
        .collection(newsFeedCollection)
        .doc(postId.toString())
        .delete();
  }

  @override
  Stream<NewsFeedVO> getNewsFeedById(int newsFeedId) {
    return _fireStore
        .collection(newsFeedCollection)
        .doc(newsFeedId.toString())
        .get()
        .asStream()
        .where((documentSnapShot) => documentSnapShot.data() != null)
        .map((documentSnapShot) =>
            NewsFeedVO.fromJson(documentSnapShot.data()!));
  }

  @override
  Future<String> uploadFileToFirebase(File image) {
    return FirebaseStorage.instance
        .ref(fileUploadRef)
        .child("${DateTime.now().millisecondsSinceEpoch}")
        .putFile(image)
        .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());
  }
}
