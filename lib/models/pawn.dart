import '../precomputed_mode_data.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';
import 'move.dart';
import 'piece.dart';

class Pawn extends Piece {
  Pawn(int x, int y, PieceColor color, int value) : super(x, y, color, value);

  @override
  Set<Move> generateMoves(List<List<Piece?>> board) {
    Set<Move> moves = {};

    // Determine the direction in which the pawn should move based on its color.

    // Get the precomputed pawn moves for this square.
    List<int> pawnMoves = PrecomputedMoveData.pawnMoves[color.index][x * 8 + y];

    // Iterate through the precomputed moves.
    for (int move in pawnMoves) {
      int newX = move ~/ 8;
      int newY = move % 8;

      // Check if the destination square is within the board boundaries and is either empty or contains an opponent's piece.
      if (newX >= 0 && newX < 8 && newY >= 0 && newY < 8 && (board[newX][newY] == null || board[newX][newY]!.color != color)) {
        moves.add(Move(
          row: x,
          column: y,
          newRow: newX,
          newColumn: newY,
          isEnPassant: (newX - x).abs() == 2,
          fromSquare: squareName(x, y),
          toSquare: squareName(newX, newY),
        ));
      }
    }

    return moves;
  }

  @override
  Pawn copy() {
    return Pawn(x, y, color, value);
  }

  @override
  String getSymbol() {
    return color == white ? 'P' : 'p';
  }

  @override
  Set<String> getControl(List<List<Piece?>> board) {
    Set<String> control = {};
    Set<Move> moves = generateMoves(board);
    for (Move move in moves) {
      control.add(move.toSquare);
    }
    return control;
  }
}
