import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:task_logger/core/extensions/localization_extension.dart';
import 'package:task_logger/core/resources/themes.dart';
import 'package:task_logger/features/containers/lifecycle_event_container.dart';
import 'package:task_logger/l10n/l10n.dart';

class App extends StatefulWidget {
  const App({super.key, required this.getIt, required this.router});

  final GetIt getIt;
  final GoRouter router;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final textScaleRange =
        mediaQuery.textScaler.clamp(minScaleFactor: 0.9, maxScaleFactor: 1.08);
    return MultiBlocProvider(
        providers: [
          RepositoryProvider<GetIt>.value(value: widget.getIt),
        ],
        child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: textScaleRange,
            ),
            child: LifecycleEventContainer(
                child: MaterialApp.router(
              scrollBehavior: const _CustomScrollBehavior(),
              onGenerateTitle: (context) => context.localization.appName,
              theme: MaterialAppThemes.lightTheme,
              darkTheme: MaterialAppThemes.darkTheme,
              themeMode: ThemeMode.light,
              debugShowCheckedModeBanner: false,
              routerDelegate: widget.router.routerDelegate,
              routeInformationProvider: widget.router.routeInformationProvider,
              routeInformationParser: widget.router.routeInformationParser,
              localizationsDelegates: const [
                AppLocalization.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalization.delegate.supportedLocales,
              locale: const Locale('en'),
            ))));
  }
}

class _CustomScrollBehavior extends ScrollBehavior {
  const _CustomScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return const BouncingScrollPhysics();
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return const ClampingScrollPhysics();
    }
  }
}
