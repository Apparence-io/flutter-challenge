import 'package:flutter_puzzle_hack/src/models/dimension.dart';
import 'package:flutter_puzzle_hack/src/models/position.dart';
import 'package:flutter_puzzle_hack/src/models/puzzle.dart';
import 'package:flutter_puzzle_hack/src/models/tile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const base3x3Tile1 = Tile(Position(0, 0), isEmpty: true);
  const base3x3Tile2 = Tile(Position(1, 0), isLocked: true);
  const base3x3Tile3 = Tile(Position(2, 0));
  const base3x3Tile4 = Tile(Position(0, 1));
  const base3x3Tile5 = Tile(Position(1, 1));
  const base3x3Tile6 = Tile(Position(2, 1));
  const base3x3Tile7 = Tile(Position(0, 2));
  const base3x3Tile8 = Tile(Position(1, 2));
  const base3x3Tile9 = Tile(Position(2, 2), isLocked: true, isEmpty: true);

  const base3x3Puzzle = Puzzle(
    dimension: Dimension(height: 3, width: 3),
    tiles: [
      base3x3Tile1,
      base3x3Tile2,
      base3x3Tile3,
      base3x3Tile4,
      base3x3Tile5,
      base3x3Tile6,
      base3x3Tile7,
      base3x3Tile8,
      base3x3Tile9,
    ],
  );

  group('Puzzle', () {
    group('dimension', () {
      test('returns 0 when given a dimension of 0', () {
        const puzzle =
            Puzzle(dimension: Dimension(height: 0, width: 0), tiles: []);
        expect(puzzle.dimension.height, 0);
        expect(puzzle.dimension.width, 0);
      });

      test('returns 1 when given a dimension of 1', () {
        const puzzle =
            Puzzle(dimension: Dimension(height: 1, width: 1), tiles: []);
        expect(puzzle.dimension.height, 1);
        expect(puzzle.dimension.width, 1);
      });

      test('returns 2 when given a dimension of 2', () {
        const puzzle =
            Puzzle(dimension: Dimension(height: 2, width: 2), tiles: []);
        expect(puzzle.dimension.height, 2);
        expect(puzzle.dimension.width, 2);
      });
    });

    group('getTile', () {
      test('returns expected tile', () {
        expect(
          base3x3Puzzle.getTile(const Position(0, 0)),
          base3x3Tile1,
        );

        expect(
          base3x3Puzzle.getTile(const Position(1, 0)),
          base3x3Tile2,
        );

        expect(
          base3x3Puzzle.getTile(const Position(2, 0)),
          base3x3Tile3,
        );

        expect(
          base3x3Puzzle.getTile(const Position(0, 1)),
          base3x3Tile4,
        );

        expect(
          base3x3Puzzle.getTile(const Position(2, 2)),
          base3x3Tile9,
        );
      });
    });

    group('getTileNeighbors', () {
      test('returns expected tile neighbors', () {
        expect(base3x3Puzzle.getTileNeighbors(base3x3Tile1), [
          base3x3Tile2, // right
          base3x3Tile4, // bottom
        ]);

        expect(base3x3Puzzle.getTileNeighbors(base3x3Tile3), [
          base3x3Tile2, // left
          base3x3Tile6, // bottom
        ]);

        expect(base3x3Puzzle.getTileNeighbors(base3x3Tile5), [
          base3x3Tile4, // left
          base3x3Tile2, // top
          base3x3Tile6, // right
          base3x3Tile8, // bottom
        ]);

        expect(base3x3Puzzle.getTileNeighbors(base3x3Tile7), [
          base3x3Tile4, // top
          base3x3Tile8, // right
        ]);

        expect(base3x3Puzzle.getTileNeighbors(base3x3Tile9), [
          base3x3Tile8, // left
          base3x3Tile6, // top
        ]);
      });
    });

    group('isTileMoveable', () {
      test('returns false when the given tile is empty', () {
        expect(
          base3x3Puzzle.isTileMoveable(base3x3Tile1),
          isFalse,
        );
      });

      test('returns false when the given tile is locked', () {
        expect(
          base3x3Puzzle.isTileMoveable(base3x3Tile2),
          isFalse,
        );
      });

      test(
        'returns false when tile is not adjacent to an empty tile',
        () {
          expect(
            base3x3Puzzle.isTileMoveable(base3x3Tile3),
            isFalse,
          );
        },
      );

      test(
        'returns false when tile is adjacent to an empty but locked tile',
        () {
          expect(
            base3x3Puzzle.isTileMoveable(base3x3Tile8),
            isFalse,
          );
        },
      );

      test(
        'returns true when tile is not empty, unlocked and adjacent to an '
        'empty and unlocked tile',
        () {
          expect(
            base3x3Puzzle.isTileMoveable(base3x3Tile4),
            isTrue,
          );
        },
      );
    });

    group('sort', () {
      test(
        'returns a puzzle object with sorted tiles',
        () {
          const unsortedPuzzle = Puzzle(
            dimension: Dimension(height: 3, width: 3),
            tiles: [
              base3x3Tile2,
              base3x3Tile1,
              base3x3Tile3,
              base3x3Tile4,
              base3x3Tile5,
              base3x3Tile6,
              base3x3Tile8,
              base3x3Tile9,
              base3x3Tile7,
            ],
          );
          expect(
            unsortedPuzzle.sort(),
            base3x3Puzzle,
          );
        },
      );
    });
  });
}
