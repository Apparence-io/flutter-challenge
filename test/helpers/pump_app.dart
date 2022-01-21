import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_puzzle_hack/src/l10n/l10n.dart';
import 'package:flutter_puzzle_hack/src/layout/breakpoint_provider.dart';
import 'package:flutter_test/flutter_test.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget widget) {
    return pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            return BreakpointProvider(
              screenWidth: MediaQuery.of(context).size.width,
              child: widget,
            );
          },
        ),
      ),
    );
  }
}
