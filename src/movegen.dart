import 'dart:math';

import 'board.dart';
import 'piece.dart';
import 'move.dart';

var moves;

List<Move> GenerateMoves() {
  moves = <Move>[];

  for (var startSquare = 0; startSquare < 64; startSquare++) {
    int piece = Board.Square[startSquare];
    if (Piece.IsColour(piece, Board.colorToMove)) {
      print('inside');
      if (Piece.IsSlidingPiece(piece)) {
        GenerateSlidingMoves(startSquare, piece);
      }
    }
  }

  return moves;
}

// rook, bishop, queen
void GenerateSlidingMoves(int startSquare, int piece) {
  int startDirIndex = Piece.PieceType(piece) == Piece.Bishop ? 4 : 0;
  int endDirIndex = Piece.PieceType(piece) == Piece.Rook ? 4 : 8;

  for (var directionIndex = startDirIndex;
      directionIndex < endDirIndex;
      directionIndex++) {
    for (var n = 0; n < NumSquaresToEdge[startSquare][directionIndex]; n++) {
      int targetSquare =
          startSquare + DirectionOffsets[directionIndex] * (n + 1);
      int pieceOnTargetSquare = Board.Square[targetSquare];

      // Blocked by friendly piece, so can't move any further in this direction.
      if (Piece.IsColour(pieceOnTargetSquare, Board.friendlyColour)) {
        break;
      }

      moves.add(new Move(startSquare, targetSquare));
      print(targetSquare);
      // Can't move any further in this direction after capturing opponent's piece

      if (Piece.IsColour(pieceOnTargetSquare, Board.opponentColour)) {
        break;
      }
    }
  }
}

/*------------------------------*/
List<int> DirectionOffsets = [8, -8, -1, 1, 7, -7, 9, -9];
var NumSquaresToEdge = List.generate(8, (i) => [8], growable: false);

PrecomputedMoveData() {
  for (var file = 0; file < 8; file++) {
    for (var rank = 0; rank < 8; rank++) {
      int numNorth = 7 - rank;
      int numSouth = rank;
      int numWest = file;
      int numEast = 7 - file;

      int squareIndex = rank * 8 + file;

      NumSquaresToEdge[squareIndex] = [
        numNorth,
        numSouth,
        numWest,
        numEast,
        min(numNorth, numWest),
        min(numSouth, numEast),
        min(numNorth, numEast),
        min(numSouth, numWest),
      ];
    }
  }
}
