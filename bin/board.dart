import 'piece.dart';

class Board {
  static late List<int> square = List.filled(64, 0);
  static late int colorToMove = Piece.white;
  static late bool whiteToMove = colorToMove == Piece.white;
  static late bool blackToMove = colorToMove == Piece.black;
  static late int friendlyColour = Piece.white; // TODO fill here later depending on the color of pieces
  static late int opponentColour = Piece.black; // TODO fill here later depending on the color of pieces

  static late String startFEN ="rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";
}
