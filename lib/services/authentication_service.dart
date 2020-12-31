import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:APPLICATION_NAME/models/user.dart';
import 'package:faker/faker.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // final FirestoreService _firestoreService = locator<FirestoreService>();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Grateful8User _currentUser;
  Grateful8User get currentUser => getGrateful8User();

  Grateful8User getGrateful8User() {
    var user = _firebaseAuth.currentUser;
    if (user != null) {
      setGrateful8User(user);
      return _currentUser;
    } else {
      return null;
    }
  }

  void setGrateful8User(User user) {
    if (user.isAnonymous) {
      var faker = new Faker();

      _currentUser = Grateful8User(
          displayName: faker.internet.userName(),
          uid: user.uid,
          photoURL: "https://robohash.org/${user.uid}");
    } else {
      _currentUser = Grateful8User(
          displayName: user.displayName,
          uid: user.uid,
          photoURL: user.photoURL);
    }
  }

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

    User fbUser = _firebaseAuth.currentUser;

    assert(_user.uid == fbUser.uid);

    setGrateful8User(fbUser);
  }

  Future signInAnonomously() async {
    var authResult = await _firebaseAuth.signInAnonymously();

    User _user = authResult.user;

    print(_user.toString());

    assert(await _user.getIdToken() != null);

    User fbUser = _firebaseAuth.currentUser;

    assert(_user.uid == fbUser.uid);

    setGrateful8User(fbUser);
  }

  Future<bool> logout() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      _currentUser = null;
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> isUserLoggedIn() async {
    var user = _firebaseAuth.currentUser;
    if (user != null) {
      if (user.isAnonymous) {
        return _currentUser != null;
      }
      return user != null;
    } else {
      return false;
    }
  }

  // Future _populateCurrentUser(User user) async {
  //   if (user != null) {
  //     _currentUser = await _firestoreService.getUser(user.uid);
  //   }
  // }
}
