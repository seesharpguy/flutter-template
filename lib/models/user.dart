class JibeUser {
  final String id;
  final String fullName;
  final String email;
  final String userRole;

  JibeUser({this.id, this.fullName, this.email, this.userRole});

  JibeUser.fromData(Map<String, dynamic> data)
      : id = data['id'],
        fullName = data['fullName'],
        email = data['email'],
        userRole = data['userRole'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'userRole': userRole,
    };
  }
}
