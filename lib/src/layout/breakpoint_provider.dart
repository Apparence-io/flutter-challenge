import 'package:flutter/material.dart';

Breakpoint _getBreakpoint(double screenWidth) {
  var breakpoint = Breakpoint.xsmall;
  if (screenWidth >= BreakpointSize.xlarge) {
    breakpoint = Breakpoint.xlarge;
  } else if (screenWidth >= BreakpointSize.large) {
    breakpoint = Breakpoint.large;
  } else if (screenWidth >= BreakpointSize.medium) {
    breakpoint = Breakpoint.medium;
  } else if (screenWidth >= BreakpointSize.small) {
    breakpoint = Breakpoint.small;
  }

  return breakpoint;
}

/// {@template BreakpointProvider}
/// A provider for various responsive breakpoints.
/// {@endtemplate}
class BreakpointProvider extends InheritedWidget {
  BreakpointProvider({
    Key? key,
    required this.screenWidth,
    required Widget child,
  })  : breakpoint = _getBreakpoint(screenWidth),
        super(key: key, child: child);

  final double screenWidth;
  final Breakpoint breakpoint;

  static Breakpoint of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<BreakpointProvider>()!
        .breakpoint;
  }

  @override
  bool updateShouldNotify(BreakpointProvider oldWidget) =>
      oldWidget.breakpoint != breakpoint;
}

abstract class BreakpointSize {
  static const double small = 600;
  static const double medium = 900;
  static const double large = 1200;
  static const double xlarge = 1536;
}

enum Breakpoint {
  xsmall,
  small,
  medium,
  large,
  xlarge,
}
