import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/src/layout/breakpoint_provider.dart';
import 'package:flutter_puzzle_hack/src/layout/responsive_layout_builder.dart';
import 'package:flutter_puzzle_hack/src/models/dimension.dart';
import 'package:flutter_puzzle_hack/src/models/tile.dart';

class PuzzleTile extends StatefulWidget {
  const PuzzleTile({
    Key? key,
    required this.tile,
    required this.puzzleDimension,
    this.canInteract = true,
    this.onTileHover,
    this.onTilePress,
    required this.asset,
  }) : super(key: key);

  final Tile tile;
  final Dimension puzzleDimension;
  final bool canInteract;
  final Function(Tile tile, bool hovering)? onTileHover;
  final Function(Tile tile)? onTilePress;
  final String asset;

  @override
  PuzzleTileState createState() => PuzzleTileState();
}

class PuzzleTileState extends State<PuzzleTile>
    with SingleTickerProviderStateMixin {
  final kScaleDuration = const Duration(milliseconds: 300);

  late AnimationController _controller;
  late Animation<double> _scale;

  final breakpointDimensions = <Breakpoint, double>{
    Breakpoint.xsmall: 86,
    Breakpoint.small: 100,
    Breakpoint.medium: 120,
    Breakpoint.large: 144,
    Breakpoint.xlarge: 172,
  };

  void onTileHover({required bool hovering}) {
    widget.onTileHover?.call(widget.tile, hovering);
    hovering ? _controller.forward() : _controller.reverse();
  }

  void onTilePress() {
    widget.onTilePress?.call(widget.tile);
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: kScaleDuration,
    );

    _scale = Tween<double>(begin: 1, end: 0.9).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 1, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
      alignment: FractionalOffset(
        (widget.tile.position.x - 1) / (widget.puzzleDimension.width - 1),
        (widget.tile.position.y - 1) / (widget.puzzleDimension.height - 1),
      ),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: ResponsiveLayoutBuilder(
        child: (breakpoint) => FractionallySizedBox(
          key: Key('puzzle_tile_${breakpoint.name}_${widget.tile.id}'),
          widthFactor: 1 / widget.puzzleDimension.width,
          heightFactor: 1 / widget.puzzleDimension.height,
          child: MouseRegion(
            onEnter: (_) =>
                widget.canInteract ? onTileHover(hovering: true) : null,
            onExit: (_) =>
                widget.canInteract ? onTileHover(hovering: false) : null,
            child: ScaleTransition(
              scale: _scale,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () => widget.canInteract ? onTilePress() : null,
                icon: Image.asset(
                  widget.asset,
                  width: breakpointDimensions[breakpoint],
                  height: breakpointDimensions[breakpoint],
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}