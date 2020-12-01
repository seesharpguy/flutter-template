import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<bool> isLoggedIn() async {
    try {
      User user = _firebaseAuth.currentUser;
      return user != null;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<User> currentUser() async {
    try {
      User user = _firebaseAuth.currentUser;
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> logout() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  String getAvatarUrl() {
    String url = "http://www.gravatar.com/avatar/?d=mp&s=200";
    try {
      User user = _firebaseAuth.currentUser;

      if (user != null) {
        String photoUrl = user.photoURL;
        if (photoUrl != null) {
          url = photoUrl;
        }
      }
      print(url);
      return url;
    } catch (e) {
      return url;
    }
  }

  Future<User> signInWithGoogle() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();

    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    UserCredential authResult =
        await _firebaseAuth.signInWithCredential(credential);

    User _user = authResult.user;

    assert(!_user.isAnonymous);

    assert(await _user.getIdToken() != null);

    User currentUser = _firebaseAuth.currentUser;

    assert(_user.uid == currentUser.uid);

    print("User Name: ${_user.displayName}");
    print("User Email ${_user.email}");

    return currentUser;
  }
}
