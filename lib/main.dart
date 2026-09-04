import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'l10n/generated/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/home/bloc/task_bloc.dart';
import 'features/home/bloc/task_event.dart';
import 'features/home/data/datasources/hive_task_local_datasource.dart';
import 'features/home/data/repositories/task_repository_impl.dart';
import 'features/home/domain/task_repository.dart';
import 'features/settings/bloc/settings_cubit.dart';
import 'features/settings/bloc/settings_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  final datasource = HiveTaskLocalDatasource();
  await datasource.init();
  final repository = TaskRepositoryImpl(datasource);

  runApp(TasklyApp(repository: repository));
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
