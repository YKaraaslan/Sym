import '../src/enums.dart';

class Piece {
  PieceTypes type;
  PieceColors color;
  int square;

  Piece({
    required this.type,
    required this.color,
    required this.square,
  });
}
