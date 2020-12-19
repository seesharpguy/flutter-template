import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jibe/models/jibe_models.dart';
import 'package:flutter/services.dart';

class FirestoreService {
  // final CollectionReference _usersCollectionReference =
  //     FirebaseFirestore.instance.collection('users');

  final CollectionReference _jibeCollectionReference = FirebaseFirestore
      .instance
      .collection(const String.fromEnvironment("ROOT_COLLECTION"));

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

  Future getGame(String gameId) async {
    try {
      var gameDocumentReference = _jibeCollectionReference.doc(gameId);
      print('getting game from firestore with id: $gameId');
      var gameData =
          await gameDocumentReference.get(GetOptions(source: Source.server));
      if (gameData.exists) {
        print('game exists with id: $gameId');
        return Game.fromMap(gameData.data(), gameData.id);
      }
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

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

        players.sort((a, b) => a.playerNumber.compareTo(b.playerNumber));
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