import 'piece.dart';

class Board {
  static late List<int> square = List.filled(64, 0);
  static late int colorToMove = Piece.white;
  static late bool whiteToMove = colorToMove == Piece.white;
  static late bool blackToMove = colorToMove == Piece.black;
  static late int friendlyColour = Piece.white; // TODO fill here later depending on the color of pieces
  static late int opponentColour = Piece.black; // TODO fill here later depending on the color of pieces

  static late String startFEN ="rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";
  static late String laterFEN ="r1bqkbnr/pppp1ppp/8/n3p3/1PB1P3/5N2/P1PP1PPP/RNBQK2R b KQkq - 0 4";
}
