import '../utils/constants.dart';
import '../utils/enums.dart';
import 'move.dart';
import 'piece.dart';

class Pawn extends Piece {
  Pawn(int x, int y, PieceColor color, int value, bool hasMoved, bool enPassant) : super(x, y, color, value, hasMoved, enPassant);

  @override
  Set<Move> generateMoves(List<List<Piece?>> board) {
    Set<Move> moves = {};

    // Pawns can move forward one square if the square is unoccupied
    int forward = color == white ? 1 : -1;
    if (board[x + forward][y] == null) {
      // Check if the pawn has reached the opposite end of the board
      if ((color == white && x + forward == 7) || (color == black && x + forward == 0)) {
        // Add promotion moves for each possible promotion piece
        moves.add(Move(
            row: x,
            column: y,
            newRow: x + forward,
            newColumn: y,
            promotion: 'q',
            newSquare: newSquareString(x + forward, y),
            oldSquare: newSquareString(x, y)));
        moves.add(Move(
            row: x,
            column: y,
            newRow: x + forward,
            newColumn: y,
            promotion: 'r',
            newSquare: newSquareString(x + forward, y),
            oldSquare: newSquareString(x, y)));
        moves.add(Move(
            row: x,
            column: y,
            newRow: x + forward,
            newColumn: y,
            promotion: 'b',
            newSquare: newSquareString(x + forward, y),
            oldSquare: newSquareString(x, y)));
        moves.add(Move(
            row: x,
            column: y,
            newRow: x + forward,
            newColumn: y,
            promotion: 'n',
            newSquare: newSquareString(x + forward, y),
            oldSquare: newSquareString(x, y)));
      } else {
        moves.add(
            Move(row: x, column: y, newRow: x + forward, newColumn: y, newSquare: newSquareString(x + forward, y), oldSquare: newSquareString(x, y)));
      }
    }

    // Pawns can move forward two squares if they are on their starting rank and the squares are unoccupied
    if ((color == white && x == 1) || (color == black && x == 6)) {
      if (board[x + forward][y] == null && board[x + 2 * forward][y] == null) {
        moves.add(Move(
            row: x,
            column: y,
            newRow: x + 2 * forward,
            newColumn: y,
            newSquare: newSquareString(x + 2 * forward, y),
            oldSquare: newSquareString(x, y)));
      }
    }

    // Pawns can capture enemy pieces on the diagonal
    for (int i = -1; i <= 1; i += 2) {
      int newColumn = y + i;
      if (newColumn >= 0 && newColumn < 8) {
        Piece? target = board[x + forward][newColumn];
        if (target != null && target.color != color) {
          // Check if the pawn has reached the opposite end of the board
          if ((color == white && x + forward == 7) || (color == black && x + forward == 0)) {
            // Add promotion moves for each possible promotion piece
            moves.add(Move(
                row: x,
                column: y,
                newRow: x + forward,
                newColumn: newColumn,
                promotion: 'q',
                newSquare: newSquareString(x + forward, newColumn),
                oldSquare: newSquareString(x, y)));
            moves.add(Move(
                row: x,
                column: y,
                newRow: x + forward,
                newColumn: newColumn,
                promotion: 'r',
                newSquare: newSquareString(x + forward, newColumn),
                oldSquare: newSquareString(x, y)));
            moves.add(Move(
                row: x,
                column: y,
                newRow: x + forward,
                newColumn: newColumn,
                promotion: 'b',
                newSquare: newSquareString(x + forward, newColumn),
                oldSquare: newSquareString(x, y)));
            moves.add(Move(
                row: x,
                column: y,
                newRow: x + forward,
                newColumn: newColumn,
                promotion: 'n',
                newSquare: newSquareString(x + forward, newColumn),
                oldSquare: newSquareString(x, y)));
          } else {
            // Regular capture move
            moves.add(Move(
                row: x,
                column: y,
                newRow: x + forward,
                newColumn: newColumn,
                newSquare: newSquareString(x + forward, newColumn),
                oldSquare: newSquareString(x, y)));
          }
        }
      }
    }

    if (color == white && x == 4) {
      // Check for en passant capture to the left
      if (y > 0 && board[x][y - 1] is Pawn && board[x][y - 1]?.color == black && (board[x][y - 1]?.enPassant ?? false)) {
        moves.add(Move(
            row: x,
            column: y,
            newRow: x + 1,
            newColumn: y - 1,
            isEnPassant: true,
            newSquare: newSquareString(x + forward, y - 1),
            oldSquare: newSquareString(x, y)));
      }
      // Check for en passant capture to the right
      if (y < 7 && board[x][y + 1] is Pawn && board[x][y + 1]?.color == black && (board[x][y + 1]?.enPassant ?? false)) {
        moves.add(Move(
            row: x,
            column: y,
            newRow: x + 1,
            newColumn: y + 1,
            isEnPassant: true,
            newSquare: newSquareString(x + forward, y + 1),
            oldSquare: newSquareString(x, y)));
      }
    } else if (color == black && x == 3) {
      // Check for en passant capture to the left
      if (y > 0 && board[x][y - 1] is Pawn && board[x][y - 1]?.color == white && (board[x][y - 1]?.enPassant ?? false)) {
        moves.add(Move(
            row: x,
            column: y,
            newRow: x - 1,
            newColumn: y - 1,
            isEnPassant: true,
            newSquare: newSquareString(x + forward, y - 1),
            oldSquare: newSquareString(x, y)));
      }
      // Check for en passant capture to the right
      if (y < 7 && board[x][y + 1] is Pawn && board[x][y + 1]?.color == white && (board[x][y + 1]?.enPassant ?? false)) {
        moves.add(Move(
            row: x,
            column: y,
            newRow: x - 1,
            newColumn: y + 1,
            isEnPassant: true,
            newSquare: newSquareString(x + forward, y + 1),
            oldSquare: newSquareString(x, y)));
      }
    }

    return moves;
  }

  @override
  Pawn copy() {
    return Pawn(x, y, color, value, hasMoved, this.enPassant);
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
      control.add(move.newSquare);
    }
    return control;
  }
}
