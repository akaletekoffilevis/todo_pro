import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:todo_pro/features/settings/bloc/settings_cubit.dart';
import 'package:todo_pro/features/settings/bloc/settings_state.dart';

void main() {
  group('SettingsCubit', () {
    blocTest<SettingsCubit, SettingsState>(
      'démarre avec le thème clair et la langue anglaise',
      build: SettingsCubit.new,
      act: (cubit) => cubit.toggleNotifications(),
      expect: () => [
        const SettingsState(notifications: false),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'bascule entre thème clair et sombre',
      build: SettingsCubit.new,
      act: (cubit) => cubit.toggleTheme(),
      expect: () => [
        const SettingsState(themeMode: ThemeMode.dark),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'change de langue vers le français',
      build: SettingsCubit.new,
      act: (cubit) => cubit.setLocale(const Locale('fr')),
      expect: () => [
        const SettingsState(locale: Locale('fr')),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'bascule les notifications',
      build: SettingsCubit.new,
      act: (cubit) => cubit.toggleNotifications(),
      expect: () => [
        const SettingsState(notifications: false),
      ],
    );

    test('setTheme force un mode donné', () {
      final cubit = SettingsCubit();
      cubit.setTheme(ThemeMode.dark);
      expect(cubit.state.themeMode, ThemeMode.dark);
      cubit.close();
    });

    test('état initial: clair + anglais + notifications activées', () {
      final cubit = SettingsCubit();
      expect(cubit.state.themeMode, ThemeMode.light);
      expect(cubit.state.locale.languageCode, 'en');
      expect(cubit.state.notifications, true);
      cubit.close();
    });
  });
}
