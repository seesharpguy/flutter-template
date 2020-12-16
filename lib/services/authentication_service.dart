import 'package:jibe/utils/locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:jibe/services/firestore_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // final FirestoreService _firestoreService = locator<FirestoreService>();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User _currentUser;
  User get currentUser => _currentUser;

  Future signInWithGoogle() async {
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

    _currentUser = currentUser;
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

  Future<bool> isUserLoggedIn() async {
    var user = _firebaseAuth.currentUser;
    return user != null;
  }

  // Future _populateCurrentUser(User user) async {
  //   if (user != null) {
  //     _currentUser = await _firestoreService.getUser(user.uid);
  //   }
  // }
}
