import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/src/l10n/l10n.dart';
import 'package:flutter_puzzle_hack/src/models/connection.dart';
import 'package:flutter_puzzle_hack/src/models/dimension.dart';
import 'package:flutter_puzzle_hack/src/models/position.dart';
import 'package:flutter_puzzle_hack/src/models/puzzle.dart';
import 'package:flutter_puzzle_hack/src/models/tile.dart';
import 'package:flutter_puzzle_hack/src/puzzle/widgets/puzzle_board.dart';
import 'package:flutter_puzzle_hack/src/theme/app_theme.dart';

class PuzzlePage extends StatefulWidget {
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  PuzzlePageState createState() => PuzzlePageState();
}

class PuzzlePageState extends State<PuzzlePage> {
  late Puzzle puzzle;

  @override
  void initState() {
    super.initState();
    puzzle = generateRandomPuzzle();
  }

  Puzzle generateRandomPuzzle() {
    const dimension = Dimension(width: 4, height: 4);
    final tiles = <Tile>[];

    for (var y = 1; y <= dimension.height; y++) {
      for (var x = 1; x <= dimension.width; x++) {
        if (x == dimension.width && y == dimension.height) {
          tiles.add(
            Tile.empty(
              id: '${x + (y - 1) * dimension.width}',
              position: Position(x, y),
            ),
          );
        } else {
          tiles.add(
            Tile(
              id: '${x + (y - 1) * dimension.width}',
              position: Position(x, y),
              connection: const Connection.all(true),
            ),
          );
        }
      }
    }

    return Puzzle(dimension: dimension, tiles: tiles);
  }

  void onTilePress(Tile tile) {
    final movements = puzzle.getTileMovements(tile);
    if (movements.isEmpty) return;
    // use first available move by default for now
    setState(() {
      puzzle = puzzle.moveTiles(tile, movements.first);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () =>
                Navigator.restorablePushNamed(context, '/settings'),
          ),
        ],
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration:
            BoxDecoration(color: extraTheme(context).puzzleBackgroundColor),
        child: Center(
          child: PuzzleBoard(
            puzzleDimension: puzzle.dimension,
            tiles: puzzle.tiles,
            onTilePress: onTilePress,
          ),
        ),
      ),
    );
  }
}