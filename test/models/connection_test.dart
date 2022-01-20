import 'package:flutter_puzzle_hack/src/models/connection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Connection', () {
    test('supports comparison', () {
      expect(
        const Connection.all(true),
        const Connection.fromLTRB(true, true, true, true),
      );
    });

    group('fromLTRB', () {
      test(
        'returns a connection object with directions with given values',
        () {
          const connection = Connection.fromLTRB(true, false, false, true);
          expect(connection.left, isTrue);
          expect(connection.top, isFalse);
          expect(connection.right, isFalse);
          expect(connection.bottom, isTrue);
        },
      );
    });

    group('all', () {
      test(
        'returns a connection object with all direction with given value',
        () {
          expect(
            const Connection.all(true),
            const Connection.fromLTRB(true, true, true, true),
          );
          expect(
            const Connection.all(false),
            const Connection.fromLTRB(false, false, false, false),
          );
        },
      );
    });

    group('horizontal', () {
      test(
        'returns a connection object with left and right to true',
        () {
          expect(
            const Connection.horizontal(),
            const Connection.fromLTRB(true, false, true, false),
          );
        },
      );
    });

    group('vertical', () {
      test(
        'returns a connection object with top and bottom to true',
        () {
          expect(
            const Connection.vertical(),
            const Connection.fromLTRB(false, true, false, true),
          );
        },
      );
    });

    group('leftTop', () {
      test(
        'returns a connection object with left and top to true',
        () {
          expect(
            const Connection.leftTop(),
            const Connection.fromLTRB(true, true, false, false),
          );
        },
      );
    });

    group('topRight', () {
      test(
        'returns a connection object with top and right to true',
        () {
          expect(
            const Connection.topRight(),
            const Connection.fromLTRB(false, true, true, false),
          );
        },
      );
    });

    group('leftBottom', () {
      test(
        'returns a connection object with top and right to true',
        () {
          expect(
            const Connection.leftBottom(),
            const Connection.fromLTRB(true, false, false, true),
          );
        },
      );
    });

    group('rightBottom', () {
      test(
        'returns a connection object with top and right to true',
        () {
          expect(
            const Connection.rightBottom(),
            const Connection.fromLTRB(false, false, true, true),
          );
        },
      );
    });
  });
}
