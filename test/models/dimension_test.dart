import 'package:flutter_puzzle_hack/src/models/dimension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Dimension', () {
    const width = 3;
    const height = 4;

    test('supports comparison', () {
      expect(
        const Dimension(
          width: width,
          height: height,
        ),
        const Dimension(
          width: width,
          height: height,
        ),
      );
      expect(
        const Dimension(
          width: width,
          height: height,
        ).props,
        const Dimension(
          width: width,
          height: height,
        ).props,
      );
    });
  });
}
