import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_puzzle_hack/src/l10n/l10n.dart';
import 'package:flutter_puzzle_hack/src/layout/breakpoint_provider.dart';
import 'package:flutter_puzzle_hack/src/layout/responsive_layout_builder.dart';
import 'package:flutter_puzzle_hack/src/models/connection.dart';
import 'package:flutter_puzzle_hack/src/models/dimension.dart';
import 'package:flutter_puzzle_hack/src/models/puzzle.dart';
import 'package:flutter_puzzle_hack/src/models/ticker.dart';
import 'package:flutter_puzzle_hack/src/models/tile.dart';
import 'package:flutter_puzzle_hack/src/puzzle/audio_controller/audio_controller.dart';
import 'package:flutter_puzzle_hack/src/puzzle/helpers/puzzle_generator.dart';
import 'package:flutter_puzzle_hack/src/puzzle/widgets/puzzle_board.dart';
import 'package:flutter_puzzle_hack/src/puzzle/widgets/puzzle_move_counter.dart';
import 'package:flutter_puzzle_hack/src/puzzle/widgets/puzzle_timer.dart';
import 'package:flutter_puzzle_hack/src/puzzle/widgets/puzzle_victory_dialog.dart';
import 'package:flutter_puzzle_hack/src/theme/app_theme.dart';
import 'package:universal_platform/universal_platform.dart';

class PuzzlePage extends StatefulWidget {
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  PuzzlePageState createState() => PuzzlePageState();
}

class PuzzlePageState extends State<PuzzlePage> {
  late Puzzle puzzle;
  Set<String> remainingFillings = <String>{};
  Set<String> filledTiles = <String>{};
  late Ticker ticker;
  StreamSubscription<int>? tickerSubscription;
  int secondsElapsed = 0;
  int moveCount = 0;
  bool started = false;
  bool solved = false;
  bool isAudibleTile = true;
  bool isAudibleMusic = true;
  late AudioController _audioController;

  @override
  void initState() {
    super.initState();
    ticker = const Ticker();
    puzzle = _generatePuzzle();
    _audioController = AudioController(themeFolder: 'assets/themes/base');
    _audioController.load();

    if (!UniversalPlatform.isWeb) {
      unawaited(_audioController.playMusic());
    }
  }

  @override
  void dispose() {
    tickerSubscription?.cancel();
    _audioController.dispose();
    super.dispose();
  }

  Puzzle _generatePuzzle() {
    var generations = 0;
    Puzzle puzzle;
    do {
      puzzle = PuzzleGenerator.generatePuzzle(
        dimension: const Dimension(width: 4, height: 4),
        themeFolder: 'assets/themes/base',
      );
      generations++;
    } while (puzzle.isSolved() && generations < 50);

    return puzzle;
  }

  void _startPuzzle() {
    if (UniversalPlatform.isWeb) {
      unawaited(_audioController.playMusic());
    }
    setState(() {
      puzzle = _generatePuzzle();
      filledTiles = <String>{};
      remainingFillings = <String>{};
      moveCount = 0;
      secondsElapsed = 0;
      started = true;
      solved = false;
    });
    _startTimer();
  }

  void _startTimer() {
    tickerSubscription?.cancel();
    tickerSubscription = ticker.tick().listen(
          (newSecondsElapsed) => setState(() {
            secondsElapsed = newSecondsElapsed;
          }),
        );
  }

  void _pauseTimer() {
    tickerSubscription?.pause();
  }

  void _onStartButtonPress() {
    _startPuzzle();
  }

  void _onTilePress(Tile tile) {
    if (solved) return;
    final movements = puzzle.getTileMovements(tile);
    if (movements.isEmpty) return;
    unawaited(_audioController.playTileSound());
    // use first available move by default for now
    final newPuzzle = puzzle.moveTiles(tile, movements.first);
    final completed = newPuzzle.isSolved();

    setState(() {
      puzzle = newPuzzle;
      moveCount++;
      solved = completed;
    });

    if (completed) {
      _onCompletion();
    }
  }

  void _onCompletion() {
    _pauseTimer();
    final startTiles = puzzle.tiles.where((t) => t.type == TileType.start);
    final fillings = <String>{}..addAll(startTiles.map((e) => e.id));
    for (final tile in startTiles) {
      fillings.addAll(puzzle.getTileConnections(tile).map((e) => e.id));
    }
    remainingFillings = fillings;
    filledTiles = <String>{};
    for (final tile in startTiles) {
      _fillTile(
        tile,
        const Connection.fromLTRB(false, true, false, false),
      );
    }
  }

  void _fillTile(Tile tile, Connection filling) {
    // ignore already filled tiles
    if (filledTiles.contains(tile.id)) return;
    filledTiles.add(tile.id);

    final newPuzzle = Puzzle(dimension: puzzle.dimension, tiles: puzzle.tiles);
    final newTile = Tile(
      id: tile.id,
      position: tile.position,
      connection: tile.connection,
      type: tile.type,
      asset: tile.asset,
      filling: filling,
    );
    newPuzzle.setTile(tile.position, newTile);
    setState(() => puzzle = newPuzzle);
  }

  void _onTileFillAnimationComplete(Tile tile) {
    remainingFillings.remove(tile.id);
    if (remainingFillings.isEmpty) {
      Timer(const Duration(milliseconds: 400), _displayVictoryDialog);

      return;
    }

    final neighbors = puzzle.getTileNeighbors(tile);
    for (final n in neighbors) {
      // ignore already filled tiles
      if (filledTiles.contains(n.id)) continue;

      if (tile.position.x > n.position.x) {
        // left, fill from right
        if (tile.connection.left && n.connection.right) {
          _fillTile(n, const Connection.fromLTRB(false, false, true, false));
        }
      } else if (tile.position.x < n.position.x) {
        // right, fill from left
        if (tile.connection.right && n.connection.left) {
          _fillTile(n, const Connection.fromLTRB(true, false, false, false));
        }
      } else if (tile.position.y > n.position.y) {
        // top, fill from bottom
        if (tile.connection.top && n.connection.bottom) {
          _fillTile(n, const Connection.fromLTRB(false, false, false, true));
        }
      } else if (tile.position.y < n.position.y) {
        // bottom, fill from top
        if (tile.connection.bottom && n.connection.top) {
          _fillTile(n, const Connection.fromLTRB(false, true, false, false));
        }
      }
    }
  }

  void _displayVictoryDialog() {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (_, __, ___) => PuzzleVictoryDialog(
        moveCount: moveCount,
        timeElapsed: Duration(seconds: secondsElapsed),
        onActionButtonPress: _startPuzzle,
      ),
    );
  }

  void onToggleTile() {
    setState(() {
      isAudibleTile = _audioController.toggleTileSound();
    });
  }

  void onToggleMusic() {
    setState(() {
      isAudibleMusic = _audioController.toggleMusic();
    });
  }

  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  iconSize: 50,
                  onPressed: onToggleMusic,
                  icon: isAudibleMusic
                      ? Image.asset(
                          'assets/images/buttons/button_music_on.png',
                        )
                      : Image.asset(
                          'assets/images/buttons/button_music_off.png',
                        ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  iconSize: 50,
                  onPressed: onToggleTile,
                  icon: isAudibleTile
                      ? Image.asset(
                          'assets/images/buttons/button_sound_on.png',
                        )
                      : Image.asset(
                          'assets/images/buttons/button_sound_off.png',
                        ),
                ),
                const SizedBox(width: 16),
              ],
            ),
            Expanded(
              child: ResponsiveLayoutBuilder(
                child: (breakpoint) => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 450),
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeIn,
                  child: Flex(
                    key: ValueKey<bool>(started),
                    direction: breakpoint.index >= Breakpoint.medium.index
                        ? Axis.horizontal
                        : Axis.vertical,
                    mainAxisAlignment: started
                        ? MainAxisAlignment.spaceEvenly
                        : MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: started &&
                                breakpoint.index >= Breakpoint.medium.index
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (breakpoint.index >= Breakpoint.medium.index ||
                              !started)
                            Column(
                              children: [
                                Image.asset(
                                  'assets/images/glouglou.png',
                                  width: 350,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  l10n.puzzlePageTitle,
                                  style:
                                      breakpoint.index > Breakpoint.small.index
                                          ? extraTheme(context).title
                                          : extraTheme(context).titleSmall,
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          Text(
                            // l10n.appSubTitle,
                            l10n.puzzlePageSubTitle,
                            style: breakpoint.index >= Breakpoint.medium.index
                                ? Theme.of(context).textTheme.headline4
                                : Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(fontSize: 18),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: 200,
                            height: 50,
                            child: GestureDetector(
                              onTapDown: (_) => setState(
                                () => _isTapped = true,
                              ),
                              onTapUp: (_) => setState(
                                () => _isTapped = false,
                              ),
                              onTap: _onStartButtonPress,
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Image.asset(
                                    _isTapped
                                        ? 'assets/images/buttons/button_hover.png'
                                        : 'assets/images/buttons/button.png',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (started)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                PuzzleTimer(
                                  timeElapsed:
                                      Duration(seconds: secondsElapsed),
                                ),
                                SizedBox(
                                  width:
                                      breakpoint.index > Breakpoint.small.index
                                          ? 48
                                          : 32,
                                ),
                                PuzzleMoveCounter(moveCount: moveCount),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            PuzzleBoard(
                              puzzleDimension: puzzle.dimension,
                              tiles: puzzle.tiles,
                              canInteract: started && !solved,
                              onTilePress: _onTilePress,
                              onTileFillAnimationComplete:
                                  _onTileFillAnimationComplete,
                            ),
                          ],
                        )
                      else
                        const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
            Image.asset(
              'assets/images/logos.png',
              height: 30,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
