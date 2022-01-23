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
  });

  const Tile.empty({required this.id, required this.position})
      : connection = const Connection.all(false),
        type = TileType.empty;

  final String id;
  final Position position;
  final Connection connection;
  final TileType type;

  Tile copyWith({required Position position}) {
    return Tile(
      id: id,
      position: position,
      connection: connection,
      type: type,
    );
  }

  @override
  List<Object?> get props => [id, position, connection, type];
}

/// Tile types.
enum TileType {
  /// Default tile type which can be moved
  normal,

  /// Empty tile can be swapped with a normal tile
  empty,

  /// Start tile define an objective which must be connected to a finish tile
  start,

  /// Finish tile define an objective which must be connected to a start tile
  finish,

  /// Locked tile cannot be moved
  locked,
}
