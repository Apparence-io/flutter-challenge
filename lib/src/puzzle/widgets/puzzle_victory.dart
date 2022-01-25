import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/src/puzzle/widgets/puzzle_move_counter.dart';
import 'package:flutter_puzzle_hack/src/puzzle/widgets/puzzle_timer.dart';

class PuzzleVictory extends StatefulWidget {
  const PuzzleVictory({
    Key? key,
    required this.movesNumber,
    required this.timeElapsed,
    this.title = '',
    this.description = '',
    this.leftButtonText = '',
    this.rightButtonText = '',
    this.onRightButtonPress,
    this.onLeftButtonPress,
  }) : super(key: key);

  final int movesNumber;
  final int timeElapsed;
  final String title;
  final String description;
  final String rightButtonText;
  final String leftButtonText;

  final Function()? onRightButtonPress;
  final Function()? onLeftButtonPress;

  @override
  State<PuzzleVictory> createState() => _PuzzleVictoryState();
}

class _PuzzleVictoryState extends State<PuzzleVictory> {
  late ConfettiController _controllerConfetti;

  @override
  void initState() {
    _controllerConfetti = ConfettiController(
      duration: const Duration(milliseconds: 2500),
    );
    _controllerConfetti.play();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ConfettiWidget(
            emissionFrequency: 0.04,
            confettiController: _controllerConfetti,
            blastDirectionality: BlastDirectionality
                .explosive, // don't specify a direction, blast randomly
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
            ], // manually specify the colors to
          ),
          Text(widget.description),
          const SizedBox(
            height: 32,
          ),
          SizedBox(
            width: 150,
            height: 50,
            child: Center(
              child: PuzzleTimer(
                timeElapsed: Duration(seconds: widget.timeElapsed),
              ),
            ),
          ),
          SizedBox(
            width: 150,
            height: 50,
            child: Center(
              child: PuzzleMoveCounter(
                moveCount: widget.movesNumber,
              ),
            ),
          ),
        ],
      ),
      actions: [
        SizedBox(
          height: 45,
          child: ElevatedButton(
            onPressed: widget.onLeftButtonPress,
            child: Text(widget.leftButtonText),
          ),
        ),
        SizedBox(
          height: 45,
          child: ElevatedButton(
            onPressed: widget.onRightButtonPress,
            child: Text(widget.rightButtonText),
          ),
        ),
      ],
    );
  }
}
