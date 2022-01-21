import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_puzzle_hack/src/layout/breakpoint_provider.dart';

import 'package:flutter_puzzle_hack/src/sample_feature/sample_item_details_view.dart';
import 'package:flutter_puzzle_hack/src/sample_feature/sample_item_list_view.dart';
import 'package:flutter_puzzle_hack/src/settings/settings_controller.dart';
import 'package:flutter_puzzle_hack/src/settings/settings_view.dart';
import 'package:flutter_puzzle_hack/src/splashscreen/splashscreen.dart';
import 'package:flutter_puzzle_hack/src/theme/app_theme.dart';

/// The Widget that configures your application.
class App extends StatelessWidget {
  const App({
    Key? key,
    required this.settingsController,
    this.initialRoute = 'splashscreen',
  }) : super(key: key);

  final String? initialRoute;
  final SettingsController settingsController;

  Route<dynamic>? generateRoute(RouteSettings routeSettings) {
    return MaterialPageRoute<void>(
      settings: routeSettings,
      builder: (BuildContext context) {
        switch (routeSettings.name) {
          case 'splashscreen':
            return Splashscreen(
              onDone: () => Navigator.pushReplacementNamed(context, '/'),
            );
          case SettingsView.routeName:
            return SettingsView(controller: settingsController);
          case SampleItemDetailsView.routeName:
            return const SampleItemDetailsView();
          case SampleItemListView.routeName:
          default:
            return const SampleItemListView();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context).appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          initialRoute: initialRoute,
          onGenerateRoute: generateRoute,
          builder: (context, child) => BreakpointProvider(
            screenWidth: MediaQuery.of(context).size.width,
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
