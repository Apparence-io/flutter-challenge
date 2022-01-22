import 'package:flutter_puzzle_hack/src/models/connection.dart';
import 'package:flutter_puzzle_hack/src/models/position.dart';
import 'package:flutter_puzzle_hack/src/models/tile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const basePosition = Position(1, 1);
  const newPosition = Position(2, 1);
  const connection = Connection.all(true);
  const type = TileType.start;

  group('Tile', () {
    test('supports comparison', () {
      expect(
        const Tile(
          basePosition,
          connection: connection,
          type: type,
        ),
        const Tile(
          basePosition,
          connection: connection,
          type: type,
        ),
      );

      expect(
        const Tile(
          basePosition,
          connection: connection,
          type: type,
        ).props,
        const Tile(
          basePosition,
          connection: connection,
          type: type,
        ).props,
      );
    });

    group('copyWith', () {
      test('returns a tile object with updated position', () {
        expect(
          const Tile(
            basePosition,
            connection: connection,
            type: type,
          ).copyWith(position: newPosition),
          const Tile(
            newPosition,
            connection: connection,
            type: type,
          ),
        );
      });
    });

    group('empty', () {
      test('returns an empty tile object with no connection', () {
        expect(
          const Tile.empty(
            basePosition,
          ),
          const Tile(
            basePosition,
            // ignore: avoid_redundant_argument_values
            connection: Connection.all(false),
            type: TileType.empty,
          ),
        );
      });
    });
  });
}
