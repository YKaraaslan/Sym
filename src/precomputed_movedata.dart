import 'dart:math';

var numSquaresToEdge = new List.generate(64, (_) => new List.filled(64, 0));
var knightMoves = new List.generate(64, (_) => new List.filled(64, 0));
var allKnightJumps = {15, 17, -17, -15, 10, -6, 6, -10};

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
  }
}
