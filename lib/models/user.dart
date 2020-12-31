class JibeUser {
  final String uid;
  final String displayName;
  final String photoURL;

  JibeUser({this.uid, this.displayName, this.photoURL});

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'displayName': displayName, 'photoURL': photoURL};
  }

  static JibeUser fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return JibeUser(
        displayName: map['displayName'],
        uid: map['uid'],
        photoURL: map['photoURL']);
  }
}
