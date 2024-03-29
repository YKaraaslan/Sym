import '../utils/constants.dart';
import '../utils/enums.dart';
import 'move.dart';
import 'piece.dart';

class Queen extends Piece {
  Queen(int x, int y, PieceColor color, int value, String symbol, bool hasMoved, bool enPassant) : super(x, y, color, value, symbol, hasMoved, enPassant);

  @override
  Set<Move> generateMoves(List<List<Piece?>> board) {
    Set<Move> moves = {};

    // Queens can move horizontally, vertically, or diagonally in any direction
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        // Skip the case where i and j are both 0
        if (i == 0 && j == 0) continue;

        // Check all possible moves in this direction
        int x = this.x + i;
        int y = this.y + j;
        while (x >= 0 && x < 8 && y >= 0 && y < 8) {
          Piece? target = board[x][y];
          if (target == null || target.color != color) {
            // Add a move to the list of moves
            moves.add(Move(
              row: this.x,
              column: this.y,
              newRow: x,
              newColumn: y,
              newSquare: newSquareString(x, y),
              oldSquare: newSquareString(this.x, this.y),
              pieceSymbol: symbol,
            ));
          }

          // Stop iterating if we encounter a piece
          if (target != null) break;

          // Move to the next square in this direction
          x += i;
          y += j;
        }
      }
    }

    return moves;
  }

  @override
  Queen copy() {
    return Queen(x, y, color, value, symbol, hasMoved, this.enPassant);
  }

  @override
  String getSymbol() {
    return color == white ? 'Q' : 'q';
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
