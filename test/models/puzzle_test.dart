import 'package:flutter_puzzle_hack/src/models/connection.dart';
import 'package:flutter_puzzle_hack/src/models/dimension.dart';
import 'package:flutter_puzzle_hack/src/models/position.dart';
import 'package:flutter_puzzle_hack/src/models/puzzle.dart';
import 'package:flutter_puzzle_hack/src/models/tile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const base4x4Tile1 = Tile(
    Position(1, 1),
    connection: Connection.all(true),
    type: TileType.start,
  );
  const base4x4Tile2 = Tile(
    Position(2, 1),
    connection: Connection.vertical(),
  );
  const base4x4Tile3 = Tile(
    Position(3, 1),
    connection: Connection.horizontal(),
  );
  const base4x4Tile4 = Tile(
    Position(4, 1),
    connection: Connection.all(true),
    type: TileType.finish,
  );
  const base4x4Tile5 = Tile(
    Position(1, 2),
    connection: Connection.topRight(),
  );
  const base4x4Tile6 = Tile(
    Position(2, 2),
    connection: Connection.fromLTRB(true, false, true, true),
  );
  const base4x4Tile7 = Tile(
    Position(3, 2),
    connection: Connection.horizontal(),
    type: TileType.locked,
  );
  const base4x4Tile8 = Tile.empty(Position(4, 2));
  const base4x4Tile9 = Tile(
    Position(1, 3),
    connection: Connection.leftBottom(),
  );
  const base4x4Tile10 = Tile(
    Position(2, 3),
    connection: Connection.vertical(),
  );
  const base4x4Tile11 = Tile(
    Position(3, 3),
    connection: Connection.rightBottom(),
  );
  const base4x4Tile12 = Tile(
    Position(4, 3),
    connection: Connection.leftTop(),
  );
  const base4x4Tile13 = Tile(
    Position(1, 4),
    connection: Connection.vertical(),
  );
  const base4x4Tile14 = Tile(
    Position(2, 4),
    connection: Connection.horizontal(),
  );
  const base4x4Tile15 = Tile(
    Position(3, 4),
    connection: Connection.topRight(),
  );
  const base4x4Tile16 = Tile(
    Position(4, 4),
    connection: Connection.all(true),
  );

  const base4x4Puzzle = Puzzle(
    dimension: Dimension(height: 4, width: 4),
    tiles: [
      base4x4Tile1,
      base4x4Tile2,
      base4x4Tile3,
      base4x4Tile4,
      base4x4Tile5,
      base4x4Tile6,
      base4x4Tile7,
      base4x4Tile8,
      base4x4Tile9,
      base4x4Tile10,
      base4x4Tile11,
      base4x4Tile12,
      base4x4Tile13,
      base4x4Tile14,
      base4x4Tile15,
      base4x4Tile16,
    ],
  );

  group('Puzzle', () {
    group('dimension', () {
      test('returns 2 when given a dimension of 2', () {
        const puzzle =
            Puzzle(dimension: Dimension(height: 2, width: 2), tiles: []);
        expect(puzzle.dimension.height, 2);
        expect(puzzle.dimension.width, 2);
      });

      test('returns 4 when given a dimension of 4', () {
        const puzzle =
            Puzzle(dimension: Dimension(height: 4, width: 4), tiles: []);
        expect(puzzle.dimension.height, 4);
        expect(puzzle.dimension.width, 4);
      });
    });

    group('getTile', () {
      test('returns expected tile', () {
        expect(
          base4x4Puzzle.getTile(const Position(1, 1)),
          base4x4Tile1,
        );

        expect(
          base4x4Puzzle.getTile(const Position(2, 1)),
          base4x4Tile2,
        );

        expect(
          base4x4Puzzle.getTile(const Position(4, 1)),
          base4x4Tile4,
        );

        expect(
          base4x4Puzzle.getTile(const Position(1, 2)),
          base4x4Tile5,
        );

        expect(
          base4x4Puzzle.getTile(const Position(4, 4)),
          base4x4Tile16,
        );
      });
    });

    group('getTileNeighbors', () {
      test('returns expected tile neighbors in ltrb order', () {
        expect(base4x4Puzzle.getTileNeighbors(base4x4Tile1), [
          base4x4Tile2, // right
          base4x4Tile5, // bottom
        ]);

        expect(base4x4Puzzle.getTileNeighbors(base4x4Tile4), [
          base4x4Tile3, // left
          base4x4Tile8, // bottom
        ]);

        expect(base4x4Puzzle.getTileNeighbors(base4x4Tile6), [
          base4x4Tile5, // left
          base4x4Tile2, // top
          base4x4Tile7, // right
          base4x4Tile10, // bottom
        ]);

        expect(base4x4Puzzle.getTileNeighbors(base4x4Tile13), [
          base4x4Tile9, // top
          base4x4Tile14, // right
        ]);

        expect(base4x4Puzzle.getTileNeighbors(base4x4Tile16), [
          base4x4Tile15, // left
          base4x4Tile12, // top
        ]);
      });
    });

    group('isTileMoveable', () {
      test('returns false when the given tile is a start', () {
        expect(
          base4x4Puzzle.isTileMoveable(base4x4Tile1),
          isFalse,
        );
      });

      test('returns false when the given tile is a finish', () {
        expect(
          base4x4Puzzle.isTileMoveable(base4x4Tile4),
          isFalse,
        );
      });

      test('returns false when the given tile is empty', () {
        expect(
          base4x4Puzzle.isTileMoveable(base4x4Tile8),
          isFalse,
        );
      });

      test('returns false when the given tile is locked', () {
        expect(
          base4x4Puzzle.isTileMoveable(base4x4Tile7),
          isFalse,
        );
      });

      test(
        'returns false when tile is not adjacent to an empty tile',
        () {
          expect(
            base4x4Puzzle.isTileMoveable(base4x4Tile3),
            isFalse,
          );
        },
      );

      test(
        'returns true when tile is normal and adjacent to an '
        'empty tile',
        () {
          expect(
            base4x4Puzzle.isTileMoveable(base4x4Tile12),
            isTrue,
          );
        },
      );
    });

    group('areTilesConnected', () {
      test('returns false when given tiles with no compatible path', () {
        expect(
          base4x4Puzzle.areTilesConnected(
            base4x4Tile1,
            base4x4Tile2,
          ),
          isFalse,
        );
      });

      test('returns true when given tiles with a compatible path', () {
        expect(
          base4x4Puzzle.areTilesConnected(
            base4x4Tile1,
            base4x4Tile10,
          ),
          isTrue,
        );
      });
    });

    group('getTileConnections', () {
      test('returns tiles with a compatible path to a given tile', () {
        final connections = base4x4Puzzle.getTileConnections(base4x4Tile1)
          ..sort((tileA, tileB) {
            return tileA.position.compareTo(tileB.position);
          });

        final expectedConnections = [
          base4x4Tile5,
          base4x4Tile6,
          base4x4Tile7,
          base4x4Tile10,
        ];

        expect(connections, expectedConnections);

        expect(
          base4x4Puzzle.getTileConnections(base4x4Tile2),
          isEmpty,
        );
      });
    });

    group('getTilesConnections', () {
      test('returns expected tiles connections for every tile', () {
        final connections = base4x4Puzzle.getTilesConnections();

        // check first tile connections
        final tile1Index = base4x4Tile1.position.toString();
        final expectedConnections = [
          base4x4Tile5,
          base4x4Tile6,
          base4x4Tile7,
          base4x4Tile10,
        ].map((e) => e.position.toString());

        expect(connections[tile1Index]?.length, expectedConnections.length);
        expect(
          connections[tile1Index]!.containsAll(expectedConnections),
          isTrue,
        );

        // check inter connections
        for (final c in expectedConnections) {
          expect(
            connections[c]?.length,
            expectedConnections.length,
          );
        }

        // check second tile with no connections
        expect(connections[base4x4Tile2.position.toString()], isEmpty);
      });
    });

    group(
      'isSolved',
      () {
        test('returns false when given an unsolved puzzle', () {
          expect(base4x4Puzzle.isSolved(), isFalse);
        });
        test('returns true when given a solved puzzle', () {
          final solvedPuzzle = Puzzle(
            dimension: const Dimension(height: 3, width: 3),
            tiles: [
              base4x4Tile1,
              base4x4Tile2,
              base4x4Tile3,
              base4x4Tile4,
              base4x4Tile5,
              base4x4Tile6,
              base4x4Tile7,
              base4x4Tile8.copyWith(position: const Position(4, 3)),
              base4x4Tile9,
              base4x4Tile10,
              base4x4Tile11,
              base4x4Tile12.copyWith(position: const Position(4, 2)),
              base4x4Tile13,
              base4x4Tile14,
              base4x4Tile15,
              base4x4Tile16,
            ],
          ).sort();
          expect(solvedPuzzle.isSolved(), isTrue);
        });
      },
    );

    group('sort', () {
      test(
        'returns a puzzle object with sorted tiles',
        () {
          const unsortedPuzzle = Puzzle(
            dimension: Dimension(height: 4, width: 4),
            tiles: [
              base4x4Tile1,
              base4x4Tile2,
              base4x4Tile11,
              base4x4Tile4,
              base4x4Tile3,
              base4x4Tile5,
              base4x4Tile6,
              base4x4Tile7,
              base4x4Tile8,
              base4x4Tile9,
              base4x4Tile10,
              base4x4Tile12,
              base4x4Tile14,
              base4x4Tile13,
              base4x4Tile15,
              base4x4Tile16,
            ],
          );
          expect(
            unsortedPuzzle.sort(),
            base4x4Puzzle,
          );
        },
      );
    });
  });
}
