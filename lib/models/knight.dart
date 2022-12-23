import '../precomputed_mode_data.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';
import 'move.dart';
import 'piece.dart';

class Knight extends Piece {
  Knight(int x, int y, PieceColor color, int value) : super(x, y, color, value);

  @override
  Set<Move> generateMoves(List<List<Piece?>> board) {
    Set<Move> moves = {};

    // Get the precomputed knight moves for this square.
    List<int> knightMoves = PrecomputedMoveData.knightMoves[x * 8 + y];

    // Iterate through the precomputed moves.
    for (int move in knightMoves) {
      int newX = move ~/ 8;
      int newY = move % 8;

      // Check if the destination square is within the board boundaries and is either empty or contains an opponent's piece.
      if (newX >= 0 && newX < 8 && newY >= 0 && newY < 8 && (board[newX][newY] == null || board[newX][newY]!.color != color)) {
        moves.add(Move(
          row: x,
          column: y,
          newRow: newX,
          newColumn: newY,
          fromSquare: squareName(x, y),
          toSquare: squareName(newX, newY),
        ));
      }
    }

    return moves;
  }

  @override
  Knight copy() {
    return Knight(x, y, color, value);
  }

  @override
  String getSymbol() {
    return color == white ? 'N' : 'n';
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
