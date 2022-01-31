import 'dart:math';

import 'package:flutter_puzzle_hack/src/models/connection.dart';
import 'package:flutter_puzzle_hack/src/models/dimension.dart';
import 'package:flutter_puzzle_hack/src/models/position.dart';
import 'package:flutter_puzzle_hack/src/models/puzzle.dart';
import 'package:flutter_puzzle_hack/src/models/tile.dart';

abstract class PuzzleGenerator {
  static final _tileTemplates = <
      String,
      Tile Function(
    String id,
    Position position,
    String themeFolder,
  )>{
    'start': (id, position, themeFolder) => Tile(
          id: id,
          position: position,
          connection: const Connection.all(true),
          type: TileType.start,
          asset: '$themeFolder/tile_start.riv',
        ),
    'end': (id, position, themeFolder) => Tile(
          id: id,
          position: position,
          connection: const Connection.fromLTRB(false, true, false, false),
          type: TileType.end,
          asset: '$themeFolder/tile_end.riv',
        ),
    'empty': (id, position, themeFolder) => Tile.empty(
          id: id,
          position: position,
        ),
    'cross': (id, position, themeFolder) => Tile(
          id: id,
          position: position,
          connection: const Connection.all(true),
          asset: '$themeFolder/tile_cross.riv',
        ),
    'horizontal': (id, position, themeFolder) => Tile(
          id: id,
          position: position,
          connection: const Connection.horizontal(),
          asset: '$themeFolder/tile_horizontal.riv',
        ),
    'vertical': (id, position, themeFolder) => Tile(
          id: id,
          position: position,
          connection: const Connection.vertical(),
          asset: '$themeFolder/tile_vertical.riv',
        ),
    'leftTop': (id, position, themeFolder) => Tile(
          id: id,
          position: position,
          connection: const Connection.leftTop(),
          asset: '$themeFolder/tile_left_top.riv',
        ),
    'topRight': (id, position, themeFolder) => Tile(
          id: id,
          position: position,
          connection: const Connection.topRight(),
          asset: '$themeFolder/tile_top_right.riv',
        ),
    'leftBottom': (id, position, themeFolder) => Tile(
          id: id,
          position: position,
          connection: const Connection.leftBottom(),
          asset: '$themeFolder/tile_left_bottom.riv',
        ),
    'rightBottom': (id, position, themeFolder) => Tile(
          id: id,
          position: position,
          connection: const Connection.rightBottom(),
          asset: '$themeFolder/tile_right_bottom.riv',
        ),
  };

  static Tile _generateTile(
    String template,
    Position position,
    Dimension dimension,
    String themeFolder,
  ) {
    final id = '${position.x + (position.y - 1) * dimension.width}';

    return _tileTemplates[template]!.call(id, position, themeFolder);
  }

  // ignore: long-method
  static Puzzle generatePuzzle({
    required Dimension dimension,
    required String themeFolder,
  }) {
    final rand = Random();
    final positions = <Position>[];

    final tiles = <Tile>[];
    final positionPicks = <int>{};

    // fill positions
    for (var y = 1; y <= dimension.height; y++) {
      for (var x = 1; x <= dimension.width; x++) {
        positions.add(Position(x, y));
        positionPicks.add(x - 1 + (y - 1) * dimension.width);
      }
    }

    // add start on first row except second and before last column
    var index = rand.nextInt(dimension.width - 2);
    if (index == 1) index = dimension.width - 1;
    tiles.add(
      _generateTile('start', positions[index], dimension, themeFolder),
    );
    positionPicks.remove(index);

    // add end on last row except second and before last column
    index = rand.nextInt(dimension.width - 2);
    if (index == 1) index = dimension.width - 1;
    index += (dimension.height - 1) * dimension.width;
    tiles.add(
      _generateTile('end', positions[index], dimension, themeFolder),
    );
    positionPicks.remove(index);

    // add empty
    index = positionPicks.elementAt(rand.nextInt(positionPicks.length));
    tiles.add(
      _generateTile('empty', positions[index], dimension, themeFolder),
    );
    positionPicks.remove(index);

    // fill templates
    final templates = [
      'cross',
      'horizontal',
      'vertical',
      'leftTop',
      'topRight',
      'leftBottom',
      'rightBottom',
    ];
    final templatePicks = <String>[];

    // add remaining tiles
    for (final index in positionPicks) {
      // refill
      if (templatePicks.isEmpty) {
        templatePicks.addAll(templates);
      }
      final templateIndex = rand.nextInt(templatePicks.length);
      tiles.add(
        _generateTile(
          templatePicks[templateIndex],
          positions[index],
          dimension,
          themeFolder,
        ),
      );
      templatePicks.removeAt(templateIndex);
    }

    return Puzzle(dimension: dimension, tiles: tiles).sort();
  }
}
