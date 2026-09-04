import '../data/auth_service.dart';
import '../domain/app_user.dart';

/// Pont entre l'écran de connexion et le service d'auth (testable).
class LoginController {
  final AuthService authService;

  LoginController(this.authService);

  Future<AppUser> registerWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) {
    return authService.registerWithEmail(
      email: email,
      password: password,
      displayName: displayName,
    );
  }

  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) {
    return authService.signInWithEmail(email: email, password: password);
  }
}