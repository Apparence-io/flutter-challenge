import 'package:equatable/equatable.dart';

class Connection extends Equatable {
  // ignore: avoid_positional_boolean_parameters
  const Connection.fromLTRB(this.left, this.top, this.right, this.bottom);

  // ignore: avoid_positional_boolean_parameters
  const Connection.all(bool value)
      : left = value,
        top = value,
        right = value,
        bottom = value;

  const Connection.horizontal()
      : left = true,
        top = false,
        right = true,
        bottom = false;

  const Connection.vertical()
      : left = false,
        top = true,
        right = false,
        bottom = true;

  final bool left;
  final bool top;
  final bool right;
  final bool bottom;

  @override
  List<Object?> get props => [left, top, right, bottom];
}
