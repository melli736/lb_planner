import 'dart:async';

import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lb_planner/assets.dart';
import 'package:lb_planner/helpers.dart';
import 'package:lb_planner/routes.dart';
import 'package:lb_planner/widgets.dart';
import 'package:lbplanner_engine/lbplanner_engine.dart';
import 'package:nekolib_ui/core.dart';
import 'package:nekolib_utils/log.dart';

/// Navigator key for [Catcher].
final kNavigator = GlobalKey<NavigatorState>();

/// How long to wait before a log file is deleted.
const kMaxLogFileAge = Duration(days: 7);

void main() async {
  Logger.init(autoSave: true, appStoragePath: (await Disk.appDir).path);
  await Logger.logFile; // I don't know why, but the log file is otherwise not created.

  // Randomly selected outside of build for consistency of the animtion when applying the theme
  var animation = (kLoadingAnimations.toList()..shuffle()).first;

  Catcher(
    navigatorKey: kNavigator,
    releaseConfig: LpReportMode.config,
    debugConfig: LpReportMode.config,
    runAppFunction: () async {
      WidgetsFlutterBinding.ensureInitialized();

      runThemedApp(
        appBuilder: App.builder,
        title: 'LB Planner',
        minSize: const Size(1200, 700),
        onLoad: load,
        windowHandleColor: () => primaryColor,
        loadingWidgetBuilder: (_) => LpLoadingIndicator.rive(animation: animation),
        singleInstanceUuid: "necodeIT.lb_planner.mutex",
      );
    },
  );
}

/// Loads data from disk and returns a [Future] that completes when the data is loaded.
Future<void> load() async {
  await UserDisk.loadUser();

  if (UserDisk.data != null && !UserDisk.data!.invalid) {
    applyUserTheme(UserDisk.data!);

    var r = await PluginConfigApi.getVersion(UserDisk.data!.token);

    if (r.value != null) {
      gPluginVersion = r.value;
      await kUpdater.update();
    }
  }

  var dir = await Logger.logDir;

  for (var file in dir.listSync()) {
    var stats = await file.stat();

    if (stats.modified.isBefore(DateTime.now().subtract(kMaxLogFileAge))) file.deleteSync();
  }
}

/// Main app widget.
class App extends StatelessWidget {
  /// Main app widget.
  const App({Key? key}) : super(key: key);

  /// Builder for convinience.
  static App builder(context) => App();

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Consumer(
        builder: (context, ref, _) {
          var user = ref.read(userProvider);

          return MaterialApp(
            navigatorKey: kNavigator,
            theme: appStyle,
            localizationsDelegates: const [
              LocaleNamesLocalizationsDelegate(),
              ...AppLocalizations.localizationsDelegates,
            ],
            navigatorObservers: [kRouteObserver],
            supportedLocales: AppLocalizations.supportedLocales,
            debugShowCheckedModeBanner: false,
            initialRoute: user.invalid ? LoginRoute.info.routeName : DashboardRoute.info.routeName,
            onGenerateRoute: RouteWrapper.gnerateRoute,
          );
        },
      ),
    );
  }
}
