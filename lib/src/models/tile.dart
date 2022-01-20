import 'package:equatable/equatable.dart';
import 'package:flutter_puzzle_hack/src/models/connection.dart';
import 'package:flutter_puzzle_hack/src/models/position.dart';

class Tile extends Equatable {
  const Tile(
    this.position, {
    this.connection = const Connection.all(false),
    this.type = TileType.normal,
  });

  const Tile.empty(this.position)
      : connection = const Connection.all(false),
        type = TileType.empty;

  final Position position;
  final Connection connection;
  final TileType type;

  Tile copyWith({required Position position}) {
    return Tile(
      position,
      connection: connection,
      type: type,
    );
  }

  @override
  List<Object?> get props => [position, connection, type];
}

enum TileType { normal, empty, start, finish, locked }
