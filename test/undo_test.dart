import 'package:sym/board.dart';
import 'package:sym/models/move.dart';
import 'package:sym/move_generator.dart';
import 'package:sym/utils/constants.dart';
import 'package:sym/utils/enums.dart';
import 'package:test/test.dart';

int fullDepth = 1;

void main() {
  int moveGenerationTest(PieceColor color, int depth) {
    if (depth == 0) {
      return 1;
    }

    Set<Move> moves = MoveGenerator().generateMoves(board, color);
    int numberOfPositions = 0;

    for (Move move in moves) {
      chessBoard.makeMove(board, move);
      numberOfPositions += moveGenerationTest(color == white ? black : white, depth - 1);
      chessBoard.undoMove(board, moveHistory.removeLast());
    }

    return numberOfPositions;
  }

  test('undo', () {
    ChessBoard chessBoard = ChessBoard();
    chessBoard.loadPositionFromFen('8/8/8/8/8/8/8/R3K2R w KQ - 0 1');
    moveGenerationTest(activeColor, fullDepth);
  });
}
