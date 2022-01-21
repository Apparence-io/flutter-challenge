import 'package:flutter/widgets.dart';
import 'package:flutter_puzzle_hack/src/layout/breakpoint_provider.dart';
import 'package:flutter_puzzle_hack/src/layout/responsive_layout_builder.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/helpers.dart';

void main() {
  const xsmallKey = Key('__xsmall__');
  const smallKey = Key('__small__');
  const mediumKey = Key('__medium__');
  const largeKey = Key('__large__');
  const xlargeKey = Key('__xlarge__');
  const childKey = Key('__child__');

  Future<void> pumpResponsiveLayoutBuilder(WidgetTester tester) {
    return tester.pumpApp(
      ResponsiveLayoutBuilder(
        xsmall: (_, __) => const SizedBox(key: xsmallKey),
        small: (_, __) => const SizedBox(key: smallKey),
        medium: (_, __) => const SizedBox(key: mediumKey),
        large: (_, __) => const SizedBox(key: largeKey),
        xlarge: (_, __) => const SizedBox(key: xlargeKey),
      ),
    );
  }

  Future<Breakpoint?> pumpResponsiveLayoutBuilderWithChild(
    WidgetTester tester,
  ) {
    Breakpoint? breakpoint;

    return tester
        .pumpApp(
          ResponsiveLayoutBuilder(
            xsmall: (_, child) => SizedBox(key: xsmallKey, child: child),
            small: (_, child) => SizedBox(key: smallKey, child: child),
            medium: (_, child) => SizedBox(key: mediumKey, child: child),
            large: (_, child) => SizedBox(key: largeKey, child: child),
            xlarge: (_, child) => SizedBox(key: xlargeKey, child: child),
            child: (currentBreakpoint) {
              breakpoint = currentBreakpoint;

              return const SizedBox(key: childKey);
            },
          ),
        )
        .then((value) => Future.value(breakpoint));
  }

  group('ResponsiveLayoutBuilder', () {
    group('on a xsmall display', () {
      testWidgets(
        'displays a xsmall layout',
        (tester) async {
          tester.setXSmallDisplaySize();
          await pumpResponsiveLayoutBuilder(tester);

          expect(find.byKey(xsmallKey), findsOneWidget);
          expect(find.byKey(smallKey), findsNothing);
          expect(find.byKey(mediumKey), findsNothing);
          expect(find.byKey(largeKey), findsNothing);
          expect(find.byKey(xlargeKey), findsNothing);
          final dynamic exception = tester.takeException();
          expect(exception, isNull);
        },
      );

      testWidgets(
        'displays child when available',
        (tester) async {
          tester.setXSmallDisplaySize();
          await pumpResponsiveLayoutBuilderWithChild(tester);

          expect(find.byKey(xsmallKey), findsOneWidget);
          expect(find.byKey(smallKey), findsNothing);
          expect(find.byKey(mediumKey), findsNothing);
          expect(find.byKey(largeKey), findsNothing);
          expect(find.byKey(xlargeKey), findsNothing);
          expect(find.byKey(childKey), findsOneWidget);
          final dynamic exception = tester.takeException();
          expect(exception, isNull);
        },
      );

      testWidgets(
        'return xsmall layout size for child',
        (tester) async {
          tester.setXSmallDisplaySize();
          final breakpoint = await pumpResponsiveLayoutBuilderWithChild(tester);
          expect(breakpoint, Breakpoint.xsmall);
          final dynamic exception = tester.takeException();
          expect(exception, isNull);
        },
      );
    });

    group('on a small display', () {
      testWidgets(
        'displays a small layout',
        (tester) async {
          tester.setSmallDisplaySize();
          await pumpResponsiveLayoutBuilder(tester);

          expect(find.byKey(xsmallKey), findsNothing);
          expect(find.byKey(smallKey), findsOneWidget);
          expect(find.byKey(mediumKey), findsNothing);
          expect(find.byKey(largeKey), findsNothing);
          expect(find.byKey(xlargeKey), findsNothing);
          final dynamic exception = tester.takeException();
          expect(exception, isNull);
        },
      );

      testWidgets(
        'displays child when available',
        (tester) async {
          tester.setSmallDisplaySize();
          await pumpResponsiveLayoutBuilderWithChild(tester);

          expect(find.byKey(xsmallKey), findsNothing);
          expect(find.byKey(smallKey), findsOneWidget);
          expect(find.byKey(mediumKey), findsNothing);
          expect(find.byKey(largeKey), findsNothing);
          expect(find.byKey(xlargeKey), findsNothing);
          expect(find.byKey(childKey), findsOneWidget);
          final dynamic exception = tester.takeException();
          expect(exception, isNull);
        },
      );

      testWidgets(
        'return small layout size for child',
        (tester) async {
          tester.setSmallDisplaySize();
          final breakpoint = await pumpResponsiveLayoutBuilderWithChild(tester);
          expect(breakpoint, Breakpoint.small);
          final dynamic exception = tester.takeException();
          expect(exception, isNull);
        },
      );
    });

    group('on a medium display', () {
      testWidgets(
        'displays a medium layout',
        (tester) async {
          tester.setMediumDisplaySize();
          await pumpResponsiveLayoutBuilder(tester);

          expect(find.byKey(xsmallKey), findsNothing);
          expect(find.byKey(smallKey), findsNothing);
          expect(find.byKey(mediumKey), findsOneWidget);
          expect(find.byKey(largeKey), findsNothing);
          expect(find.byKey(xlargeKey), findsNothing);
          final dynamic exception = tester.takeException();
          expect(exception, isNull);
        },
      );

      testWidgets(
        'displays child when available',
        (tester) async {
          tester.setMediumDisplaySize();
          await pumpResponsiveLayoutBuilderWithChild(tester);

          expect(find.byKey(xsmallKey), findsNothing);
          expect(find.byKey(smallKey), findsNothing);
          expect(find.byKey(mediumKey), findsOneWidget);
          expect(find.byKey(largeKey), findsNothing);
          expect(find.byKey(xlargeKey), findsNothing);
          expect(find.byKey(childKey), findsOneWidget);
          final dynamic exception = tester.takeException();
          expect(exception, isNull);
        },
      );

      testWidgets(
        'return medium layout size for child',
        (tester) async {
          tester.setMediumDisplaySize();
          final breakpoint = await pumpResponsiveLayoutBuilderWithChild(tester);
          expect(breakpoint, Breakpoint.medium);
          final dynamic exception = tester.takeException();
          expect(exception, isNull);
        },
      );
    });

    group('on a large display', () {
      testWidgets(
        'displays a large layout',
        (tester) async {
          tester.setLargeDisplaySize();
          await pumpResponsiveLayoutBuilder(tester);

          expect(find.byKey(xsmallKey), findsNothing);
          expect(find.byKey(smallKey), findsNothing);
          expect(find.byKey(mediumKey), findsNothing);
          expect(find.byKey(largeKey), findsOneWidget);
          expect(find.byKey(xlargeKey), findsNothing);
          final dynamic exception = tester.takeException();
          expect(exception, isNull);
        },
      );

      testWidgets(
        'displays child when available',
        (tester) async {
          tester.setLargeDisplaySize();
          await pumpResponsiveLayoutBuilderWithChild(tester);

          expect(find.byKey(xsmallKey), findsNothing);
          expect(find.byKey(smallKey), findsNothing);
          expect(find.byKey(mediumKey), findsNothing);
          expect(find.byKey(largeKey), findsOneWidget);
          expect(find.byKey(xlargeKey), findsNothing);
          expect(find.byKey(childKey), findsOneWidget);
          final dynamic exception = tester.takeException();
          expect(exception, isNull);
        },
      );

      testWidgets(
        'return large layout size for child',
        (tester) async {
          tester.setLargeDisplaySize();
          final breakpoint = await pumpResponsiveLayoutBuilderWithChild(tester);
          expect(breakpoint, Breakpoint.large);
          final dynamic exception = tester.takeException();
          expect(exception, isNull);
        },
      );
    });

    group('on a xlarge display', () {
      testWidgets(
        'displays a xlarge layout',
        (tester) async {
          tester.setXLargeDisplaySize();
          await pumpResponsiveLayoutBuilder(tester);

          expect(find.byKey(xsmallKey), findsNothing);
          expect(find.byKey(smallKey), findsNothing);
          expect(find.byKey(mediumKey), findsNothing);
          expect(find.byKey(largeKey), findsNothing);
          expect(find.byKey(xlargeKey), findsOneWidget);
          final dynamic exception = tester.takeException();
          expect(exception, isNull);
        },
      );

      testWidgets(
        'displays child when available',
        (tester) async {
          tester.setXLargeDisplaySize();
          await pumpResponsiveLayoutBuilderWithChild(tester);

          expect(find.byKey(xsmallKey), findsNothing);
          expect(find.byKey(smallKey), findsNothing);
          expect(find.byKey(mediumKey), findsNothing);
          expect(find.byKey(largeKey), findsNothing);
          expect(find.byKey(xlargeKey), findsOneWidget);
          expect(find.byKey(childKey), findsOneWidget);
          final dynamic exception = tester.takeException();
          expect(exception, isNull);
        },
      );

      testWidgets(
        'return xlarge layout size for child',
        (tester) async {
          tester.setXLargeDisplaySize();
          final breakpoint = await pumpResponsiveLayoutBuilderWithChild(tester);
          expect(breakpoint, Breakpoint.xlarge);
          final dynamic exception = tester.takeException();
          expect(exception, isNull);
        },
      );
    });

    testWidgets(
      'fallbacks with a smaller layout builder when missing a layout builder',
      (tester) async {
        tester.setXLargeDisplaySize();
        Breakpoint? breakpoint;
        await tester.pumpApp(
          ResponsiveLayoutBuilder(
            xsmall: (_, child) => SizedBox(key: xsmallKey, child: child),
            small: (_, child) => SizedBox(key: smallKey, child: child),
            medium: (_, child) => SizedBox(key: mediumKey, child: child),
            child: (currentBreakpoint) {
              breakpoint = currentBreakpoint;

              return const SizedBox(key: childKey);
            },
          ),
        );

        expect(find.byKey(xsmallKey), findsNothing);
        expect(find.byKey(smallKey), findsNothing);
        expect(find.byKey(mediumKey), findsOneWidget);
        expect(find.byKey(largeKey), findsNothing);
        expect(find.byKey(xlargeKey), findsNothing);
        expect(find.byKey(childKey), findsOneWidget);
        expect(breakpoint, Breakpoint.xlarge);
        final dynamic exception = tester.takeException();
        expect(exception, isNull);
      },
    );

    testWidgets(
      'fallbacks with child widget builder when no layout builder is found',
      (tester) async {
        tester.setXSmallDisplaySize();
        await tester.pumpApp(
          ResponsiveLayoutBuilder(
            child: (_) => const SizedBox(key: childKey),
          ),
        );

        expect(find.byKey(childKey), findsOneWidget);
        final dynamic exception = tester.takeException();
        expect(exception, isNull);
      },
    );
  });
}
