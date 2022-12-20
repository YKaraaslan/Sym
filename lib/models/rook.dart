import '../utils/constants.dart';
import '../utils/enums.dart';
import 'move.dart';
import 'piece.dart';

class Rook extends Piece {
  Rook(int x, int y, PieceColor color, int value) : super(x, y, color, value);

  @override
  Set<Move> generateMoves(List<List<Piece?>> board) {
    Set<Move> moves = {};

    // Generate moves in the up direction
    for (int row = x + 1; row < 8; row++) {
      // Check if the destination square is empty or contains an enemy piece
      Piece? piece = board[row][y];
      if (piece == null) {
        moves.add(Move(row: x, column: y, newRow: row, newColumn: y, newSquare: newSquareString(row, y)));
      } else {
        if (piece.color != color) {
          moves.add(Move(row: x, column: y, newRow: row, newColumn: y, newSquare: newSquareString(row, y)));
        }
        break;
      }
    }

    // Generate moves in the down direction
    for (int row = x - 1; row >= 0; row--) {
      // Check if the destination square is empty or contains an enemy piece
      Piece? piece = board[row][y];
      if (piece == null) {
        moves.add(Move(row: x, column: y, newRow: row, newColumn: y, newSquare: newSquareString(row, y)));
      } else {
        if (piece.color != color) {
          moves.add(Move(row: x, column: y, newRow: row, newColumn: y, newSquare: newSquareString(row, y)));
        }
        break;
      }
    }

    // Generate moves in the right direction
    for (int c = y + 1; c < 8; c++) {
      // Check if the destination square is empty or contains an enemy piece
      Piece? piece = board[x][c];
      if (piece == null) {
        moves.add(Move(row: x, column: y, newRow: x, newColumn: c, newSquare: newSquareString(x, c)));
      } else {
        if (piece.color != color) {
          moves.add(Move(row: x, column: y, newRow: x, newColumn: c, newSquare: newSquareString(x, c)));
        }
        break;
      }
    } // Generate moves in the left direction
    for (int c = y - 1; c >= 0; c--) {
      // Check if the destination square is empty or contains an enemy piece
      Piece? piece = board[x][c];
      if (piece == null) {
        moves.add(Move(row: x, column: y, newRow: x, newColumn: c, newSquare: newSquareString(x, c)));
      } else {
        if (piece.color != color) {
          moves.add(Move(row: x, column: y, newRow: x, newColumn: c, newSquare: newSquareString(x, c)));
        }
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
      control.add(move.newSquare);
    }
    return control;
  }
}
