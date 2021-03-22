import 'dart:math';

var numSquaresToEdge = new List.generate(64, (_) => new List.filled(64, 0));
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

      numSquaresToEdge[squareIndex] = [
        numNorth,
        numSouth,
        numWest,
        numEast,
        min(numNorth, numWest),
        min(numSouth, numEast),
        min(numNorth, numEast),
        min(numSouth, numWest),
      ];

      var legalKnightJumps = <int>[];

      for (var knightJumpDelta in allKnightJumps) {
        int knightJumpSquare = (file * rank + knightJumpDelta).round();
        if (knightJumpSquare >= 0 && knightJumpSquare < 64) {
          double knightSquareY = knightJumpSquare / 8;
          double knightSquareX = knightJumpSquare - knightSquareY * 8;
          // Ensure knight has moved max of 2 squares on x/y axis (to reject indices that have wrapped around side of board)
          int maxCoordMoveDst = max((rank - knightSquareX).abs().round(),
              (rank - knightSquareY).abs().round());
          if (maxCoordMoveDst == 2) {
            legalKnightJumps.add(knightJumpSquare);
          }
        }
      }

      knightMoves[squareIndex] = legalKnightJumps;
      print("S: " + legalKnightJumps.toString());
    }
  }
}
