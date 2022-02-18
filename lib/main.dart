import 'package:flutter_puzzle_hack/boostrap.dart';
import 'package:flutter_puzzle_hack/src/app.dart';

Future<void> main() async {
  await bootstrap(
    App.new,
    FlavorConfig.production(),
  );
}
