import 'piece.dart';

class Board {
  static List<int> square = List.filled(64, 0);
  static int colorToMove = Piece.white;
  static bool whiteToMove = colorToMove == Piece.white;
  static bool blackToMove = colorToMove == Piece.black;
  static int friendlyColour = Piece.white;
  static int opponentColour = Piece.black;

  static String startFEN =
      'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
  static String laterFEN = '8/1k6/3n1q2/3b4/4K3/1BR5/8/8 w - - 0 1';
}
