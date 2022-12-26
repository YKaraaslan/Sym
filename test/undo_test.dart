import 'package:sym/board.dart';
import 'package:sym/models/move.dart';
import 'package:sym/models/piece.dart';
import 'package:sym/move_generator.dart';
import 'package:sym/utils/constants.dart';
import 'package:sym/utils/enums.dart';
import 'package:test/test.dart';

void main() {
  List<List<Piece?>> board = List.generate(8, (_) => List.generate(8, (index) => null));

  int moveGenerationTest(PieceColor color, int depth) {
    if (depth == 0) {
      return 1;
    }

    Set<Move> moves = MoveGenerator().generateMoves(board, color);
    int numberOfPositions = 0;

    for (Move move in moves) {
      ChessBoard().makeMove(board, move);
      numberOfPositions += moveGenerationTest(color == white ? black : white, depth - 1);
      ChessBoard().undoMove(board, moveHistory.removeLast());
    }

    return numberOfPositions;
  }

  test('undo', () {
    int fullDepth = 1;
    board = ChessBoard().loadPositionFromFen('8/5p2/8/8/8/8/8/4K2R w - - 0 1');
    ChessBoard().makeMove(board, Move.fromUciString('e1g1'));
    ChessBoard().makeMove(board, Move.fromUciString('f7f5'));
    moveGenerationTest(activeColor, fullDepth);
  });
}
