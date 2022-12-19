import '../square_checker.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';
import 'move.dart';
import 'piece.dart';
import 'rook.dart';

class King extends Piece {
  King(int x, int y, PieceColor color) : super(x, y, color);

  @override
  Set<Move> generateMoves(List<List<Piece?>> board) {
    Set<Move> moves = {};

    // Generate moves in all eight directions
    for (int row = x - 1; row <= x + 1; row++) {
      for (int col = y - 1; col <= y + 1; col++) {
        // Skip the king's current square
        if (row == x && col == y) continue;

        // Check if the destination square is within the board bounds
        if (row < 0 || row >= 8 || col < 0 || col >= 8) continue;

        // Check if the destination square is safe
        if (!isSquareAttacked(board, row, col)) {
          // Check if the destination square is empty or contains an enemy piece
          Piece? piece = board[row][col];
          if (piece == null || piece.color != color) {
            moves.add(Move(x, y, row, col));
          }
        }
      }
    }

    if (!hasMoved) {
      if (color == white) {
        // Check for kingside castling
        if (board[0][5] == null &&
            board[0][6] == null &&
            board[0][7] is Rook &&
            !(board[0][7]?.hasMoved ?? true)) {
          if (!isSquareAttacked(board, 0, 5) &&
              !isSquareAttacked(board, 0, 6)) {
            moves.add(Move(0, 4, 0, 6, isCastling: true));
          }
        } else {
          // Check for queenside castling
          if (board[0][1] == null &&
              board[0][2] == null &&
              board[0][3] == null &&
              board[0][0] is Rook &&
              !(board[0][0]?.hasMoved ?? true)) {
            if (!isSquareAttacked(board, 0, 1) &&
                !isSquareAttacked(board, 0, 2) &&
                !isSquareAttacked(board, 0, 3)) {
              moves.add(Move(0, 4, 0, 2, isCastling: true));
            }
          }
        }
      } else {
        // Check for kingside castling
        if (board[7][5] == null &&
            board[7][6] == null &&
            board[7][7] is Rook &&
            !(board[7][7]?.hasMoved ?? true)) {
          if (!isSquareAttacked(board, 7, 5) &&
              !isSquareAttacked(board, 7, 6)) {
            moves.add(Move(7, 4, 7, 6, isCastling: true));
          }
        } else {
          // Check for queenside castling
          if (board[7][1] == null &&
              board[7][2] == null &&
              board[7][3] == null &&
              board[7][0] is Rook &&
              !(board[7][0]?.hasMoved ?? true)) {
            if (!isSquareAttacked(board, 7, 1) &&
                !isSquareAttacked(board, 7, 2) &&
                !isSquareAttacked(board, 7, 3)) {
              moves.add(Move(7, 4, 7, 2, isCastling: true));
            }
          }
        }
      }
    }

    return moves;
  }

  bool isSquareAttacked(List<List<Piece?>> board, int col, int row) {
    return SquareChecker()
        .isSquareAttacked(board, row, col, color == white ? black : white);
  }

  @override
  King copy() {
    return King(x, y, color);
  }

  @override
  String getSymbol() {
    return color == white ? 'K' : 'k';
  }
}
