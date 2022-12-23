import '../precomputed_mode_data.dart';
import '../square_checker.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';
import 'move.dart';
import 'piece.dart';
import 'rook.dart';

class King extends Piece {
  King(int x, int y, PieceColor color, int value) : super(x, y, color, value);

  @override
  Set<Move> generateMoves(List<List<Piece?>> board) {
    Set<Move> moves = {};

    // Check if the king is currently in check.
    bool inCheck = isSquareAttacked(board, x, y);

    // Get the precomputed king moves for this square.
    List<int> kingMoves = PrecomputedMoveData.kingMoves[x * 8 + y];

    for (int move in kingMoves) {
      int newX = move ~/ 8;
      int newY = move % 8;

      // Check if the destination square is within the board boundaries and is either empty or contains an opponent's piece.
      if (newX >= 0 && newX < 8 && newY >= 0 && newY < 8 && (board[newX][newY] == null || board[newX][newY]!.color != color)) {
        // Check if making the move would put the king in check.
        if (!isSquareAttacked(board, newX, newY)) {
          moves.add(Move(
            row: x,
            column: y,
            newRow: newX,
            newColumn: newY,
            fromSquare: squareName(x, y),
            toSquare: squareName(newX, newY),
          ));
        } else if (!inCheck) {
          // If the king was not in check before, it is now in check.
          inCheck = true;
        }
      }
    }

    // Check if the king is allowed to castle.
    if (!inCheck && !hasMoved && board[x][7] is Rook && board[x][7]!.hasMoved == false) {
      // Check if the squares between the king and the rook are empty.
      bool empty = true;
      for (int i = y + 1; i < 7; i++) {
        if (board[x][i] != null) {
          empty = false;
          break;
        }
      }

      // Check if the king is not in check and the squares it would pass through are not attacked
      if (empty && !isSquareAttacked(board, x, y) && !isSquareAttacked(board, x, y + 1) && !isSquareAttacked(board, x, y + 2)) {
        moves.add(Move(
          row: x,
          column: y,
          newRow: x,
          newColumn: y + 2,
          fromSquare: squareName(x, y),
          toSquare: squareName(x, y + 2),
          isCastling: true,
        ));
      }
    }

    // Check if the king is allowed to castle.
    if (!inCheck && !hasMoved && board[x][0] is Rook && board[x][0]!.hasMoved == false) {
      // Check if the squares between the king and the rook are empty.
      bool empty = true;
      for (int i = y - 1; i > 0; i--) {
        if (board[x][i] != null) {
          empty = false;
          break;
        }
      }

      // Check if the king is not in check and the squares it would pass through are not attacked
      if (empty && !isSquareAttacked(board, x, y) && !isSquareAttacked(board, x, y - 1) && !isSquareAttacked(board, x, y - 2)) {
        moves.add(Move(
          row: x,
          column: y,
          newRow: x,
          newColumn: y - 2,
          fromSquare: squareName(x, y),
          toSquare: squareName(x, y - 2),
          isCastling: true,
        ));
      }
    }
    return moves;
  }

  bool isSquareAttacked(List<List<Piece?>> board, int row, int col) {
    return SquareChecker().isSquareAttacked(board, row, col, color == white ? black : white);
  }

  @override
  King copy() {
    return King(x, y, color, value);
  }

  @override
  String getSymbol() {
    return color == white ? 'K' : 'k';
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
