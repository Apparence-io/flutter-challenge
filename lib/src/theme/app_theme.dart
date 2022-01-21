import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData.light().copyWith(
      appBarTheme: const AppBarTheme(color: Color(0xFFE4000F)),
      colorScheme: ColorScheme.fromSwatch(
        accentColor: const Color(0xFFE4000F),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData.dark().copyWith(
      appBarTheme: const AppBarTheme(color: Color(0xFFE4000F)),
      colorScheme: ColorScheme.fromSwatch(
        accentColor: const Color(0xFFE4000F),
      ),
    );
  }
}
