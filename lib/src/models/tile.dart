import 'package:equatable/equatable.dart';
import 'package:flutter_puzzle_hack/src/models/connection.dart';
import 'package:flutter_puzzle_hack/src/models/position.dart';

class Tile extends Equatable {
  const Tile(
    this.position, {
    this.connection = const Connection.all(false),
    this.isLocked = false,
    this.isEmpty = false,
  });

  const Tile.empty(this.position, {this.isLocked = false})
      : connection = const Connection.all(false),
        isEmpty = true;

  final Position position;
  final Connection connection;
  final bool isLocked;
  final bool isEmpty;

  Tile copyWith({required Position position}) {
    return Tile(
      position,
      connection: connection,
      isLocked: isLocked,
      isEmpty: isEmpty,
    );
  }

  @override
  List<Object?> get props => [position, connection, isLocked, isEmpty];
}
