import 'package:flutter/widgets.dart';

import '../features/auth/domain/app_user.dart';

/// Expose l'état cloud (utilisateur Firebase connecté ou mode local) à l'arbre.
class CloudScope extends InheritedWidget {
  final AppUser? user;
  final bool cloudEnabled;

  const CloudScope({
    super.key,
    required this.user,
    required this.cloudEnabled,
    required super.child,
  });

  static CloudScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CloudScope>();

  static AppUser? currentUser(BuildContext context) =>
      maybeOf(context)?.user;

  static bool getCloudEnabled(BuildContext context) =>
      maybeOf(context)?.cloudEnabled ?? false;

  @override
  bool updateShouldNotify(CloudScope oldWidget) {
    return oldWidget.user != user || oldWidget.cloudEnabled != cloudEnabled;
  }
}