import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../domain/app_user.dart';

/// Service d'authentification Firebase (création de compte + connexion via Google).
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  AppUser? get currentUser => _toUser(_auth.currentUser);

  /// Flux d'état d'authentification (déclenche l'affichage de la connexion).
  Stream<AppUser?> get authStateChanges =>
      _auth.authStateChanges().map(_toUser);

  /// Connexion / création de compte avec Google.
  ///
  /// À appeler une seule fois au démarrage avant tout autre usage.
  Future<void> initialize() async {
    await _googleSignIn.initialize();
  }

  Future<AppUser> signInWithGoogle() async {
    final googleAccount = await _googleSignIn.authenticate();
    final authentication = googleAccount.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: authentication.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    final user = _toUser(userCredential.user);
    if (user == null) {
      throw Exception('googleSignInFailed');
    }
    return user;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  AppUser? _toUser(User? user) {
    if (user == null) return null;
    return AppUser(
      uid: user.uid,
      displayName: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
    );
  }
}