import 'package:flutter/material.dart';

import '../data/auth_service.dart';
import '../domain/app_user.dart';
import 'login_controller.dart';
import 'login_screen.dart';

/// Aiguille entre l'écran de connexion et l'application selon l'état d'auth.
class AuthGate extends StatelessWidget {
  final AuthService authService;
  final Widget Function(AppUser) appBuilder;

  const AuthGate({super.key, required this.authService, required this.appBuilder});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppUser?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final user = snapshot.data;
        if (user == null) {
          return LoginScreen(controller: LoginController(authService));
        }
        return appBuilder(user);
      },
    );
  }
}