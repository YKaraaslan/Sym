import '../engine.dart';
import '../square_checker.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';
import 'move.dart';
import 'piece.dart';
import 'rook.dart';

class King extends Piece {
  King(int x, int y, PieceColor color, int value, bool hasMoved, bool enPassant) : super(x, y, color, value, hasMoved, enPassant);

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

        if (!isSquareAttacked(board, row, col)) {
          // Check if the destination square is empty or contains an enemy piece
          Piece? piece = board[row][col];
          if (piece == null || piece.color != color) {
            moves.add(Move(row: x, column: y, newRow: row, newColumn: col, newSquare: newSquareString(row, col), oldSquare: newSquareString(x, y)));
          }
        }
      }
    }

    if (!hasMoved) {
      if (color == white && board[0][4] is King) {
        // Check for kingside castling
        if (castling['K']! && board[0][5] == null && board[0][6] == null && board[0][7] is Rook && !(board[0][7]?.hasMoved ?? true)) {
          if (!isSquareAttacked(board, 0, 4) && !isSquareAttacked(board, 0, 5) && !isSquareAttacked(board, 0, 6)) {
            moves.add(Move(row: 0, column: 4, newRow: 0, newColumn: 6, isCastling: true, newSquare: newSquareString(0, 6), oldSquare: newSquareString(x, y)));
          }
        }
        // Check for queenside castling
        if (castling['Q']! && board[0][1] == null && board[0][2] == null && board[0][3] == null && board[0][0] is Rook && !(board[0][0]?.hasMoved ?? true)) {
          if (!isSquareAttacked(board, 0, 4) && !isSquareAttacked(board, 0, 2) && !isSquareAttacked(board, 0, 3)) {
            moves.add(Move(row: 0, column: 4, newRow: 0, newColumn: 2, isCastling: true, newSquare: newSquareString(0, 2), oldSquare: newSquareString(x, y)));
          }
        }
      } else if (color == black && board[7][4] is King) {
        // Check for kingside castling
        if (castling['k']! && board[7][5] == null && board[7][6] == null && board[7][7] is Rook && !(board[7][7]?.hasMoved ?? true)) {
          if (!isSquareAttacked(board, 7, 4) && !isSquareAttacked(board, 7, 5) && !isSquareAttacked(board, 7, 6)) {
            moves.add(Move(row: 7, column: 4, newRow: 7, newColumn: 6, isCastling: true, newSquare: newSquareString(7, 6), oldSquare: newSquareString(x, y)));
          }
        }
        // Check for queenside castling
        if (castling['q']! && board[7][1] == null && board[7][2] == null && board[7][3] == null && board[7][0] is Rook && !(board[7][0]?.hasMoved ?? true)) {
          if (!isSquareAttacked(board, 7, 4) && !isSquareAttacked(board, 7, 2) && !isSquareAttacked(board, 7, 3)) {
            moves.add(Move(row: 7, column: 4, newRow: 7, newColumn: 2, isCastling: true, newSquare: newSquareString(7, 2), oldSquare: newSquareString(x, y)));
          }
        }
      }
    }

    return moves;
  }

  bool isSquareAttacked(List<List<Piece?>> board, int row, int col) {
    King king = Engine().findKing(board, color);
    Engine().removeKing(board, king);
    var result = SquareChecker().isSquareAttacked(board, row, col, color == white ? black : white);
    Engine().putKingBack(board, king);
    return result;
  }

  @override
  King copy() {
    return King(x, y, color, value, hasMoved, this.enPassant);
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
      control.add(move.newSquare);
    }
    return control;
  }
}
