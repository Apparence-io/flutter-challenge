import 'dart:ui';

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
    return tiles[_index(position.x - 1, position.y - 1)];
  }

  @pragma('vm:prefer-inline')
  void setTile(Position position, Tile tile) {
    tiles[_index(position.x - 1, position.y - 1)] = tile;
  }

  @pragma('vm:prefer-inline')
  int _index(int x, int y) => x + y * dimension.width;

  List<Tile> getTileNeighbors(Tile tile) {
    final neighbors = [
      getRelativeTile(tile, const Offset(-1, 0)),
      getRelativeTile(tile, const Offset(0, -1)),
      getRelativeTile(tile, const Offset(1, 0)),
      getRelativeTile(tile, const Offset(0, 1)),
    ];

    return List<Tile>.from(neighbors.where((n) => n != null));
  }

  Tile? getRelativeTile(Tile tile, Offset offset) {
    final posX = tile.position.x + offset.dx.toInt();
    final posY = tile.position.y + offset.dy.toInt();

    if (posX < 1 || posX > dimension.width) return null;
    if (posY < 1 || posY > dimension.height) return null;

    return getTile(Position(posX, posY));
  }

  List<Tile> getTileMovements(Tile tile) {
    final movements = <Tile>[];
    if (tile.type != TileType.normal) return movements;
    final neighbors = getTileNeighbors(tile);

    for (final t in neighbors) {
      if (t.type == TileType.empty) {
        movements.add(t);
      }
    }

    return movements;
  }

  bool isTileMoveable(Tile tile) {
    return getTileMovements(tile).isNotEmpty;
  }

  bool areTilesConnected(
    Tile tileA,
    Tile tileB, {
    bool recursive = true,
    Set<String>? paths,
  }) {
    paths ??= <String>{};

    final neighbors = getTileNeighbors(tileA);
    final connectedTiles = <Tile>[];

    for (final n in neighbors) {
      if (paths.contains('${tileA.position}_${n.position}')) continue;

      paths
        ..add('${tileA.position}_${n.position}')
        ..add('${n.position}_${tileA.position}');

      if (tileA.position.x > n.position.x) {
        // left
        if (tileA.connection.left && n.connection.right) connectedTiles.add(n);
      } else if (tileA.position.x < n.position.x) {
        // right
        if (tileA.connection.right && n.connection.left) connectedTiles.add(n);
      } else if (tileA.position.y > n.position.y) {
        // top
        if (tileA.connection.top && n.connection.bottom) connectedTiles.add(n);
      } else if (tileA.position.y < n.position.y) {
        // bottom
        if (tileA.connection.bottom && n.connection.top) connectedTiles.add(n);
      }
    }

    if (connectedTiles.contains(tileB)) return true;

    if (recursive) {
      for (final c in connectedTiles) {
        final connected =
            areTilesConnected(c, tileB, recursive: recursive, paths: paths);
        if (connected) return true;
      }
    }

    return false;
  }

  List<Tile> getTileConnections(
    Tile tile, {
    bool recursive = true,
    Set<String>? paths,
    List<Tile>? connections,
  }) {
    paths ??= <String>{};
    connections ??= [];

    final neighbors = getTileNeighbors(tile);
    final connectedTiles = <Tile>[];

    for (final n in neighbors) {
      // ignore already checked tiles
      if (paths.contains('${tile.position}_${n.position}')) continue;

      // add to checked tiles
      paths
        ..add('${tile.position}_${n.position}')
        ..add('${n.position}_${tile.position}');

      if (tile.position.x > n.position.x) {
        // left connection
        if (tile.connection.left && n.connection.right) connectedTiles.add(n);
      } else if (tile.position.x < n.position.x) {
        // right connection
        if (tile.connection.right && n.connection.left) connectedTiles.add(n);
      } else if (tile.position.y > n.position.y) {
        // top connection
        if (tile.connection.top && n.connection.bottom) connectedTiles.add(n);
      } else if (tile.position.y < n.position.y) {
        // bottom connection
        if (tile.connection.bottom && n.connection.top) connectedTiles.add(n);
      }
    }

    connections.addAll(connectedTiles);

    // recursive search
    if (recursive) {
      for (final c in connectedTiles) {
        getTileConnections(
          c,
          recursive: recursive,
          paths: paths,
          connections: connections,
        );
      }
    }

    return connections;
  }

  Map<String, Set<String>> getTilesConnections() {
    final tilesConnections = <String, Set<String>>{};

    final paths = <String>{};

    // initialize sets
    for (final t in tiles) {
      tilesConnections[t.position.toString()] = <String>{};
    }

    for (final tile in tiles) {
      // get tile connections
      final p = tile.position.toString();
      final connections = getTileConnections(tile, paths: paths)
          .map((t) => t.position.toString());

      // fill tile connections
      tilesConnections[p]!.addAll(connections);

      for (final c in connections) {
        // set reverse index
        tilesConnections[c]!
          ..addAll(connections) // add connections
          ..remove(c) // remove it self
          ..add(p); // add original tile
      }
    }

    return tilesConnections;
  }

  bool isSolved() {
    final startTiles = tiles.where((t) => t.type == TileType.start);
    final finishTiles = tiles.where((t) => t.type == TileType.finish);
    final connections = getTilesConnections();

    // check that every start is connected to a finish
    for (final s in startTiles) {
      final conns = connections[s.position.toString()];
      if (!finishTiles.any((e) => conns!.contains(e.position.toString()))) {
        return false;
      }
    }

    // check that every finish is connected to a start
    for (final f in finishTiles) {
      final conns = connections[f.position.toString()];
      if (!startTiles.any((e) => conns!.contains(e.position.toString()))) {
        return false;
      }
    }

    return true;
  }

  Puzzle moveTiles(Tile tileA, Tile tileB) {
    setTile(tileB.position, tileA.copyWith(position: tileB.position));
    setTile(tileA.position, tileB.copyWith(position: tileA.position));

    return Puzzle(dimension: dimension, tiles: tiles);
  }

  Puzzle sort() {
    final sortedTiles = tiles.toList()
      ..sort((tileA, tileB) {
        return tileA.position.compareTo(tileB.position);
      });

    return Puzzle(dimension: dimension, tiles: sortedTiles);
  }

  @override
  List<Object?> get props => [dimension, tiles];
}
