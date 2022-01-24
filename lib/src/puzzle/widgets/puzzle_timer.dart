import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/src/l10n/l10n.dart';
import 'package:flutter_puzzle_hack/src/layout/breakpoint_provider.dart';
import 'package:flutter_puzzle_hack/src/layout/responsive_layout_builder.dart';

final _iconDimensions = <Breakpoint, double>{
  Breakpoint.xsmall: 24,
  Breakpoint.small: 28,
  Breakpoint.medium: 32,
  Breakpoint.large: 34,
  Breakpoint.xlarge: 36,
};

class PuzzleTimer extends StatelessWidget {
  const PuzzleTimer({
    Key? key,
    required this.timeElapsed,
    this.textStyle,
    this.iconSize,
    this.iconPadding,
    this.mainAxisAlignment,
  }) : super(key: key);

  final Duration timeElapsed;
  final TextStyle? textStyle;
  final Size? iconSize;
  final double? iconPadding;
  final MainAxisAlignment? mainAxisAlignment;

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitsMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitsSeconds = twoDigits(duration.inSeconds.remainder(60));

    return '${twoDigits(duration.inHours)}:$twoDigitsMinutes:$twoDigitsSeconds';
  }

  String _getDurationLabel(BuildContext context, Duration duration) {
    return context.l10n.puzzleDurationLabelText(
      duration.inHours.toString(),
      duration.inMinutes.remainder(60).toString(),
      duration.inSeconds.remainder(60).toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      // ignore: prefer-extracting-callbacks
      child: (breakpoint) {
        final theme = Theme.of(context);
        final currentTextStyle = textStyle ??
            ((breakpoint.index <= Breakpoint.small.index)
                ? theme.textTheme.headline4
                : theme.textTheme.headline3);

        final currentIconSize = iconSize ??
            Size(_iconDimensions[breakpoint]!, _iconDimensions[breakpoint]!);

        return Row(
          mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
          children: [
            AnimatedDefaultTextStyle(
              style: currentTextStyle!,
              duration: const Duration(milliseconds: 500),
              child: Text(
                _formatDuration(timeElapsed),
                key: ValueKey(timeElapsed.inSeconds),
                semanticsLabel: _getDurationLabel(context, timeElapsed),
              ),
            ),
            SizedBox(width: iconPadding ?? 8),
            Image.asset(
              'assets/images/timer_icon.png',
              width: currentIconSize.width,
              height: currentIconSize.height,
            ),
          ],
        );
      },
    );
  }
}
