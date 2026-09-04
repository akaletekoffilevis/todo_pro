import '../data/auth_service.dart';
import '../domain/app_user.dart';

/// Pont entre l'écran de connexion et le service d'auth (testable).
class LoginController {
  final AuthService authService;

  LoginController(this.authService);

  Future<AppUser> signIn() => authService.signInWithGoogle();
}