import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/src/layout/breakpoint_provider.dart';
import 'package:flutter_puzzle_hack/src/layout/responsive_layout_builder.dart';
import 'package:flutter_puzzle_hack/src/models/dimension.dart';
import 'package:flutter_puzzle_hack/src/models/tile.dart';
import 'package:flutter_puzzle_hack/src/puzzle/widgets/puzzle_tile.dart';
import 'package:flutter_puzzle_hack/src/puzzle/widgets/scale_up_animation.dart';

final _breakpointDimensions = <Breakpoint, double>{
  Breakpoint.xsmall: 360,
  Breakpoint.small: 400,
  Breakpoint.medium: 450,
  Breakpoint.large: 550,
  Breakpoint.xlarge: 690,
};

class PuzzleBoard extends StatelessWidget {
  const PuzzleBoard({
    Key? key,
    required this.puzzleDimension,
    required this.tiles,
    required this.canInteract,
    this.onTileHover,
    this.onTilePress,
    this.onTileFillAnimationComplete,
  }) : super(key: key);

  final Dimension puzzleDimension;
  final List<Tile> tiles;
  final bool canInteract;

  final Function(Tile tile, bool hovering)? onTileHover;
  final Function(Tile tile)? onTilePress;
  final Function(Tile tile)? onTileFillAnimationComplete;

  @override
  Widget build(BuildContext context) {
    if (puzzleDimension.width == 0 || puzzleDimension.height == 0) {
      return const CircularProgressIndicator();
    }

    return ScaleUpAnimation(
      delayMilliseconds: 200,
      child: ResponsiveLayoutBuilder(
        child: (breakpoint) => Card(
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: SizedBox(
              key: Key('puzzle_board_${breakpoint.name}'),
              width: _breakpointDimensions[breakpoint],
              height: puzzleDimension.height /
                  puzzleDimension.width.toDouble() *
                  _breakpointDimensions[breakpoint]!,
              child: Stack(
                children: tiles
                    .map(
                      (t) => PuzzleTile(
                        key: Key('puzzle_tile_${t.id}'),
                        tile: t,
                        puzzleDimension: puzzleDimension,
                        canInteract: canInteract,
                        onTileHover: onTileHover,
                        onTilePress: onTilePress,
                        onTileFillAnimationComplete:
                            onTileFillAnimationComplete,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
