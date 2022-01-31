import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_puzzle_hack/src/layout/responsive_layout_builder.dart';
import 'package:flutter_puzzle_hack/src/models/connection.dart';
import 'package:flutter_puzzle_hack/src/models/dimension.dart';
import 'package:flutter_puzzle_hack/src/models/tile.dart';
import 'package:rive/rive.dart';

class PuzzleTile extends StatefulWidget {
  const PuzzleTile({
    Key? key,
    required this.tile,
    required this.puzzleDimension,
    this.canInteract = true,
    this.onTileHover,
    this.onTilePress,
    this.onTileFillAnimationComplete,
  }) : super(key: key);

  final Tile tile;
  final Dimension puzzleDimension;
  final bool canInteract;
  final Function(Tile tile, bool hovering)? onTileHover;
  final Function(Tile tile)? onTilePress;
  final Function(Tile tile)? onTileFillAnimationComplete;

  @override
  PuzzleTileState createState() => PuzzleTileState();
}

class PuzzleTileState extends State<PuzzleTile>
    with SingleTickerProviderStateMixin {
  final kScaleDuration = const Duration(milliseconds: 300);

  late AnimationController _controller;
  late Animation<double> _scale;

  Artboard? _riveArtboard;
  SMIInput<double>? _fillAnimationDirectionInput;

  bool get isMoveable => widget.tile.type == TileType.normal;

  void onTileHover({required bool hovering}) {
    hovering && widget.canInteract
        ? _controller.forward()
        : _controller.reverse();
    if (widget.canInteract) widget.onTileHover?.call(widget.tile, hovering);
  }

  void onTilePress() {
    if (widget.canInteract) widget.onTilePress?.call(widget.tile);
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

    _loadAnimation();
  }

  @override
  void didUpdateWidget(PuzzleTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tile.asset != widget.tile.asset) {
      _loadAnimation();
    }
    if (oldWidget.tile.filling != widget.tile.filling) {
      if (widget.tile.filling == null ||
          widget.tile.filling == const Connection.all(false)) {
        _loadAnimation();
      } else {
        _startFillAnimation(widget.tile.filling!);
      }
    }
  }

  Future<void> _loadAnimation() async {
    setState(() {
      _riveArtboard = null;
    });
    if (widget.tile.asset?.endsWith('.riv') != true) return;
    // load animation
    final data = await rootBundle.load(widget.tile.asset!);
    final file = RiveFile.import(data);
    final artboard = file.mainArtboard;
    // init state machine controller
    final controller = StateMachineController.fromArtboard(
      artboard,
      'Filling',
      onStateChange: (_, state) => _onRiveStateChange(state),
    );
    if (controller != null) {
      artboard.addController(controller);
      _fillAnimationDirectionInput = controller.findInput<double>('Direction');
      _fillAnimationDirectionInput?.value = 0;
    }
    setState(() {
      _riveArtboard = artboard;
    });
  }

  void _startFillAnimation(Connection filling) {
    var direction = 0.0;
    if (filling.left) {
      direction = 2;
    } else if (filling.top) {
      direction = 1;
    } else if (filling.right) {
      direction = 4;
    } else if (filling.bottom) {
      direction = 3;
    }
    _fillAnimationDirectionInput?.value = direction;
  }

  void _onRiveStateChange(String state) {
    if (state == 'ExitState' || state == 'End') {
      widget.onTileFillAnimationComplete?.call(widget.tile);
    }
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
            onEnter: widget.canInteract && isMoveable
                ? (_) => onTileHover(hovering: true)
                : null,
            onExit: widget.canInteract && isMoveable
                ? (_) => onTileHover(hovering: false)
                : null,
            child: ScaleTransition(
              scale: _scale,
              child: IconButton(
                padding: EdgeInsets.zero,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onPressed:
                    widget.canInteract && isMoveable ? onTilePress : null,
                icon: _riveArtboard != null
                    ? Rive(
                        artboard: _riveArtboard!,
                        fit: BoxFit.contain,
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
