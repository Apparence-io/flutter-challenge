# Flutter Puzzle Hack

![coverage][coverage_badge]
[![License: MIT][license_badge]][license_link]

Flutter Puzzle Hack Challenge

---

## Getting Started 🚀

This project contains 3 flavors:

- development
- staging
- production

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
# Development
$ flutter run --flavor development --target lib/main_development.dart

# Staging
$ flutter run --flavor staging --target lib/main_staging.dart

# Production
$ flutter run --flavor production --target lib/main.dart
```

---

## Running Tests 🧪

To run all unit and widget tests use the launch configuration in VSCode/Android Studio or use the following command:

```sh
$ flutter test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

---

## Working with Translations 🌐

This project relies on [flutter_localizations][flutter_localizations_link] and follows the [official internationalization guide for Flutter][internationalization_link].

### Adding Strings

1. To add a new localizable string, open the `app_en.arb` file at `lib/l10n/arb/app_en.arb`.

```arb
{
  "@@locale": "en",
  "appTitle": "Flutter Puzzle Hack",
  "@appTitle": {
    "description": "The title of the application"
  }
}
```

2. Then add a new key/value and description

```arb
{
  "@@locale": "en",
  "appTitle": "Flutter Puzzle Hack",
  "@appTitle": {
    "description": "The title of the application"
  }
  "helloWorld": "Hello World",
  "@helloWorld": {
      "description": "Hello World Text"
  }
}
```

3. Use the new string

```dart
import 'package:flutter_puzzle_hack/src/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

### Adding Supported Locales

Update the `CFBundleLocalizations` array in the `Info.plist` at `ios/Runner/Info.plist` to include the new locale.

```xml
    ...

    <key>CFBundleLocalizations</key>
	<array>
		<string>en</string>
		<string>fr</string>
	</array>

    ...
```

### Adding Translations

1. For each supported locale, add a new ARB file in `lib/l10n/arb`.

```text
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   └── app_fr.arb
```

2. Add the translated strings to each `.arb` file:

`app_en.arb`

```arb
{
  "@@locale": "en",
  "appTitle": "Flutter Puzzle Hack",
  "@appTitle": {
    "description": "The title of the application"
  }
}
```

`app_fr.arb`

```arb
{
  "@@locale": "fr",
  "appTitle": "Flutter Puzzle Hack",
  "@appTitle": {
    "description": "Le titre de l'application"
  }
}
```

[coverage_badge]: coverage_badge.svg
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT