import '../utils/enums.dart';
import 'move.dart';

abstract class Piece {
  int x;
  int y;
  PieceColor color;
  int value;

  Piece(this.x, this.y, this.color, this.value);
  Piece copy();
  bool hasMoved = false;
  bool enPassant = false;

  // Generate a list of valid moves for the piece
  Set<Move> generateMoves(List<List<Piece?>> board);
  String getSymbol();
  int getControl(List<List<Piece?>> board);
}
