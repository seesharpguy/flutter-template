import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jibe/models/jibe_models.dart';
import 'package:cloud_functions/cloud_functions.dart';

class FirebaseService {
  final CollectionReference _jibeCollectionReference =
      FirebaseFirestore.instance.collection('jibe');

  final StreamController<List<Player>> _playerController =
      StreamController<List<Player>>.broadcast();

  final StreamController<Game> _gameController =
      StreamController<Game>.broadcast();

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

  Stream<Game> game(String gameId) {
    _jibeCollectionReference.doc(gameId).snapshots().listen((snapshot) {
      if (snapshot.exists) {
        _gameController.add(Game.fromMap(snapshot.data(), snapshot.id));
      }
    });

    return _gameController.stream;
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

  Stream gameRounds(String gameId) {
    // Register the handler for when the posts data changes
    _jibeCollectionReference
        .doc(gameId)
        .collection("rounds")
        .snapshots()
        .listen((roundsSnapshots) {
      if (roundsSnapshots.docs.isNotEmpty) {
        var rounds = roundsSnapshots.docs
            .map((snapshot) => Player.fromMap(snapshot.data(), snapshot.id))
            .where((mappedItem) => mappedItem.displayName != null)
            .toList();

        rounds.sort((a, b) => a.playerNumber.compareTo(b.playerNumber));
        // Add the posts onto the controller
        _playerController.add(rounds);
      }
    });

    return _playerController.stream;
  }
}
