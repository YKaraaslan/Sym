import '../utils/constants.dart';
import '../utils/enums.dart';
import 'move.dart';
import 'piece.dart';

class Knight extends Piece {
  Knight(int x, int y, PieceColor color, int value, bool hasMoved, bool enPassant) : super(x, y, color, value, hasMoved, enPassant);

  @override
  Set<Move> generateMoves(List<List<Piece?>> board) {
    Set<Move> moves = {};

    // Knights can move in an L-shape (two squares in one direction, one square in the other)
    for (int i = -2; i <= 2; i++) {
      for (int j = -2; j <= 2; j++) {
        if (i.abs() + j.abs() == 3) {
          int x = this.x + i;
          int y = this.y + j;
          if (x >= 0 && x < 8 && y >= 0 && y < 8) {
            Piece? target = board[x][y];
            if (target == null || target.color != color) {
              moves.add(Move(row: this.x, column: this.y, newRow: x, newColumn: y, newSquare: newSquareString(x, y), oldSquare: newSquareString(this.x, this.y)));
            }
          }
        }
      }
    }

    return moves;
  }

  @override
  Knight copy() {
    return Knight(x, y, color, value, hasMoved, this.enPassant);
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
      control.add(move.newSquare);
    }
    return control;
  }
}
