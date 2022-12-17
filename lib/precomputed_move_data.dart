import 'dart:math';

class PrecomputedMoveData {
  static List<List<int>> numSquaresToEdge = List.generate(64, (_) => List.filled(64, 0));
  static List<List<int>> knightMoves = List.generate(64, (_) => List.filled(64, 0));
  static List<List<int>> kingMoves = List.generate(64, (_) => List.filled(64, 0));
  static List<List<int>> rookMoves = List.generate(64, (_) => List.filled(64, 0));
  static List<List<int>> bishopMoves = List.generate(64, (_) => List.filled(64, 0));
  static List<List<int>> queenMoves = List.generate(64, (_) => List.filled(64, 0));
  static List<List<int>> whitePawnMoves = List.generate(64, (_) => List.filled(64, 0));
  static List<List<int>> blackPawnMoves = List.generate(64, (_) => List.filled(64, 0));
  static List<List<int>> pawnAttacksWhite = List.generate(64, (_) => List.filled(64, 0));
  static List<List<int>> pawnAttacksBlack = List.generate(64, (_) => List.filled(64, 0));
  static Set<int> allKnightJumps = {15, 17, -17, -15, 10, -6, 6, -10};
  static Set<int> kingQueenDirectionOffsets = {8, -8, -1, 1, 9, -9, 7, -7};
  static Set<int> rookDirectionOffsets = {8, -8, -1, 1};
  static Set<int> bishopDirectionOffsets = {9, -9, 7, -7};
  static Set<int> whitePawnDirectionOffsets = {8};
  static Set<int> blackPawnDirectionOffsets = {-8};

  void precomputedMoveData() {
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
          int maxCoordMoveDst = max((x - knightSquareX).abs(), (y - knightSquareY).abs());
          if (maxCoordMoveDst == 2) {
            legalKnightJumps.add(knightJumpSquare);
          }
        }
      }

      knightMoves[squareIndex] = legalKnightJumps;
      // King Moves
      var legalKingMoves = <int>[];
      for (var kingMoveDelta in kingQueenDirectionOffsets) {
        int kingMoveSquare = squareIndex + kingMoveDelta;
        if (kingMoveSquare >= 0 && kingMoveSquare < 64) {
          int kingSquareY = kingMoveSquare ~/ 8;
          int kingSquareX = kingMoveSquare - kingSquareY * 8;
          // Ensure king has moved max of 1 square on x/y axis (to reject indices that have wrapped around side of board)
          int maxCoordMoveDst = max((x - kingSquareX).abs(), (y - kingSquareY).abs());
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
      // Rook Moves
      var legalRookMoves = <int>[];
      for (var rookMoveDelta in rookDirectionOffsets) {
        int rookMoveSquare = squareIndex + rookMoveDelta;
        while (rookMoveSquare >= 0 && rookMoveSquare < 64) {
          if (rookMoveDelta == rookDirectionOffsets.elementAt(0) || rookMoveDelta == rookDirectionOffsets.elementAt(1)) {
            legalRookMoves.add(rookMoveSquare);
          } else {
            int rookSquareY = rookMoveSquare ~/ 8;
            int rookSquareX = rookMoveSquare - rookSquareY * 8;

            legalRookMoves.add(rookMoveSquare);
            if (rookSquareX == 0 || rookSquareX == 7) {
              break;
            }
          }

          rookMoveSquare += rookMoveDelta;
        }
      }
      rookMoves[squareIndex] = legalRookMoves;
      // Bishop Moves
      var legalBishopMoves = <int>[];
      for (var bishopMoveDelta in bishopDirectionOffsets) {
        int bishopMoveSquare = squareIndex + bishopMoveDelta;
        while (bishopMoveSquare >= 0 && bishopMoveSquare < 64) {
          int bishopSquareY = bishopMoveSquare ~/ 8;
          int previousY = ((bishopMoveSquare - bishopMoveDelta) ~/ 8).abs();
          //Check to see if the Y axis is over 2
          if ((bishopSquareY - previousY).abs() > 1) {
            break;
          }
          //Check to see if the Y axis is the same
          if (bishopSquareY == (bishopMoveSquare - bishopMoveDelta) ~/ 8) {
            break;
          }
          legalBishopMoves.add(bishopMoveSquare);
          bishopMoveSquare += bishopMoveDelta;
        }
      }
      bishopMoves[squareIndex] = legalBishopMoves;
      // Queen Moves
      var legalQueenMoves = <int>[];
      for (var queenMoveDelta in kingQueenDirectionOffsets) {
        int queenMoveSquare = squareIndex + queenMoveDelta;
        while (queenMoveSquare >= 0 && queenMoveSquare < 64) {
          int queenSquareY = queenMoveSquare ~/ 8;
          int queenSquareX = queenMoveSquare - queenSquareY * 8;
          int previousY = ((queenMoveSquare - queenMoveDelta) ~/ 8).abs();

          if (queenMoveDelta == kingQueenDirectionOffsets.elementAt(0) || queenMoveDelta == kingQueenDirectionOffsets.elementAt(1)) {
            legalQueenMoves.add(queenMoveSquare);
          } else if (queenMoveDelta == kingQueenDirectionOffsets.elementAt(2) || queenMoveDelta == kingQueenDirectionOffsets.elementAt(3)) {
            legalQueenMoves.add(queenMoveSquare);
            if (queenSquareX == 0 || queenSquareX == 7) {
              break;
            }
          } else {
            //Check to see if the Y axis is over 2
            if ((queenSquareY - previousY).abs() > 1) {
              break;
            }
            //Check to see if the Y axis is the same
            if (queenSquareY == (queenMoveSquare - queenMoveDelta) ~/ 8) {
              break;
            }
            legalQueenMoves.add(queenMoveSquare);
          }

          queenMoveSquare += queenMoveDelta;
        }
      }
      queenMoves[squareIndex] = legalQueenMoves;
      // White Pawn Moves
      var legalWhitePawnMoves = <int>[];
      if (y < 7) {
        for (var whitePawnMoveDelta in whitePawnDirectionOffsets) {
          int whitePawnMoveSquare = squareIndex + whitePawnMoveDelta;
          legalWhitePawnMoves.add(whitePawnMoveSquare);
          if (whitePawnMoveSquare ~/ 8 == 1) {
            legalWhitePawnMoves.add(whitePawnMoveSquare + whitePawnMoveDelta);
          }
        }
      }
      whitePawnMoves[squareIndex] = legalWhitePawnMoves;
      // Black Pawn Moves
      var legalBlackPawnMoves = <int>[];
      if (y > 0) {
        for (var blackPawnMoveDelta in blackPawnDirectionOffsets) {
          int blackPawnMoveSquare = squareIndex + blackPawnMoveDelta;
          legalBlackPawnMoves.add(blackPawnMoveSquare);
          if (blackPawnMoveSquare ~/ 8 == 6) {
            legalBlackPawnMoves.add(blackPawnMoveSquare + blackPawnMoveDelta);
          }
        }
      }
      blackPawnMoves[squareIndex] = legalBlackPawnMoves;
    }
  }
}
