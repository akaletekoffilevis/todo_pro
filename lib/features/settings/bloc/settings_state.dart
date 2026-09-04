import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final Locale locale;
  final bool notifications;

  const SettingsState({
    this.themeMode = ThemeMode.light,
    this.locale = const Locale('en'),
    this.notifications = true,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    bool? notifications,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      notifications: notifications ?? this.notifications,
    );
  }

  @override
  List<Object?> get props => [themeMode, locale, notifications];
}
