import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import 'package:flutter_puzzle_hack/src/l10n/l10n.dart';
import 'package:flutter_puzzle_hack/src/layout/breakpoint_provider.dart';
import 'package:flutter_puzzle_hack/src/layout/responsive_layout_builder.dart';
import 'package:flutter_puzzle_hack/src/puzzle/widgets/puzzle_move_counter.dart';
import 'package:flutter_puzzle_hack/src/puzzle/widgets/puzzle_timer.dart';

class PuzzleVictoryDialog extends StatefulWidget {
  const PuzzleVictoryDialog({
    Key? key,
    required this.moveCount,
    required this.timeElapsed,
    this.title,
    this.description,
    this.closeButtonText,
    this.actionButtonText,
    this.onCloseButtonPress,
    this.onActionButtonPress,
  }) : super(key: key);

  final int moveCount;
  final Duration timeElapsed;
  final String? title;
  final String? description;
  final String? closeButtonText;
  final String? actionButtonText;

  final Function()? onCloseButtonPress;
  final Function()? onActionButtonPress;

  @override
  State<PuzzleVictoryDialog> createState() => _PuzzleVictoryDialogState();
}

class _PuzzleVictoryDialogState extends State<PuzzleVictoryDialog> {
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(
      duration: const Duration(milliseconds: 2500),
    );
    _controller.play();
  }

  void _onCloseButtonPress() {
    Navigator.maybePop(context);
    widget.onCloseButtonPress?.call();
  }

  void _onActionButtonPress() {
    Navigator.maybePop(context);
    widget.onActionButtonPress?.call();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return ResponsiveLayoutBuilder(
      child: (breakpoint) => SizedBox(
        width: breakpoint.index > Breakpoint.medium.index ? 700 : 500,
        child: Dialog(
          clipBehavior: Clip.hardEdge,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(
              breakpoint.index > Breakpoint.medium.index ? 40 : 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title ?? l10n.puzzleVictoryDialogTitle,
                  style: (breakpoint.index > Breakpoint.small.index)
                      ? theme.textTheme.headline2
                      : theme.textTheme.headline3,
                ),
                const SizedBox(
                  height: 32,
                ),
                Text(
                  widget.description ?? l10n.puzzleVictoryDialogDescription,
                  style: (breakpoint.index > Breakpoint.small.index)
                      ? theme.textTheme.headline3
                      : theme.textTheme.headline4,
                ),
                ConfettiWidget(
                  emissionFrequency: 0.04,
                  confettiController: _controller,
                  blastDirectionality: BlastDirectionality.explosive,
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple,
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                PuzzleTimer(
                  timeElapsed: widget.timeElapsed,
                ),
                const SizedBox(
                  height: 8,
                ),
                PuzzleMoveCounter(
                  moveCount: widget.moveCount,
                ),
                const SizedBox(
                  height: 32,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: _onCloseButtonPress,
                      child: Text(
                        widget.closeButtonText ?? l10n.buttonCloseLabel,
                      ),
                    ),
                    const SizedBox(
                      width: 32,
                    ),
                    ElevatedButton(
                      onPressed: _onActionButtonPress,
                      child: Text(
                        widget.actionButtonText ?? l10n.buttonRestartText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
