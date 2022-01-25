import 'package:flutter/material.dart';
import 'package:flutter_puzzle_hack/src/models/puzzle.dart';

class PuzzleGrid extends StatelessWidget {
  const PuzzleGrid({
    Key? key,
    required this.puzzle,
  }) : super(key: key);

  final Puzzle puzzle;

  @override
  Widget build(BuildContext context) {
    final isScreenShort = MediaQuery.of(context).size.width <= 1000;

    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Image.asset(
                  'assets/images/logo_flutter_white.png',
                  height: 40,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(Icons.music_off),
              ),
            ],
          ),
          Expanded(
            child: Flex(
              direction: isScreenShort ? Axis.vertical : Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Puzzle Challenge',
                        style: TextStyle(
                          fontSize: 46,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        '0 Moves - 15 Tiles',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            enableFeedback: true,
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18)),
                              ),
                            ),
                          ),
                          onPressed: null,
                          child: const Text(
                            'Start Game',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: isScreenShort ? 450 : 600,
                  height: isScreenShort ? 450 : 600,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: puzzle.dimension.height,
                    ),
                    itemCount: puzzle.tiles.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Text(puzzle.tiles[index].position.toString());
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
