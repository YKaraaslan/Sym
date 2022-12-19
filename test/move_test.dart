import 'package:sym/board.dart';
import 'package:sym/move_generator.dart';
import 'package:sym/utils/constants.dart';
import 'package:test/test.dart';

void main() {
  ChessBoard chessBoard = ChessBoard();
  MoveGenerator moveGenerator = MoveGenerator();

  group('pawn for black', () {
    test('move', () {
      chessBoard = ChessBoard();
      chessBoard.loadPositionFromFen(startingPosition);
      var moves = moveGenerator.generateMoves(chessBoard.board, activeColor);
      expect(moves.length, 20);
    });
  });
}
