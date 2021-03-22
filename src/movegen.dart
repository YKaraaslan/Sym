import 'dart:math';

import 'board.dart';
import 'piece.dart';
import 'move.dart';

var moves;

List<Move> GenerateMoves() {
  PrecomputedMoveData();
  moves = <Move>[];

  for (var startSquare = 0; startSquare < 64; startSquare++) {
    int piece = Board.Square[startSquare];
    if (Piece.IsColour(piece, Board.colorToMove)) {
      if (Piece.IsSlidingPiece(piece)) {
        GenerateSlidingMoves(startSquare, piece);
      }
      else if (piece == Piece.PieceType(Piece.Knight)) {
        GenerateKnightMoves(startSquare);
      } else if (piece == Piece.PieceType(Piece.Pawn)) {
        GeneratePawnMoves(startSquare);
      } else if (piece == Piece.PieceType(Piece.King)) {
        GenerateKingMoves(startSquare);
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
      //print(moveName(startSquare, targetSquare));
      // Can't move any further in this direction after capturing opponent's piece

      if (Piece.IsColour(pieceOnTargetSquare, Board.opponentColour)) {
        break;
      }
    }
  }
}

/*------------------------------*/
List<int> DirectionOffsets = [8, -8, -1, 1, 7, -7, 9, -9];
var NumSquaresToEdge = new List.generate(64, (_) => new List.filled(64, 0));
var knightMoves = new List.generate(64, (_) => new List.filled(64, 0));
var allKnightJumps = {15, 17, -17, -15, 10, -6, 6, -10};

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






      /*var legalKnightJumps = new List.filled(64, 0);
      var knightBitboard = 0;

      for (var knightJumpDelta in allKnightJumps) {
        int knightJumpSquare = squareIndex + knightJumpDelta;
        if (knightJumpSquare >= 0 && knightJumpSquare < 64) {
          double knightSquareY = knightJumpSquare / 8;
          double knightSquareX = knightJumpSquare - knightSquareY * 8;
          // Ensure knight has moved max of 2 squares on x/y axis (to reject indices that have wrapped around side of board)
          int maxCoordMoveDst =
              max((x - knightSquareX).abs(), (y - knightSquareY).abs());
          if (maxCoordMoveDst == 2) {
            legalKnightJumps.add(knightJumpSquare);
          }
        }
      }

      knightMoves[squareIndex] = legalKnightJumps.toList();*/
    }
  }
}


String moveName(startSquare, targetSquare) {
  String res = '';
  var aSquares = [0, 8, 16, 24, 32, 40, 48, 56];
  var bSquares = [1, 9, 17, 25, 33, 41, 49, 57];
  var cSquares = [2, 10, 18, 26, 34, 42, 50, 58];
  var dSquares = [3, 11, 19, 27, 35, 43, 51, 59];
  var eSquares = [4, 12, 20, 28, 36, 44, 52, 60];
  var fSquares = [5, 13, 21, 29, 37, 45, 53, 61];
  var gSquares = [6, 14, 22, 30, 38, 46, 54, 62];
  var hSquares = [7, 15, 23, 31, 39, 47, 55, 63];

  var allSquares = [
    aSquares,
    bSquares,
    cSquares,
    dSquares,
    eSquares,
    fSquares,
    gSquares,
    hSquares
  ];

  var squareNames = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];

  for (var i = 0; i < allSquares.length; i++) {
    for (var j = 0; j < allSquares[i].length; j++) {
      if (startSquare == allSquares[i][j]) {
        res += squareNames[i] + (j + 1).toString();
      }
    }
  }

  for (var i = 0; i < allSquares.length; i++) {
    for (var j = 0; j < allSquares[i].length; j++) {
      if (targetSquare == allSquares[i][j]) {
        res += squareNames[i] + (j + 1).toString();
      }
    }
  }

  return res;
}

void GenerateKingMoves(int startSquare) {}

void GeneratePawnMoves(int startSquare) {}

/*---------------------------------*/

void GenerateKnightMoves(startSquare) {}
