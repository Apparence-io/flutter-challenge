import 'package:flutter_puzzle_hack/boostrap.dart';
import 'package:flutter_puzzle_hack/src/app.dart';
import 'package:flutter_puzzle_hack/src/settings/settings_controller.dart';
import 'package:flutter_puzzle_hack/src/settings/settings_service.dart';

Future<void> main() async {
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();

  await bootstrap(
    () => App(settingsController: settingsController),
    FlavorConfig.development(),
  );
}
