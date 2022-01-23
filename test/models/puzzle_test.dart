import 'package:flutter_puzzle_hack/src/models/connection.dart';
import 'package:flutter_puzzle_hack/src/models/dimension.dart';
import 'package:flutter_puzzle_hack/src/models/position.dart';
import 'package:flutter_puzzle_hack/src/models/puzzle.dart';
import 'package:flutter_puzzle_hack/src/models/tile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const base4x4Tile1 = Tile(
    id: '1',
    position: Position(1, 1),
    connection: Connection.all(true),
    type: TileType.start,
  );
  const base4x4Tile2 = Tile(
    id: '2',
    position: Position(2, 1),
    connection: Connection.vertical(),
  );
  const base4x4Tile3 = Tile(
    id: '3',
    position: Position(3, 1),
    connection: Connection.horizontal(),
  );
  const base4x4Tile4 = Tile(
    id: '4',
    position: Position(4, 1),
    connection: Connection.all(true),
    type: TileType.finish,
  );
  const base4x4Tile5 = Tile(
    id: '5',
    position: Position(1, 2),
    connection: Connection.topRight(),
  );
  const base4x4Tile6 = Tile(
    id: '6',
    position: Position(2, 2),
    connection: Connection.fromLTRB(true, false, true, true),
  );
  const base4x4Tile7 = Tile(
    id: '7',
    position: Position(3, 2),
    connection: Connection.horizontal(),
    type: TileType.locked,
  );
  const base4x4Tile8 = Tile.empty(id: '8', position: Position(4, 2));
  const base4x4Tile9 = Tile(
    id: '9',
    position: Position(1, 3),
    connection: Connection.leftBottom(),
  );
  const base4x4Tile10 = Tile(
    id: '10',
    position: Position(2, 3),
    connection: Connection.vertical(),
  );
  const base4x4Tile11 = Tile(
    id: '11',
    position: Position(3, 3),
    connection: Connection.rightBottom(),
  );
  const base4x4Tile12 = Tile(
    id: '12',
    position: Position(4, 3),
    connection: Connection.leftTop(),
  );
  const base4x4Tile13 = Tile(
    id: '13',
    position: Position(1, 4),
    connection: Connection.vertical(),
  );
  const base4x4Tile14 = Tile(
    id: '14',
    position: Position(2, 4),
    connection: Connection.horizontal(),
  );
  const base4x4Tile15 = Tile(
    id: '15',
    position: Position(3, 4),
    connection: Connection.topRight(),
  );
  const base4x4Tile16 = Tile(
    id: '16',
    position: Position(4, 4),
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
      test('returns 2 neighbors in ltrb order for a given corner tile', () {
        expect(base4x4Puzzle.getTileNeighbors(base4x4Tile1), [
          base4x4Tile2, // right
          base4x4Tile5, // bottom
        ]);

        expect(base4x4Puzzle.getTileNeighbors(base4x4Tile4), [
          base4x4Tile3, // left
          base4x4Tile8, // bottom
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
      test('returns 3 neighbors in ltrb order for a given edge tile', () {
        expect(base4x4Puzzle.getTileNeighbors(base4x4Tile5), [
          base4x4Tile1, // top
          base4x4Tile6, // right
          base4x4Tile9, // bottom
        ]);
      });
      test('returns 4 neighbors in ltrb order for a given center tile', () {
        expect(base4x4Puzzle.getTileNeighbors(base4x4Tile6), [
          base4x4Tile5, // left
          base4x4Tile2, // top
          base4x4Tile7, // right
          base4x4Tile10, // bottom
        ]);
      });
    });

    group('getTileMovements', () {
      test('returns empty when the given tile is a start', () {
        expect(
          base4x4Puzzle.getTileMovements(base4x4Tile1),
          isEmpty,
        );
      });

      test('returns empty when the given tile is a finish', () {
        expect(
          base4x4Puzzle.getTileMovements(base4x4Tile4),
          isEmpty,
        );
      });

      test('returns empty when the given tile is empty', () {
        expect(
          base4x4Puzzle.getTileMovements(base4x4Tile8),
          isEmpty,
        );
      });

      test('returns empty when the given tile is locked', () {
        expect(
          base4x4Puzzle.getTileMovements(base4x4Tile7),
          isEmpty,
        );
      });

      test(
        'returns empty when tile is not adjacent to an empty tile',
        () {
          expect(
            base4x4Puzzle.getTileMovements(base4x4Tile3),
            isEmpty,
          );
        },
      );

      test(
        'returns expected tile when tile is normal and adjacent to '
        'an empty tile',
        () {
          expect(
            base4x4Puzzle.getTileMovements(base4x4Tile12),
            [base4x4Tile8],
          );
        },
      );
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
        final expectedConnections = [
          base4x4Tile5,
          base4x4Tile6,
          base4x4Tile7,
          base4x4Tile10,
        ];

        expect(
          connections[base4x4Tile1.id]?.length,
          expectedConnections.length,
        );
        expect(
          connections[base4x4Tile1.id],
          expectedConnections,
        );

        // check inter connections
        for (final c in expectedConnections) {
          expect(
            connections[c.id]?.length,
            expectedConnections.length,
          );
        }

        // check second tile with no connections
        expect(connections[base4x4Tile2.id], isEmpty);
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
            dimension: const Dimension(height: 4, width: 4),
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

    group('moveTiles', () {
      test(
        'swap position of a given normal tile and an adjacent empty tile',
        () {
          final mutablePuzzle = Puzzle(
            dimension: const Dimension(height: 4, width: 4),
            tiles: [...base4x4Puzzle.tiles],
          );

          final expectedPuzzle = Puzzle(
            dimension: const Dimension(height: 4, width: 4),
            tiles: [
              base4x4Tile1,
              base4x4Tile2,
              base4x4Tile3,
              base4x4Tile4,
              base4x4Tile5,
              base4x4Tile6,
              base4x4Tile7,
              base4x4Tile12.copyWith(position: base4x4Tile8.position),
              base4x4Tile9,
              base4x4Tile10,
              base4x4Tile11,
              base4x4Tile8.copyWith(position: base4x4Tile12.position),
              base4x4Tile13,
              base4x4Tile14,
              base4x4Tile15,
              base4x4Tile16,
            ],
          );

          expect(
            mutablePuzzle.moveTiles(base4x4Tile12, base4x4Tile8),
            expectedPuzzle,
          );
        },
      );
    });

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
