import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/src/layout/breakpoint_provider.dart';

typedef ResponsiveLayoutWidgetBuilder = Widget Function(BuildContext, Widget?);

Map<Breakpoint, ResponsiveLayoutWidgetBuilder?> _createBuilders({
  ResponsiveLayoutWidgetBuilder? xsmall,
  ResponsiveLayoutWidgetBuilder? small,
  ResponsiveLayoutWidgetBuilder? medium,
  ResponsiveLayoutWidgetBuilder? large,
  ResponsiveLayoutWidgetBuilder? xlarge,
}) {
  final map = <Breakpoint, ResponsiveLayoutWidgetBuilder?>{};
  ResponsiveLayoutWidgetBuilder? last;
  map[Breakpoint.xsmall] = last = xsmall ?? last;
  map[Breakpoint.small] = last = small ?? last;
  map[Breakpoint.medium] = last = medium ?? last;
  map[Breakpoint.large] = last = large ?? last;
  map[Breakpoint.xlarge] = last = xlarge ?? last;

  return map;
}

/// {@template ResponsiveLayoutBuilder}
/// A wrapper around [LayoutBuilder] which exposes optionnal builders for
/// various responsive breakpoints.
///
/// If no builder is provided for given breakpoint, a smaller breakpoint builder
/// will be used.
///
/// If no breakpoint builder is found, the child widget builder will be used.
/// {@endtemplate}
class ResponsiveLayoutBuilder extends StatelessWidget {
  ResponsiveLayoutBuilder({
    Key? key,
    ResponsiveLayoutWidgetBuilder? xsmall,
    ResponsiveLayoutWidgetBuilder? small,
    ResponsiveLayoutWidgetBuilder? medium,
    ResponsiveLayoutWidgetBuilder? large,
    ResponsiveLayoutWidgetBuilder? xlarge,
    this.child,
  })  : builders = _createBuilders(
          xsmall: xsmall,
          small: small,
          medium: medium,
          large: large,
          xlarge: xlarge,
        ),
        super(key: key);

  final Map<Breakpoint, ResponsiveLayoutWidgetBuilder?> builders;

  /// Optional child widget builder based on the current layout size
  /// which will be passed to the `xsmall`, `small`, `medium`, `large` and
  /// `xlarge` builders as a way to share/optimize shared layout.
  final Widget Function(Breakpoint breakpoint)? child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final breakpoint = BreakpointProvider.of(context);

        final builder = builders[breakpoint];

        return builder?.call(context, child?.call(breakpoint)) ??
            child!.call(breakpoint);
      },
    );
  }
}
