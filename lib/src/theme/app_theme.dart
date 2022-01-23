import 'package:flutter/material.dart';

abstract class AppTheme {
  static final light = ThemeData.light().copyWith(
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(color: Color(0xFFE4000F)),
    colorScheme: ColorScheme.fromSwatch(
      accentColor: const Color(0xFFE4000F),
    ),
  );

  static final lightExtra = ExtraThemeData();

  static final dark = ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(color: Color(0xFFE4000F)),
    colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.dark,
      accentColor: const Color(0xFFE4000F),
    ),
  );

  static final darkExtra = ExtraThemeData();
}

class ExtraThemeData {
  ExtraThemeData({
    this.puzzleBackgroundColor,
  });

  final Color? puzzleBackgroundColor;
}

extension ExtraTheme on ThemeData {
  ExtraThemeData get extra =>
      brightness == Brightness.dark ? AppTheme.darkExtra : AppTheme.lightExtra;
}

ExtraThemeData extraTheme(BuildContext context) => Theme.of(context).extra;
