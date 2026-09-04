import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'l10n/generated/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/cloud_scope.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/auth_service.dart';
import 'features/auth/domain/app_user.dart';
import 'features/auth/presentation/auth_gate.dart';
import 'features/home/bloc/task_bloc.dart';
import 'features/home/bloc/task_event.dart';
import 'features/home/data/datasources/hive_task_local_datasource.dart';
import 'features/home/data/repositories/task_repository_impl.dart';
import 'features/home/domain/task_repository.dart';
import 'features/settings/bloc/settings_cubit.dart';
import 'features/settings/bloc/settings_state.dart';
import 'features/sync/firebase_task_datasource.dart';
import 'features/sync/firebase_task_repository.dart';
import 'firebase_options.dart';

/// Firebase (Auth Google + Firestore) est supporté sur mobile/web.
/// Sur desktop (Linux), l'app bascule automatiquement en mode local.
bool get _firebaseSupported {
  if (kIsWeb) return true;
  final p = Platform.operatingSystem;
  return p == 'android' || p == 'ios' || p == 'macos' || p == 'windows';
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  final local = HiveTaskLocalDatasource();
  await local.init();

  AuthService? authService;
  if (_firebaseSupported) {
    try {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      authService = AuthService();
      await authService.initialize();
    } catch (_) {
      authService = null;
    }
  }

  runApp(
    TasklyRoot(
      local: local,
      authService: authService,
    ),
  );
}

class TasklyRoot extends StatelessWidget {
  final HiveTaskLocalDatasource local;
  final AuthService? authService;

  const TasklyRoot({
    super.key,
    required this.local,
    required this.authService,
  });

  @override
  Widget build(BuildContext context) {
    final cloud = authService != null;

    if (cloud) {
      return AuthGate(
        authService: authService!,
        appBuilder: (user) => CloudScope(
          user: user,
          cloudEnabled: true,
          child: TasklyApp(
            repository: _cloudRepository(user),
          ),
        ),
      );
    }
    return CloudScope(
      user: null,
      cloudEnabled: false,
      child: TasklyApp(repository: TaskRepositoryImpl(local)),
    );
  }

  TaskRepository _cloudRepository(AppUser user) {
    return FirebaseTaskRepository(
      user: user,
      datasource: FirebaseTaskDatasource(FirebaseFirestore.instance),
      local: local,
    );
  }
}

class TasklyApp extends StatelessWidget {
  final TaskRepository repository;

  const TasklyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SettingsCubit()),
        BlocProvider(
          create: (_) => TaskBloc(repository: repository)..add(LoadTasks()),
        ),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settings) {
          return MaterialApp.router(
            title: 'Taskly',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: settings.themeMode,
            routeInformationParser: router.routeInformationParser,
            routerDelegate: router.routerDelegate,
            routeInformationProvider: router.routeInformationProvider,
            supportedLocales: const [Locale('en'), Locale('fr')],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: settings.locale,
          );
        },
      ),
    );
  }
}