import 'package:sym/board.dart';
import 'package:sym/models/piece.dart';
import 'package:sym/move_generator.dart';
import 'package:sym/square_checker.dart';
import 'package:sym/utils/constants.dart';
import 'package:test/test.dart';

void main() {
  List<List<Piece?>> board = List.generate(8, (_) => List.generate(8, (index) => null));

  group('square attack', () {
    test('rook', () {
      board = ChessBoard().loadPositionFromFen('8/8/8/2R2n2/8/8/8/8 w - - 0 1');
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
      board = ChessBoard().loadPositionFromFen('8/8/8/2N5/8/8/5N2/8 w - - 0 1');
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
      board = ChessBoard().loadPositionFromFen('8/8/8/4B3/2B5/8/8/8 w - - 0 1');
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
      board = ChessBoard().loadPositionFromFen('8/2p5/K2p4/8/8/8/8/8 w - - 1 8');
      int number = 0;
      for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
          if (SquareChecker().isSquareAttacked(board, i, j, black)) {
            number++;
          }
        }
      }

      expect(number, 4);
    });

    test('king', () {
      board = ChessBoard().loadPositionFromFen('8/8/8/8/8/3K4/8/8 w - - 0 1');
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
      board = ChessBoard().loadPositionFromFen('8/8/8/3Q4/8/8/8/8 w - - 0 1');
      int number = 0;
      for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
          if (SquareChecker().isSquareAttacked(board, i, j, activeColor)) {
            number++;
          }
        }
      }

      expect(number, 27);
    });

    test('king pawn', () {
      board = ChessBoard().loadPositionFromFen('8/2p5/K2p4/8/8/8/8/8 w - - 1 8');
      var moves = MoveGenerator().generateMoves(board, activeColor);
      expect(moves.length, 4);
    });

    test('castle', () {
      board = ChessBoard().loadPositionFromFen('8/8/8/8/8/8/8/R3K2R w KQ - 0 1');
      var moves = MoveGenerator().generateMoves(board, activeColor);
      for (var element in moves) {
        if (element.toUciString().startsWith('e1')) {
          print(element.toUciString());
        }
      }
    });

    test('rook capture', () {
      board = ChessBoard().loadPositionFromFen('8/2p5/3p4/KP5r/1R3p1k/6P1/4P3/8 b - - 0 8');
      var res = SquareChecker().isSquareAttacked(board, 3, 6, white);
      print(res);
    });
  });
}
