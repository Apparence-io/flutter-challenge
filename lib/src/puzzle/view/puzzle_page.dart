import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_puzzle_hack/src/l10n/l10n.dart';
import 'package:flutter_puzzle_hack/src/models/dimension.dart';
import 'package:flutter_puzzle_hack/src/models/puzzle.dart';
import 'package:flutter_puzzle_hack/src/models/ticker.dart';
import 'package:flutter_puzzle_hack/src/models/tile.dart';
import 'package:flutter_puzzle_hack/src/puzzle/helpers/puzzle_generator.dart';
import 'package:flutter_puzzle_hack/src/puzzle/widgets/puzzle_board.dart';
import 'package:flutter_puzzle_hack/src/puzzle/widgets/puzzle_move_counter.dart';
import 'package:flutter_puzzle_hack/src/puzzle/widgets/puzzle_timer.dart';
import 'package:flutter_puzzle_hack/src/theme/app_theme.dart';

class PuzzlePage extends StatefulWidget {
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  PuzzlePageState createState() => PuzzlePageState();
}

class PuzzlePageState extends State<PuzzlePage> {
  late Puzzle puzzle;
  late Ticker ticker;
  late StreamSubscription<int>? tickerSubscription;
  int secondsElapsed = 0;
  int moveCount = 0;
  bool solved = false;

  @override
  void initState() {
    super.initState();
    var generations = 0;
    do {
      puzzle = PuzzleGenerator.generatePuzzle(
        dimension: const Dimension(width: 4, height: 4),
        themeFolder: 'themes/base',
      );
      generations++;
    } while (puzzle.isSolved() && generations < 50);

    ticker = const Ticker();
    tickerSubscription = ticker.tick().listen(
          (newSecondsElapsed) => setState(() {
            secondsElapsed = newSecondsElapsed;
          }),
        );
  }

  @override
  void dispose() {
    tickerSubscription?.cancel();
    super.dispose();
  }

  void onTilePress(Tile tile) {
    if (solved) return;
    final movements = puzzle.getTileMovements(tile);
    if (movements.isEmpty) return;
    // use first available move by default for now
    final newPuzzle = puzzle.moveTiles(tile, movements.first);
    final completed = newPuzzle.isSolved();
    setState(() {
      puzzle = newPuzzle;
      moveCount++;
      solved = completed;
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PuzzleTimer(
              timeElapsed: Duration(seconds: secondsElapsed),
            ),
            const SizedBox(height: 32),
            PuzzleMoveCounter(moveCount: moveCount),
            const SizedBox(height: 32),
            PuzzleBoard(
              puzzleDimension: puzzle.dimension,
              tiles: puzzle.tiles,
              canInteract: !solved,
              onTilePress: onTilePress,
            ),
          ],
        ),
      ),
    );
  }
}
