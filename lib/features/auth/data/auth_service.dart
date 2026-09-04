import 'package:firebase_auth/firebase_auth.dart';

import '../domain/app_user.dart';

/// Service d'authentification Firebase (création de compte + connexion
/// par e-mail / mot de passe — fonctionne sans configuration OAuth Android).
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser? get currentUser => _toUser(_auth.currentUser);

  /// Flux d'état d'authentification (déclenche l'affichage de la connexion).
  Stream<AppUser?> get authStateChanges =>
      _auth.authStateChanges().map(_toUser);

  /// Création d'un compte.
  Future<AppUser> registerWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    if (displayName != null && displayName.isNotEmpty) {
      await credential.user?.updateDisplayName(displayName);
    }
    final user = _toUser(credential.user);
    if (user == null) throw Exception('authFailed');
    return user;
  }

  /// Connexion à un compte existant.
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = _toUser(credential.user);
    if (user == null) throw Exception('authFailed');
    return user;
  }

  Future<void> signOut() => _auth.signOut();

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