import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/src/l10n/l10n.dart';
import 'package:flutter_puzzle_hack/src/layout/breakpoint_provider.dart';
import 'package:flutter_puzzle_hack/src/layout/responsive_layout_builder.dart';
import 'package:flutter_puzzle_hack/src/puzzle/widgets/scale_up_animation.dart';

class PuzzleMoveCounter extends StatelessWidget {
  const PuzzleMoveCounter({
    Key? key,
    required this.moveCount,
    this.textStyle,
  }) : super(key: key);

  final int moveCount;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ScaleUpAnimation(
      delayMilliseconds: 700,
      child: ResponsiveLayoutBuilder(
        // ignore: prefer-extracting-callbacks
        child: (breakpoint) {
          final theme = Theme.of(context);
          final currentTextStyle = textStyle ??
              ((breakpoint.index < Breakpoint.medium.index)
                  ? theme.textTheme.headline5
                  : theme.textTheme.headline4);

          return AnimatedDefaultTextStyle(
            style: currentTextStyle!,
            duration: const Duration(milliseconds: 500),
            child: Text(l10n.nMoves(moveCount)),
          );
        },
      ),
    );
  }
}
