import 'package:flutter/widgets.dart';
import 'package:flutter_puzzle_hack/src/layout/breakpoint_provider.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/helpers.dart';

void main() {
  group('BreakpointProvider', () {
    testWidgets(
      'provide xsmall breakpoint for sizes smaller than small',
      (tester) async {
        tester.setXSmallDisplaySize();
        var tested = false;
        await tester.pumpApp(
          Builder(
            builder: (BuildContext context) {
              expect(BreakpointProvider.of(context), Breakpoint.xsmall);
              tested = true;

              return Container();
            },
          ),
        );

        final dynamic exception = tester.takeException();
        expect(exception, isNull);
        expect(tested, isTrue);
      },
    );

    testWidgets(
      'provide small breakpoint for sizes larger than small',
      (tester) async {
        tester.setSmallDisplaySize();
        var tested = false;
        await tester.pumpApp(
          Builder(
            builder: (BuildContext context) {
              expect(BreakpointProvider.of(context), Breakpoint.small);
              tested = true;

              return Container();
            },
          ),
        );

        final dynamic exception = tester.takeException();
        expect(exception, isNull);
        expect(tested, isTrue);
      },
    );

    testWidgets(
      'provide medium breakpoint for sizes larger than medium',
      (tester) async {
        tester.setMediumDisplaySize();
        var tested = false;
        await tester.pumpApp(
          Builder(
            builder: (BuildContext context) {
              expect(BreakpointProvider.of(context), Breakpoint.medium);
              tested = true;

              return Container();
            },
          ),
        );

        final dynamic exception = tester.takeException();
        expect(exception, isNull);
        expect(tested, isTrue);
      },
    );

    testWidgets(
      'provide large breakpoint for sizes larger than large',
      (tester) async {
        tester.setLargeDisplaySize();
        var tested = false;
        await tester.pumpApp(
          Builder(
            builder: (BuildContext context) {
              expect(BreakpointProvider.of(context), Breakpoint.large);
              tested = true;

              return Container();
            },
          ),
        );

        final dynamic exception = tester.takeException();
        expect(exception, isNull);
        expect(tested, isTrue);
      },
    );

    testWidgets(
      'provide xlarget breakpoint for sizes larger than xlarger',
      (tester) async {
        tester.setXLargeDisplaySize();
        var tested = false;
        await tester.pumpApp(
          Builder(
            builder: (BuildContext context) {
              expect(BreakpointProvider.of(context), Breakpoint.xlarge);
              tested = true;

              return Container();
            },
          ),
        );

        final dynamic exception = tester.takeException();
        expect(exception, isNull);
        expect(tested, isTrue);
      },
    );

    testWidgets(
      'notifies breakpoint changes',
      (tester) async {
        var expectedBreakPoint = Breakpoint.xlarge;
        tester.setXLargeDisplaySize();
        var tested = false;
        await tester.pumpApp(
          Builder(
            builder: (BuildContext context) {
              expect(BreakpointProvider.of(context), expectedBreakPoint);
              tested = true;

              return Container();
            },
          ),
        );
        expectedBreakPoint = Breakpoint.xsmall;
        tester.setXSmallDisplaySize();
        await tester.pumpAndSettle();

        final dynamic exception = tester.takeException();
        expect(exception, isNull);
        expect(tested, isTrue);
      },
    );
  });
}
