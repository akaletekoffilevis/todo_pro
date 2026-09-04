import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'settings_state.dart';

/// Cubit gérant les préférences applicatives (thème, langue, notifications).
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  void toggleTheme() {
    final next = state.themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    emit(state.copyWith(themeMode: next));
  }

  void setTheme(ThemeMode mode) {
    emit(state.copyWith(themeMode: mode));
  }

  void setLocale(Locale locale) {
    emit(state.copyWith(locale: locale));
  }

  void toggleNotifications() {
    emit(state.copyWith(notifications: !state.notifications));
  }
}
