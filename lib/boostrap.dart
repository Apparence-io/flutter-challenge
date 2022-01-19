import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

Future<void> bootstrap(
  FutureOr<Widget> Function() builder,
  FlavorConfig flavorConfig,
) async {
  AppLogger.init(flavorConfig);
  FlutterError.onError = Logger('error').severe;

  Logger('bootstrap')
    ..info('------------------------------')
    ..info('Starting Flutter Puzzle Hack')
    ..info('$flavorConfig')
    ..info('------------------------------');

  runApp(await builder());
}

// ignore: prefer-match-file-name
enum Flavor { development, staging, test, production }

class FlavorConfig {
  FlavorConfig(this.flavor, this.logLevel);

  factory FlavorConfig.development() =>
      FlavorConfig(Flavor.development, Level.ALL);

  factory FlavorConfig.test() => FlavorConfig(Flavor.test, Level.ALL);

  factory FlavorConfig.staging() => FlavorConfig(Flavor.staging, Level.INFO);

  factory FlavorConfig.production() =>
      FlavorConfig(Flavor.production, Level.SEVERE);

  final Flavor flavor;
  final Level logLevel;

  @override
  String toString() {
    return 'FlavorConfig { flavor: ${flavor.name}, logLevel: $logLevel }';
  }
}

class AppLogger {
  AppLogger(this.flavorConfig);

  static late final AppLogger instance;

  final FlavorConfig flavorConfig;

  static void init(FlavorConfig flavorConfig) {
    AppLogger.instance = AppLogger(flavorConfig);
    AppLogger.instance._init();
  }

  void _init() {
    Logger.root.level = flavorConfig.logLevel;
    if (flavorConfig.flavor != Flavor.production) {
      Logger.root.onRecord.listen(_logToStdout);
    }
  }

  void _logToStdout(LogRecord record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  }
}
