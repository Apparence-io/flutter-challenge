import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_puzzle_hack/src/l10n/l10n.dart';
import 'package:flutter_puzzle_hack/src/layout/breakpoint_provider.dart';
import 'package:flutter_puzzle_hack/src/layout/responsive_layout_builder.dart';
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
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Image.asset(
                  'images/logo_flutter_white.png',
                  height: 40,
                ),
              ),
              Row(
                children: [
                  const IconButton(
                    // change audio sound on/off
                    onPressed: null,
                    icon: Icon(Icons.music_off),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () =>
                        Navigator.restorablePushNamed(context, '/settings'),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ],
          ),
          Expanded(
            child: ResponsiveLayoutBuilder(
              child: (breakpoint) => Flex(
                direction: breakpoint.index >= Breakpoint.medium.index
                    ? Axis.horizontal
                    : Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.appTitle,
                        style: breakpoint.index >= Breakpoint.medium.index
                            ? Theme.of(context).textTheme.headline1
                            : Theme.of(context)
                                .textTheme
                                .headline1!
                                .copyWith(fontSize: 25),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: null,
                          child: Text(
                            l10n.buttonStartText,
                            style: Theme.of(context).textTheme.button,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    decoration: BoxDecoration(
                      color: extraTheme(context).puzzleBackgroundColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PuzzleBoard(
                          puzzleDimension: puzzle.dimension,
                          tiles: puzzle.tiles,
                          canInteract: !solved,
                          onTilePress: onTilePress,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PuzzleTimer(
                              timeElapsed: Duration(seconds: secondsElapsed),
                            ),
                            const SizedBox(
                              width: 64,
                            ),
                            PuzzleMoveCounter(moveCount: moveCount),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
