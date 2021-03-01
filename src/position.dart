import 'dart:core';
import 'piece.dart';
import 'functions.dart';
import 'board.dart';

var Square;
final String startFEN = "rnbqkbnr/pppppppp/8/8/8/8/pppppppp/RNBQKBNR w KQkq - 0 1";

void init(){
  Square = Board.Square;

  //Square[0] = Piece.White | Piece.Bishop;
  loadPositionFromFen(startFEN);
  print("Position set");
}

void loadPositionFromFen(String fen){
  var pieceTypeFromSymbol = {
    'k' : Piece.King,
    'p' : Piece.Pawn,
    'n' : Piece.Knight,
    'b' : Piece.Bishop,
    'r' : Piece.Rook,
    'q' : Piece.Queen,
  };

  var fenBoard = fen.split(" ")[0];
  var file = 0, rank = 7;
  
  for(int i=0; i < fenBoard.length; i++) {
    var character = fenBoard[i];
    if(character == '/'){
      file = 0;
      rank--;
    }
    else if (isNumeric(character)) {
      file += int.tryParse(character);
    }
    else{
        var pieceColour = isUpperCase(character) ? Piece.White : Piece.Black;
        var pieceType = pieceTypeFromSymbol[character.toLowerCase()];
        Square[rank * 8 + file] = pieceType | pieceColour;
        file++;
    }
  }
}