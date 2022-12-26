import '../utils/constants.dart';
import '../utils/enums.dart';
import 'move.dart';
import 'piece.dart';

class Bishop extends Piece {
  Bishop(int x, int y, PieceColor color, int value, String symbol, bool hasMoved, bool enPassant) : super(x, y, color, value, symbol, hasMoved, enPassant);

  @override
  Set<Move> generateMoves(List<List<Piece?>> board) {
    Set<Move> moves = {};

    // Bishops can move diagonally in any direction
    for (int i = -1; i <= 1; i += 2) {
      for (int j = -1; j <= 1; j += 2) {
        int x = this.x + i;
        int y = this.y + j;
        while (x >= 0 && x < 8 && y >= 0 && y < 8) {
          Piece? target = board[x][y];
          if (target == null) {
            moves.add(Move(
              row: this.x,
              column: this.y,
              newRow: x,
              newColumn: y,
              newSquare: newSquareString(x, y),
              oldSquare: newSquareString(this.x, this.y),
              pieceSymbol: symbol,
            ));
          } else if (target.color != color) {
            moves.add(Move(
              row: this.x,
              column: this.y,
              newRow: x,
              newColumn: y,
              newSquare: newSquareString(x, y),
              oldSquare: newSquareString(this.x, this.y),
              pieceSymbol: symbol,
            ));
            break;
          } else {
            break;
          }
          x += i;
          y += j;
        }
      }
    }

    return moves;
  }

  @override
  Bishop copy() {
    return Bishop(x, y, color, value, symbol, hasMoved, this.enPassant);
  }

  @override
  String getSymbol() {
    return color == white ? 'B' : 'b';
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
