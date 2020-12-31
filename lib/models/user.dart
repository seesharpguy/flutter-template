class Grateful8User {
  final String uid;
  final String displayName;
  final String photoURL;

  Grateful8User({this.uid, this.displayName, this.photoURL});

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'displayName': displayName, 'photoURL': photoURL};
  }

  static Grateful8User fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Grateful8User(
        displayName: map['displayName'],
        uid: map['uid'],
        photoURL: map['photoURL']);
  }
}
