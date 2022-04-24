import 'dart:core';
import 'package:sym/functions.dart';

import 'piece.dart';
import 'board.dart';

class Preposition {

  void init() {
    loadPositionFromFen(Board.laterFEN);
    print("Position set");
  }

  void loadPositionFromFen(String fen) {
    var pieceTypeFromSymbol = {
      'k': Piece.king,
      'p': Piece.pawn,
      'n': Piece.knight,
      'b': Piece.bishop,
      'r': Piece.rook,
      'q': Piece.queen,
    };

    var fenBoard = fen.split(" ")[0];

    var file = 0, rank = 7;

    for (int i = 0; i < fenBoard.length; i++) {
      var character = fenBoard[i];
      if (character == '/') {
        file = 0;
        rank--;
      } else if (isNumeric(character)) {
        file += int.parse(character);
      } else {
        var pieceColour = isUpperCase(character) ? Piece.white : Piece.black;
        var pieceType = pieceTypeFromSymbol[character.toLowerCase()];
        Board.square[rank * 8 + file] = pieceType! | pieceColour;
        file++;
      }
    }
  }
}
