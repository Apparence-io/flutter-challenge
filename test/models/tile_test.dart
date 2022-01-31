import 'package:flutter_puzzle_hack/src/models/connection.dart';
import 'package:flutter_puzzle_hack/src/models/position.dart';
import 'package:flutter_puzzle_hack/src/models/tile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const id = 'someId';
  const basePosition = Position(1, 1);
  const newPosition = Position(2, 1);
  const connection = Connection.all(true);
  const type = TileType.start;
  const asset = 'asset.png';
  const filling = Connection.all(false);

  group('Tile', () {
    test('supports comparison', () {
      expect(
        const Tile(
          id: id,
          position: basePosition,
          connection: connection,
          type: type,
          asset: asset,
          filling: filling,
        ),
        const Tile(
          id: id,
          position: basePosition,
          connection: connection,
          type: type,
          asset: asset,
          filling: filling,
        ),
      );

      expect(
        const Tile(
          id: id,
          position: basePosition,
          connection: connection,
          type: type,
          asset: asset,
          filling: filling,
        ).props,
        const Tile(
          id: id,
          position: basePosition,
          connection: connection,
          type: type,
          asset: asset,
          filling: filling,
        ).props,
      );
    });

    group('copyWith', () {
      test('returns a tile object with updated position', () {
        expect(
          const Tile(
            id: id,
            position: basePosition,
            connection: connection,
            type: type,
            asset: asset,
          ).copyWith(position: newPosition),
          const Tile(
            id: id,
            position: newPosition,
            connection: connection,
            type: type,
            asset: asset,
          ),
        );
      });
    });

    group('empty', () {
      test('returns an empty tile object with no connection', () {
        expect(
          const Tile.empty(
            id: id,
            position: basePosition,
          ),
          const Tile(
            id: id,
            position: basePosition,
            // ignore: avoid_redundant_argument_values
            connection: Connection.all(false),
            type: TileType.empty,
            // ignore: avoid_redundant_argument_values
            asset: null,
          ),
        );
      });
    });
  });
}
