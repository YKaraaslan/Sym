import 'piece.dart';

class Board {
  static List<int> Square;
  static int colorToMove;
  static int friendlyColour;
  static int opponentColour;

  Board() {
    Square = new List<int>(64);
    colorToMove = Piece.White;
    friendlyColour = Piece.White;
    opponentColour = Piece.Black;

    /*Square[0] = Piece.White | Piece.Bishop;
    Square[63] = Piece.Black | Piece.Queen;
    Square[7] = Piece.Black | Piece.Knight;*/
  }
}
