import 'package:flutter/widgets.dart';
import 'package:flutter_puzzle_hack/src/layout/breakpoint_provider.dart';
import 'package:flutter_test/flutter_test.dart';

extension PuzzleWidgetTester on WidgetTester {
  void setDisplaySize(Size size) {
    binding.window.physicalSizeTestValue = size;
    binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      binding.window.clearPhysicalSizeTestValue();
      binding.window.clearDevicePixelRatioTestValue();
    });
  }

  void setXLargeDisplaySize() {
    setDisplaySize(const Size(BreakpointSize.xlarge, 1000));
  }

  void setLargeDisplaySize() {
    setDisplaySize(const Size(BreakpointSize.large, 1000));
  }

  void setMediumDisplaySize() {
    setDisplaySize(const Size(BreakpointSize.medium, 1000));
  }

  void setSmallDisplaySize() {
    setDisplaySize(const Size(BreakpointSize.small, 1000));
  }

  void setXSmallDisplaySize() {
    setDisplaySize(const Size(BreakpointSize.small - 1, 1000));
  }
}
