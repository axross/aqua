import "package:aqua/src/models/anonymous_user.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/foundation.dart";

class AuthenticationManager extends ChangeNotifier {
  AuthenticationManager();

  AnonymousUser _user;

  AnonymousUser get user => _user;

  initialize() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    firebaseAuth.onAuthStateChanged.listen((firebaseUser) {
      _user = firebaseUser != null ? AnonymousUser(id: firebaseUser.uid) : null;

      notifyListeners();
    });

    try {
      await firebaseAuth.signInAnonymously();
    } on Exception catch (error) {
      print(error);
    }
  }
}
