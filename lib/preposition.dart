import 'dart:core';

import 'board.dart';
import 'piece.dart';
import 'src/extensions.dart';

class PrePosition {
  void loadPositionFromFen(String fen) {
    var pieceTypeFromSymbol = {
      'k': Piece.king,
      'p': Piece.pawn,
      'n': Piece.knight,
      'b': Piece.bishop,
      'r': Piece.rook,
      'q': Piece.queen,
    };
    var fenBoard = fen.split(' ')[0];
    var file = 0, rank = 7;
    for (int i = 0; i < fenBoard.length; i++) {
      var character = fenBoard[i];
      if (character == '/') {
        file = 0;
        rank--;
      } else if (character.isNumeric()) {
        file += int.parse(character);
      } else {
        var pieceColour = character.isUpperCase() ? Piece.white : Piece.black;
        var pieceType = pieceTypeFromSymbol[character.toLowerCase()];
        Board.square[rank * 8 + file] = pieceType! | pieceColour;
        file++;
      }
    }
  }
}
