import 'piece.dart';

class Board {
  static List<int> square = List.filled(64, 0);
  static int colorToMove = Piece.white;
  static bool whiteToMove = colorToMove == Piece.white;
  static bool blackToMove = colorToMove == Piece.black;
  static int friendlyColour = Piece.white;
  static int opponentColour = Piece.black;

  static String startFEN = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
  static String laterFEN = '8/1k3b2/3n1q2/8/5R2/1B2K2r/8/8 w - - 0 1';
}
