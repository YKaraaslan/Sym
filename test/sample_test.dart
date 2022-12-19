import 'package:sym/board.dart';
import 'package:sym/models/move.dart';
import 'package:sym/move_generator.dart';
import 'package:sym/utils/constants.dart';
import 'package:test/test.dart';

void main() {
  ChessBoard board = ChessBoard();
  MoveGenerator moveGenerator = MoveGenerator();

  group('board', () {
    test('is filled', () {
      var isBoardEmpty = true;
      for (var i in board.board) {
        for (var j in i) {
          if (j != null) {
            isBoardEmpty = false;
          }
        }
      }
      expect(isBoardEmpty, true);

      String fen = '8/8/8/8/8/3P4/8/8 w - - 0 1';

      board.loadPositionFromFen(fen);

      isBoardEmpty = true;
      for (var i in board.board) {
        for (var j in i) {
          if (j != null) {
            isBoardEmpty = false;
          }
        }
      }

      expect(isBoardEmpty, false);
    });
  });

  group('pawns', () {
    test('generate moves for pawn', () {
      // Generate the moves for the pawn
      Set<Move> moves = moveGenerator.generateMoves(board.board, activeColor);

      // Verify that the correct moves are generated
      expect(moves.length, 1);
    });
    test('generate capture moves for pawn', () {
      String fen = '8/8/8/8/4p3/3P4/8/8 w - - 0 1';
      board.loadPositionFromFen(fen);

      // Generate the moves for the pawn
      Set<Move> moves = moveGenerator.generateMoves(board.board, activeColor);

      // Verify that the correct moves are generated
      expect(moves.length, 2);
    });
    test('en passant move for pawn', () {
      String fen = '8/8/8/2pPp3/8/8/8/8 w - - 0 1';
      board = ChessBoard();
      board.loadPositionFromFen(fen);
      board.board[4][4]?.enPassant = true;

      // Generate the moves for the pawn
      Set<Move> moves = moveGenerator.generateMoves(board.board, activeColor);

      // Verify that the correct moves are generated
      expect(board.board[4][4], isNotNull);
      expect(board.board[4][2], isNotNull);
      expect(moves.length, 2);
    });
  });

  group('starting posiion', () {
    board = ChessBoard();
    test('check if the board is filled', () {
      board.loadPositionFromFen(startingPosition);
      Set<Move> moves = moveGenerator.generateMoves(board.board, activeColor);

      expect(moves, isNotEmpty);
    });
  });

  group('piece moves', () {
    test('rook move', () {
      board = ChessBoard();
      board.loadPositionFromFen('8/8/3n4/8/3R4/4p3/3P4/8 w - - 0 1');
      Set<Move> moves = moveGenerator.generateMoves(board.board, activeColor);

      expect(moves.length, 12);
    });

    test('bishop move', () {
      board = ChessBoard();
      board.loadPositionFromFen('8/8/3n4/4B3/8/8/1P6/8 w - - 0 1');
      Set<Move> moves = moveGenerator.generateMoves(board.board, activeColor);

      for (var element in moves) {
        print(element.toUciString());
      }

      expect(moves.length, 11);
    });

    test('queen move', () {
      board = ChessBoard();
      board.loadPositionFromFen('8/8/3n4/4Q3/8/8/1P6/8 w - - 0 1');
      Set<Move> moves = moveGenerator.generateMoves(board.board, activeColor);

      for (var element in moves) {
        print(element.toUciString());
      }

      expect(moves.length, 25);
    });

    test('knight move', () {
      board = ChessBoard();
      board.loadPositionFromFen('8/8/8/4N3/1r6/3N4/1P6/8 w - - 0 1');
      Set<Move> moves = moveGenerator.generateMoves(board.board, activeColor);

      for (var element in moves) {
        print(element.toUciString());
      }

      expect(moves.length, 14);
    });

    test('king move', () {
      board = ChessBoard();
      board.loadPositionFromFen('8/8/2n5/8/1r6/2K5/1P6/8 w - - 0 1');
      Set<Move> moves = moveGenerator.generateMoves(board.board, activeColor);

      for (var element in moves) {
        print(element.toUciString());
      }

      expect(moves.length, 4);
    });
  });
}
