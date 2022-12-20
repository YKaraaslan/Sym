import 'package:sym/board.dart';
import 'package:sym/square_checker.dart';
import 'package:sym/utils/constants.dart';
import 'package:test/test.dart';

void main() {
  group('square attack', () {
    test('rook', () {
      ChessBoard().loadPositionFromFen('8/8/8/2R2n2/8/8/8/8 w - - 0 1');
      int number = 0;
      for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
          if (SquareChecker().isSquareAttacked(board, i, j, activeColor)) {
            number++;
          }
        }
      }

      expect(number, 12);
    });

    test('knight', () {
      ChessBoard().loadPositionFromFen('8/8/8/2N5/8/8/5N2/8 w - - 0 1');
      int number = 0;
      for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
          if (SquareChecker().isSquareAttacked(board, i, j, activeColor)) {
            number++;
          }
        }
      }

      expect(number, 12);
    });

    test('bishop ', () {
      ChessBoard().loadPositionFromFen('8/8/8/4B3/2B5/8/8/8 w - - 0 1');
      int number = 0;
      for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
          if (SquareChecker().isSquareAttacked(board, i, j, activeColor)) {
            number++;
          }
        }
      }

      expect(number, 24);
    });

    test('pawn', () {
      ChessBoard().loadPositionFromFen('8/8/8/8/8/3P4/8/8 w - - 0 1');
      int number = 0;
      for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
          if (SquareChecker().isSquareAttacked(board, i, j, activeColor)) {
            number++;
          }
        }
      }

      expect(number, 2);
    });

    test('king', () {
      ChessBoard().loadPositionFromFen('8/8/8/8/8/3K4/8/8 w - - 0 1');
      int number = 0;
      for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
          if (SquareChecker().isSquareAttacked(board, i, j, activeColor)) {
            number++;
          }
        }
      }

      expect(number, 8);
    });

    test('queen', () {
      ChessBoard().loadPositionFromFen('8/8/8/3Q4/8/8/8/8 w - - 0 1');
      int number = 0;
      for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
          if (SquareChecker().isSquareAttacked(board, i, j, activeColor)) {
            print('$i$j');
            number++;
          }
        }
      }

      expect(number, 27);
    });
  });
}
