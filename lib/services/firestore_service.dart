import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jibe/models/jibe_models.dart';
import 'package:flutter/services.dart';

class FirestoreService {
  // final CollectionReference _usersCollectionReference =
  //     FirebaseFirestore.instance.collection('users');

  final CollectionReference _jibeCollectionReference =
      FirebaseFirestore.instance.collection('jibe_nonprod');

  final StreamController<List<Player>> _playerController =
      StreamController<List<Player>>.broadcast();

  // Future createUser(JibeUser user) async {
  //   try {
  //     await _usersCollectionReference.document(user.id).setData(user.toJson());
  //   } catch (e) {
  //     // TODO: Find or create a way to repeat error handling without so much repeated code
  //     if (e is PlatformException) {
  //       return e.message;
  //     }

  //     return e.toString();
  //   }
  // }

  // Future getUser(String uid) async {
  //   try {
  //     var userData = await _usersCollectionReference.document(uid).get();
  //     return JibeUser.fromData(userData.data);
  //   } catch (e) {
  //     // TODO: Find or create a way to repeat error handling without so much repeated code
  //     if (e is PlatformException) {
  //       return e.message;
  //     }

  //     return e.toString();
  //   }
  // }

  // Future addPost(Game post) async {
  //   try {
  //     await _jibeCollectionReference.add(post.toMap());
  //   } catch (e) {
  //     // TODO: Find or create a way to repeat error handling without so much repeated code
  //     if (e is PlatformException) {
  //       return e.message;
  //     }

  //     return e.toString();
  //   }
  // }

  // Future getPostsOnceOff() async {
  //   try {
  //     var postDocumentSnapshot = await _jibeCollectionReference.getDocuments();
  //     if (postDocumentSnapshot.documents.isNotEmpty) {
  //       return postDocumentSnapshot.documents
  //           .map((snapshot) => Post.fromMap(snapshot.data, snapshot.documentID))
  //           .where((mappedItem) => mappedItem.title != null)
  //           .toList();
  //     }
  //   } catch (e) {
  //     // TODO: Find or create a way to repeat error handling without so much repeated code
  //     if (e is PlatformException) {
  //       return e.message;
  //     }

  //     return e.toString();
  //   }
  // }

  Stream gamePlayers(String gameId) {
    // Register the handler for when the posts data changes
    _jibeCollectionReference
        .doc(gameId)
        .collection("players")
        .snapshots()
        .listen((playersSnapshot) {
      if (playersSnapshot.docs.isNotEmpty) {
        var players = playersSnapshot.docs
            .map((snapshot) => Player.fromMap(snapshot.data(), snapshot.id))
            .where((mappedItem) => mappedItem.displayName != null)
            .toList();

        // Add the posts onto the controller
        _playerController.add(players);
      }
    });

    return _playerController.stream;
  }

  // Future deletePost(String documentId) async {
  //   await _jibeCollectionReference.document(documentId).delete();
  // }

  // Future updatePost(Game post) async {
  //   try {
  //     await _jibeCollectionReference
  //         .document(post.documentId)
  //         .updateData(post.toMap());
  //   } catch (e) {
  //     // TODO: Find or create a way to repeat error handling without so much repeated code
  //     if (e is PlatformException) {
  //       return e.message;
  //     }

  //     return e.toString();
  //   }
  // }
}
