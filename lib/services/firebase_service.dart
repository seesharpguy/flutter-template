import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jibe/models/jibe_models.dart';
import 'package:flutter/services.dart';
import 'package:cloud_functions/cloud_functions.dart';

class FirebaseService {
  final CollectionReference _jibeCollectionReference =
      FirebaseFirestore.instance.collection('jibe');

  final StreamController<List<Player>> _playerController =
      StreamController<List<Player>>.broadcast();

  Future<JibeResult> createGame(
      String displayName, String photoUrl, String userId) async {
    try {
      var callable = await FirebaseFunctions.instance
          .httpsCallable('createGame')
          .call(<String, dynamic>{
        "creator": {
          "displayName": displayName,
          "avatar": photoUrl,
          "userId": userId
        }
      });

      return JibeResult(data: callable.data);
    } catch (e) {
      return JibeResult(
          exception: "Unknown problem occurred while creating game.");
    }
  }

  Future<Game> getGame(String gameId) async {
    try {
      var gameDocumentReference = _jibeCollectionReference.doc(gameId);
      var gameData = await gameDocumentReference.get();
      if (gameData.exists) {
        return Game.fromMap(gameData.data(), gameData.id);
      }
    } catch (e) {
      print("error in firebase_service ${e.toString()}");
      // TODO: Find or create a way to repeat error handling without so much repeated code
    }
  }

  Future<JibeResult> joinGame(
      String gameId, String displayName, String photoUrl, String userId) async {
    try {
      var result = await FirebaseFunctions.instance
          .httpsCallable('joinGame')
          .call(<String, dynamic>{
        "gameId": gameId,
        "displayName": displayName,
        "avatar": photoUrl,
        "userId": userId
      });

      return JibeResult(data: result.data);
    } catch (e) {
      return JibeResult(
          exception: "Unknown problem occurred while joining game.");
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
}
