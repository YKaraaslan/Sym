import 'dart:core';
import 'piece.dart';
import 'functions.dart';
import 'board.dart';

void init() {
  //Square[0] = Piece.White | Piece.Bishop;
  //loadPositionFromFen(startFEN);
  print("Position set");
}

void loadPositionFromFen(String fen) {
  var pieceTypeFromSymbol = {
    'k': Piece.King,
    'p': Piece.Pawn,
    'n': Piece.Knight,
    'b': Piece.Bishop,
    'r': Piece.Rook,
    'q': Piece.Queen,
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
      var pieceColour = isUpperCase(character) ? Piece.White : Piece.Black;
      var pieceType = pieceTypeFromSymbol[character.toLowerCase()];
      Board.Square[rank * 8 + file] = pieceType! | pieceColour;
      file++;
    }
  }
}
