import 'package:flutter/foundation.dart';

class Game {
  final String title;
  final String imageUrl;
  final String userId;
  final String documentId;

  Game({
    @required this.userId,
    @required this.title,
    this.documentId,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'imageUrl': imageUrl,
    };
  }

  static Game fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return Game(
      title: map['title'],
      imageUrl: map['imageUrl'],
      userId: map['userId'],
      documentId: documentId,
    );
  }
}

class Player {
  final String displayName;
  final String avatar;
  final String documentId;

  Player({
    @required this.displayName,
    @required this.avatar,
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
      documentId: documentId,
    );
  }
}
