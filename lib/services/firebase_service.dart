import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:APPLICATION_NAME/models/APPLICATION_NAME_models.dart';
import 'package:cloud_functions/cloud_functions.dart';

class FirebaseService {
  final CollectionReference _APPLICATION_NAMECollectionReference =
      FirebaseFirestore.instance.collection('APPLICATION_NAME');

  // final StreamController<List<Player>> _playerController =
  //     StreamController<List<Player>>.broadcast();

  final StreamController<Game> _gameController =
      StreamController<Game>.broadcast();

  // final StreamController<Round> _roundController =
  //     StreamController<Round>.broadcast();

  // final StreamController<List<Turn>> _turnController =
  //     StreamController<List<Turn>>.broadcast();

  Future<HttpsCallableResult<dynamic>> createGame(
      String displayName, String photoURL) async {
    var callable = await FirebaseFunctions.instance
        .httpsCallable('createGame', options: HttpsCallableOptions())
        .call(<String, dynamic>{
      "displayName": displayName,
      "photoURL": photoURL
    });

    return callable;
  }

  Future<HttpsCallableResult<dynamic>> joinGame(String gameId) async {
    var result = await FirebaseFunctions.instance
        .httpsCallable('joinGame')
        .call(<String, dynamic>{"gameId": gameId});

    return result;
  }

  Future<HttpsCallableResult<dynamic>> startGame(String gameId) async {
    var result = await FirebaseFunctions.instance
        .httpsCallable('startGame')
        .call(<String, dynamic>{"gameId": gameId});

    return result;
  }

  Future<HttpsCallableResult<dynamic>> takeTurn(
      String gameId, String round, String answer) async {
    var result = await FirebaseFunctions.instance
        .httpsCallable('takeTurn')
        .call(<String, dynamic>{
      "gameId": gameId,
      "round": round,
      "answer": answer
    });

    return result;
  }

  Future<HttpsCallableResult<dynamic>> scoreTurn(
      String gameId, String round, Map<String, dynamic> answers) async {
    var result = await FirebaseFunctions.instance
        .httpsCallable('scoreRound')
        .call(<String, dynamic>{
      "gameId": gameId,
      "round": round,
      "answers": answers
    });

    return result;
  }

  Stream<Game> gameListener(String gameId) {
    _APPLICATION_NAMECollectionReference.doc(gameId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        _gameController.add(Game.fromMap(snapshot.data(), snapshot.id));
      }
    });

    return _gameController.stream;
  }

  StreamController gameController() {
    return _gameController;
  }

  // Stream<List<Player>> playerListener(String gameId) {
  //   // Register the handler for when the posts data changes
  //   _APPLICATION_NAMECollectionReference.doc(gameId)
  //       .collection("players")
  //       .snapshots()
  //       .listen((playersSnapshot) {
  //     if (playersSnapshot.docs.isNotEmpty) {
  //       var players = playersSnapshot.docs
  //           .map((snapshot) => Player.fromMap(snapshot.data(), snapshot.id))
  //           .where((mappedItem) => mappedItem.displayName != null)
  //           .toList();

  //       players.sort((a, b) => a.playerNumber.compareTo(b.playerNumber));
  //       _playerController.add(players);
  //     }
  //   });

  //   return _playerController.stream;
  // }

  // StreamController playerController() {
  //   return _playerController;
  // }

  // Stream<Round> roundListener(String gameId, String round) {
  //   // Register the handler for when the posts data changes
  //   _APPLICATION_NAMECollectionReference.doc(gameId)
  //       .collection("rounds")
  //       .doc(round)
  //       .snapshots()
  //       .listen((roundsSnapshot) {
  //     if (roundsSnapshot.exists) {
  //       _roundController
  //           .add(Round.fromMap(roundsSnapshot.data(), roundsSnapshot.id));
  //     }
  //   });

  //   return _roundController.stream;
  // }

  // StreamController roundController() {
  //   return _roundController;
  // }

  // Stream<List<Turn>> turnListener(String gameId, String round) {
  //   // Register the handler for when the posts data changes
  //   _APPLICATION_NAMECollectionReference.doc(gameId)
  //       .collection("rounds")
  //       .doc(round)
  //       .collection("turns")
  //       .snapshots()
  //       .listen((turnSnapshot) {
  //     if (turnSnapshot.docs.isNotEmpty) {
  //       var players = turnSnapshot.docs
  //           .map((snapshot) => Turn.fromMap(snapshot.data(), snapshot.id))
  //           .where((mappedItem) => mappedItem.answer != null)
  //           .toList();

  //       _turnController.add(players);
  //     }
  //   });

  //   return _turnController.stream;
  // }

  // StreamController turnController() {
  //   return _turnController;
  // }
}
