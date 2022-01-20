import 'package:flutter_puzzle_hack/src/models/position.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Position', () {
    const positionX = 1;
    const positionY = 2;

    test('supports comparison', () {
      expect(
        const Position(
          positionX,
          positionY,
        ),
        const Position(
          positionX,
          positionY,
        ),
      );
    });
  });
}
