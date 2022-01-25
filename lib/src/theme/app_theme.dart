import 'package:flutter/material.dart';

abstract class AppTheme {
  static final light = ThemeData.light().copyWith(
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(color: Color(0xFFE4000F)),
    colorScheme: ColorScheme.fromSwatch(
      accentColor: const Color(0xFFE4000F),
    ),
    backgroundColor: const Color(0xFF75bfff),
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: 42,
        fontWeight: FontWeight.w600,
        color: Color(0xFFFFFFFF),
      ),
      headline2: TextStyle(
        fontSize: 35,
        fontWeight: FontWeight.w600,
        color: Color(0xFFFFFFFF),
      ),
      headline3: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        color: Color(0xFFFFFFFF),
      ),
      headline4: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Color(0xFFFFFFFF),
      ),
      button: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFFFFFFFF),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        enableFeedback: true,
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
        ),
      ),
    ),
    cardTheme: const CardTheme(
      color: Color(0xFF75bfff),
      elevation: 0,
    ),
    iconTheme: const IconThemeData(
      color: Color(0xFFFFFFFF),
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
    backgroundColor: const Color(0xFF104673),
    textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: 42,
        fontWeight: FontWeight.w600,
        color: Color(0xFFFFFFFF),
      ),
      headline2: TextStyle(
        fontSize: 35,
        fontWeight: FontWeight.w600,
        color: Color(0xFFFFFFFF),
      ),
      headline3: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        color: Color(0xFFFFFFFF),
      ),
      headline4: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Color(0xFFFFFFFF),
      ),
      button: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFFFFFFFF),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        enableFeedback: true,
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
        ),
      ),
    ),
    cardTheme: const CardTheme(
      color: Color(0xFF104673),
      elevation: 0,
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
