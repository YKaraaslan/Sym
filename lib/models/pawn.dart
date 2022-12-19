import '../utils/constants.dart';
import '../utils/enums.dart';
import 'move.dart';
import 'piece.dart';

class Pawn extends Piece {
  Pawn(int x, int y, PieceColor color) : super(x, y, color);

  @override
  Set<Move> generateMoves(List<List<Piece?>> board) {
    Set<Move> moves = {};

    // Pawns can move forward one square if the square is unoccupied
    int forward = color == white ? 1 : -1;
    if (board[x + forward][y] == null) {
      moves.add(Move(x, y, x + forward, y));
    }

    // Pawns can move forward two squares if they are on their starting rank and the squares are unoccupied
    if ((color == white && x == 1) || (color == black && x == 6)) {
      if (board[x + forward][y] == null && board[x + 2 * forward][y] == null) {
        moves.add(Move(x, y, x + 2 * forward, y));
      }
    }

    // Pawns can capture enemy pieces on the diagonal
    for (int i = -1; i <= 1; i += 2) {
      int newColumn = y + i;
      if (newColumn >= 0 && newColumn < 8) {
        Piece? target = board[x + forward][newColumn];
        if (target != null && target.color != color) {
          moves.add(Move(x, y, x + forward, newColumn));
        }
      }
    }

    if (color == white && x == 4) {
      // Check for en passant capture to the left
      if (y > 0 &&
          board[x][y - 1] is Pawn &&
          board[x][y - 1]?.color == black &&
          (board[x][y - 1]?.enPassant ?? false)) {
        moves.add(Move(x, y, x + 1, y - 1, isEnPassant: true));
      }
      // Check for en passant capture to the right
      if (y > 0 &&
          board[x][y + 1] is Pawn &&
          board[x][y + 1]?.color == black &&
          (board[x][y + 1]?.enPassant ?? false)) {
        moves.add(Move(x, y, x + 1, y + 1, isEnPassant: true));
      }
    } else if (color == black && x == 3) {
      // Check for en passant capture to the left
      if (y < 7 &&
          board[x][y - 1] is Pawn &&
          board[x][y - 1]?.color == white &&
          (board[x][y - 1]?.enPassant ?? false)) {
        moves.add(Move(x, y, x - 1, y - 1, isEnPassant: true));
      }
      // Check for en passant capture to the right
      if (y < 7 &&
          board[x][y + 1] is Pawn &&
          board[x][y + 1]?.color == white &&
          (board[x][y + 1]?.enPassant ?? false)) {
        moves.add(Move(x, y, x - 1, y + 1, isEnPassant: true));
      }
    }

    return moves;
  }

  @override
  Pawn copy() {
    return Pawn(x, y, color);
  }

  @override
  String getSymbol() {
    return color == white ? 'P' : 'p';
  }
}
