import 'package:equatable/equatable.dart';
import 'package:flutter_puzzle_hack/src/models/dimension.dart';
import 'package:flutter_puzzle_hack/src/models/position.dart';
import 'package:flutter_puzzle_hack/src/models/tile.dart';

class Puzzle extends Equatable {
  const Puzzle({required this.dimension, required this.tiles});

  final Dimension dimension;
  final List<Tile> tiles;

  @pragma('vm:prefer-inline')
  Tile getTile(Position position) {
    return tiles[_index(position.x, position.y)];
  }

  @pragma('vm:prefer-inline')
  int _index(int x, int y) => x + y * dimension.width;

  List<Tile> getTileNeighbors(Tile tile) {
    final pos = tile.position;
    final neighbors = <Tile>[];

    if (pos.x > 0) {
      // left
      neighbors.add(getTile(Position(pos.x - 1, pos.y)));
    }
    if (pos.y > 0) {
      // top
      neighbors.add(getTile(Position(pos.x, pos.y - 1)));
    }
    if (pos.x < dimension.width - 1) {
      // right
      neighbors.add(getTile(Position(pos.x + 1, pos.y)));
    }
    if (pos.y < dimension.height - 1) {
      // bottom
      neighbors.add(getTile(Position(pos.x, pos.y + 1)));
    }

    return neighbors;
  }

  bool isTileMoveable(Tile tile) {
    if (tile.isLocked || tile.isEmpty) return false;

    final neighbors = getTileNeighbors(tile);

    for (final t in neighbors) {
      if (t.isEmpty && !t.isLocked) {
        return true;
      }
    }

    return false;
  }

  Puzzle sort() {
    final sortedTiles = tiles.toList()
      ..sort((tileA, tileB) {
        return tileA.position.compareTo(tileB.position);
      });

    return Puzzle(dimension: dimension, tiles: sortedTiles);
  }

  @override
  List<Object?> get props => [tiles, dimension];
}
