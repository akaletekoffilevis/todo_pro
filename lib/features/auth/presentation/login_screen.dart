import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/responsive_wrapper.dart';
import 'login_controller.dart';

/// Écran de connexion / création de compte (email + mot de passe).
class LoginScreen extends StatefulWidget {
  final LoginController controller;

  const LoginScreen({super.key, required this.controller});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _registering = false;
  bool _loading = false;
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      if (_registering) {
        await widget.controller.registerWithEmail(
          email: _emailController.text,
          password: _passwordController.text,
          displayName: _nameController.text.trim(),
        );
      } else {
        await widget.controller.signInWithEmail(
          email: _emailController.text,
          password: _passwordController.text,
        );
      }
      // Le AuthGate bascule automatiquement sur l'application.
    } on Exception {
      if (mounted) {
        setState(() => _error = 'authError');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: ResponsiveWrapper(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 88,
                      height: 88,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppTheme.gradient,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 44,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.loginTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _registering ? l10n.loginCreateSubtitle : l10n.loginSubtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (_registering) ...[
                    TextFormField(
                      key: const Key('login_name_field'),
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: l10n.loginName,
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      validator: _registering
                          ? (v) => (v == null || v.trim().isEmpty)
                              ? l10n.loginNameRequired
                              : null
                          : null,
                    ),
                    const SizedBox(height: 12),
                  ],
                  TextFormField(
                    key: const Key('login_email_field'),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: l10n.loginEmail,
                      prefixIcon: const Icon(Icons.mail_outline),
                    ),
                    validator: (v) => (v == null || !v.contains('@'))
                        ? l10n.loginEmailRequired
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    key: const Key('login_password_field'),
                    controller: _passwordController,
                    obscureText: _obscure,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    decoration: InputDecoration(
                      labelText: l10n.loginPassword,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        tooltip: l10n.loginShowPassword,
                        onPressed: () =>
                            setState(() => _obscure = !_obscure),
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                    validator: (v) =>
                        (v == null || v.length < 6) ? l10n.loginPasswordShort : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 54,
                    child: FilledButton(
                      onPressed: _loading ? null : _submit,
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              _registering
                                  ? l10n.loginCreateAction
                                  : l10n.loginAction,
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _loading
                        ? null
                        : () {
                            setState(() {
                              _registering = !_registering;
                              _error = null;
                            });
                          },
                    child: Text(
                      _registering ? l10n.loginHaveAccount : l10n.loginNoAccount,
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      l10n.authError,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    l10n.loginPrivacy,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}