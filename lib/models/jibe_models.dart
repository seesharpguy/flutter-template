import 'package:flutter/foundation.dart';

class JibeResult {
  final dynamic data;
  final String exception;

  bool get hasError => data['message'] != null || this.exception != null;
  String get error => data['message'] + exception;

  JibeResult({this.data, this.exception});
}

class Game {
  final String gameId;
  final String createdBy;
  final GameStatus status;

  Game(
      {@required this.gameId, @required this.createdBy, @required this.status});

  Map<String, dynamic> toMap() {
    return {
      'gameId': gameId,
      'createdBy': createdBy,
      'status': status.toString()
    };
  }

  static Game fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return Game(
        createdBy: map['createdBy'],
        gameId: documentId,
        status: GameStatus.values.firstWhere(
            (element) => element.toString() == 'GameStatus.' + map['status']));
  }
}

class Player {
  final String displayName;
  final String avatar;
  final String documentId;
  final int playerNumber;
  final String userId;

  Player({
    @required this.displayName,
    @required this.avatar,
    @required this.playerNumber,
    @required this.userId,
    this.documentId,
  });

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'avatar': avatar,
    };
  }

  static Player fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return Player(
      displayName: map['displayName'],
      avatar: map['avatar'],
      playerNumber: map['playerNumber'],
      userId: map['userId'],
      documentId: documentId,
    );
  }
}

enum GameStatus { Created, Playing, Completed }
