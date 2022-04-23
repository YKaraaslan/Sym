import 'dart:math';

var numSquaresToEdge = new List.generate(64, (_) => new List.filled(64, 0));
var knightMoves = new List.generate(64, (_) => new List.filled(64, 0));
var kingMoves = new List.generate(64, (_) => new List.filled(64, 0));
var pawnAttacksWhite = new List.generate(64, (_) => new List.filled(64, 0));
var pawnAttacksBlack = new List.generate(64, (_) => new List.filled(64, 0));
var allKnightJumps = {15, 17, -17, -15, 10, -6, 6, -10};
var directionOffsets = {8, -8, -1, 1, 7, -7, 9, -9};

PrecomputedMoveData() {
  for (int squareIndex = 0; squareIndex < 64; squareIndex++) {
    int y = squareIndex ~/ 8;
    int x = squareIndex - y * 8;

    int north = 7 - y;
    int south = y;
    int west = x;
    int east = 7 - x;
    numSquaresToEdge[squareIndex] = List.generate(8, (index) => 0);
    numSquaresToEdge[squareIndex][0] = north;
    numSquaresToEdge[squareIndex][1] = south;
    numSquaresToEdge[squareIndex][2] = west;
    numSquaresToEdge[squareIndex][3] = east;
    numSquaresToEdge[squareIndex][4] = min(north, west);
    numSquaresToEdge[squareIndex][5] = min(south, east);
    numSquaresToEdge[squareIndex][6] = min(north, east);
    numSquaresToEdge[squareIndex][7] = min(south, west);

    //Knight Moves

    var legalKnightJumps = <int>[];

    for (var knightJumpDelta in allKnightJumps) {
      int knightJumpSquare = squareIndex + knightJumpDelta;
      if (knightJumpSquare >= 0 && knightJumpSquare < 64) {
        int knightSquareY = knightJumpSquare ~/ 8;
        int knightSquareX = knightJumpSquare - knightSquareY * 8;

        // Ensure knight has moved max of 2 squares on x/y axis (to reject indices that have wrapped around side of board)
        int maxCoordMoveDst =
            max((x - knightSquareX).abs(), (y - knightSquareY).abs());

        if (maxCoordMoveDst == 2) {
          legalKnightJumps.add(knightJumpSquare);
        }
      }
    }

    knightMoves[squareIndex] = legalKnightJumps;

    // King Moves
    var legalKingMoves = <int>[];

    for (var kingMoveDelta in directionOffsets) {
      int kingMoveSquare = squareIndex + kingMoveDelta;
      if (kingMoveSquare >= 0 && kingMoveSquare < 64) {
        int kingSquareY = kingMoveSquare ~/ 8;
        int kingSquareX = kingMoveSquare - kingSquareY * 8;
        // Ensure king has moved max of 1 square on x/y axis (to reject indices that have wrapped around side of board)
        int maxCoordMoveDst =
            max((x - kingSquareX).abs(), (y - kingSquareY).abs());
        if (maxCoordMoveDst == 1) {
          legalKingMoves.add(kingMoveSquare);
        }
      }
    }

    kingMoves[squareIndex] = legalKingMoves;

    // Pawn Moves
    List<int> pawnCapturesWhite = <int>[];
    List<int> pawnCapturesBlack = <int>[];
    if (x > 0) {
      if (y < 7) {
        pawnCapturesWhite.add(squareIndex + 7);
      }
      if (y > 0) {
        pawnCapturesBlack.add(squareIndex - 9);
      }
    }
    if (x < 7) {
      if (y < 7) {
        pawnCapturesWhite.add(squareIndex + 9);
      }
      if (y > 0) {
        pawnCapturesBlack.add(squareIndex - 7);
      }
    }
    pawnAttacksWhite[squareIndex] = pawnCapturesWhite;
    pawnAttacksBlack[squareIndex] = pawnCapturesBlack;
  }
}
