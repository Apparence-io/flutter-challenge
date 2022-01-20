import 'package:flutter_puzzle_hack/src/models/connection.dart';
import 'package:flutter_puzzle_hack/src/models/position.dart';
import 'package:flutter_puzzle_hack/src/models/tile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const basePosition = Position(0, 0);
  const newPosition = Position(1, 1);
  const connection = Connection.all(true);
  const isLocked = true;
  const isEmpty = true;

  group('Tile', () {
    test('supports comparison', () {
      expect(
        const Tile(
          basePosition,
          connection: connection,
          isLocked: isLocked,
          isEmpty: isEmpty,
        ),
        const Tile(
          basePosition,
          connection: connection,
          isLocked: isLocked,
          isEmpty: isEmpty,
        ),
      );
    });

    group('copyWith', () {
      test('returns a tile object with updated position', () {
        expect(
          const Tile(
            basePosition,
            connection: connection,
            isLocked: isLocked,
            isEmpty: isEmpty,
          ).copyWith(position: newPosition),
          const Tile(
            newPosition,
            connection: connection,
            isLocked: isLocked,
            isEmpty: isEmpty,
          ),
        );
      });
    });

    group('empty', () {
      test('returns an empty tile object', () {
        expect(
          const Tile.empty(
            basePosition,
            isLocked: isLocked,
          ),
          const Tile(
            basePosition,
            isLocked: isLocked,
            isEmpty: true,
          ),
        );
      });
    });
  });
}
