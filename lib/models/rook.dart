import '../precomputed_mode_data.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';
import 'move.dart';
import 'piece.dart';

class Rook extends Piece {
  Rook(int x, int y, PieceColor color, int value) : super(x, y, color, value);

  @override
  Set<Move> generateMoves(List<List<Piece?>> board) {
    Set<Move> moves = {};

    // Get the precomputed rook moves for this square.
    List<int> rookMoves = PrecomputedMoveData.rookMoves[x * 8 + y];

    // Iterate through the precomputed moves.
    for (int move in rookMoves) {
      int newX = move ~/ 8;
      int newY = move % 8;

      // Check if the destination square is within the board boundaries.
      if (newX >= 0 && newX < 8 && newY >= 0 && newY < 8) {
        // If the square is empty, add it as a valid move.
        if (board[newX][newY] == null) {
          moves.add(Move(
            row: x,
            column: y,
            newRow: newX,
            newColumn: newY,
            fromSquare: squareName(x, y),
            toSquare: squareName(newX, newY),
          ));
        } else {
          // If the square contains an opponent's piece, add it as a valid move and stop checking further in this direction.
          if (board[newX][newY]!.color != color) {
            moves.add(Move(
              row: x,
              column: y,
              newRow: newX,
              newColumn: newY,
              fromSquare: squareName(x, y),
              toSquare: squareName(newX, newY),
            ));
          }
          break;
        }
      } else {
        // If the destination square is outside the board boundaries, stop checking further in this direction.
        break;
      }
    }

    return moves;
  }

  @override
  Rook copy() {
    return Rook(x, y, color, value);
  }

  @override
  String getSymbol() {
    return color == white ? 'R' : 'r';
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
