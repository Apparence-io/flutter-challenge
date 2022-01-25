import 'package:equatable/equatable.dart';
import 'package:flutter_puzzle_hack/src/models/connection.dart';
import 'package:flutter_puzzle_hack/src/models/position.dart';

/// {@template tile}
/// Puzzle tile model.
/// {@endtemplate}
class Tile extends Equatable {
  const Tile({
    required this.id,
    required this.position,
    this.connection = const Connection.all(false),
    this.type = TileType.normal,
    this.asset,
  });

  const Tile.empty({required this.id, required this.position})
      : connection = const Connection.all(false),
        type = TileType.empty,
        asset = null;

  final String id;
  final Position position;
  final Connection connection;
  final TileType type;
  final String? asset;

  Tile copyWith({required Position position}) {
    return Tile(
      id: id,
      position: position,
      connection: connection,
      type: type,
      asset: asset,
    );
  }

  @override
  List<Object?> get props => [id, position, connection, type, asset];
}

/// Tile types.
enum TileType {
  /// Default tile type which can be moved
  normal,

  /// Empty tile can be swapped with a normal tile
  empty,

  /// Start tile define an objective which must be connected to a end tile
  start,

  /// End tile define an objective which must be connected to a start tile
  end,

  /// Locked tile cannot be moved
  locked,
}
