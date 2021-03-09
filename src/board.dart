import 'piece.dart';

class Board {
  static late List<int> Square;
  static late int colorToMove;
  static late int friendlyColour;
  static late int opponentColour;

  Board() {
    Square = <int>[64];
    colorToMove = Piece.White;
    friendlyColour = Piece.White;
    opponentColour = Piece.Black;

    /*Square[0] = Piece.White | Piece.Bishop;
    Square[63] = Piece.Black | Piece.Queen;
    Square[7] = Piece.Black | Piece.Knight;*/
  }
}
