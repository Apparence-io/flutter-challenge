import 'package:equatable/equatable.dart';

class Position extends Equatable implements Comparable<Position> {
  const Position(this.x, this.y);

  final int x;
  final int y;

  @override
  List<Object?> get props => [x, y];

  @override
  int compareTo(Position other) {
    if (y < other.y) {
      return -1;
    } else if (y > other.y) {
      return 1;
    }
    if (x < other.x) {
      return -1;
    } else if (x > other.x) {
      return 1;
    }

    return 0;
  }
}
