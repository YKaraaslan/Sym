import 'piece.dart';

class Board {
  static List<int> Square;

  Board() {
    Square = new List<int>(64);

    /*Square[0] = Piece.White | Piece.Bishop;
    Square[63] = Piece.Black | Piece.Queen;
    Square[7] = Piece.Black | Piece.Knight;*/
  }
}
