import 'piece.dart';

class Board {
  static late List<int> Square = List.filled(64, 0);
  static late int colorToMove = Piece.White;
  static late bool WhiteToMove = colorToMove == Piece.White;
  static late int friendlyColour = Piece.White;
  static late int opponentColour = Piece.Black;

  static late String startFEN =
      "rnbqkbnr/pppppppp/8/8/8/8/pppppppp/RNBQKBNR w KQkq - 0 1";
}
