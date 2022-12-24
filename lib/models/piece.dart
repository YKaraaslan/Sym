import '../utils/enums.dart';
import 'move.dart';

abstract class Piece {
  int x;
  int y;
  PieceColor color;
  int value;
  bool hasMoved = false;
  bool enPassant = false;

  Piece(this.x, this.y, this.color, this.value, this.hasMoved, this.enPassant);

  // Generate a list of valid moves for the piece
  Piece copy();
  Set<Move> generateMoves(List<List<Piece?>> board);
  String getSymbol();
  Set<String> getControl(List<List<Piece?>> board);
}
