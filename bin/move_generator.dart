import 'package:sym/functions.dart';

import 'board.dart';
import 'piece.dart';
import 'move.dart';
import 'precomputed_move_data.dart';

late List<Move> moves;
var directionOffsets = [8, -8, -1, 1, 7, -7, 9, -9];

List<Move> generateMoves() {
  moves = [];

  for (var startSquare = 0; startSquare < 64; startSquare++) {
    int piece = Board.square[startSquare];
    if (Piece.isColour(piece, Board.colorToMove)) {
      if (Piece.isSlidingPiece(piece)) {
        generateSlidingMoves(startSquare, piece);
      } else if (Piece.isKnight(piece)) {
        generateKnightMoves(startSquare);
      } else if (Piece.isPawn(piece)) {
        generatePawnMoves(startSquare);
      } else if (Piece.isKing(piece)) {
        generateKingMoves(startSquare);
      }
    }
  }

  for (var move in moves) {
    print(moveName(move.startSquare, move.targetSquare));
  }

  return moves;
}

// rook, bishop, queen
void generateSlidingMoves(int startSquare, int piece) {
  int startDirIndex = Piece.pieceType(piece) == Piece.bishop ? 4 : 0;
  int endDirIndex = Piece.pieceType(piece) == Piece.rook ? 4 : 8;

  for (var directionIndex = startDirIndex; directionIndex < endDirIndex; directionIndex++) {
    for (var n = 0; n < numSquaresToEdge[startSquare][directionIndex]; n++) {
      int targetSquare = (startSquare + directionOffsets[directionIndex] * (n + 1)).round();

      if (!targetSquare.isNegative) {
        int pieceOnTargetSquare = Board.square[targetSquare];

        // Blocked by friendly piece, so can't move any further in this direction.
        if (Piece.isColour(pieceOnTargetSquare, Board.friendlyColour)) {
          break;
        }

        moves.add(Move(startSquare, targetSquare));
        // print(moveName(startSquare, targetSquare));

        // Can't move any further in this direction after capturing opponent's piece

        if (Piece.isColour(pieceOnTargetSquare, Board.opponentColour)) {
          break;
        }
      }
    }
  }
}

/*------------------------------*/

void generateKingMoves(int startSquare) {
  for (int kingMoveIndex = 0; kingMoveIndex < kingMoves[startSquare].length; kingMoveIndex++) {
    int targetSquare = kingMoves[startSquare][kingMoveIndex];
    int pieceOnTargetSquare = Board.square[targetSquare];

    if (Piece.isColour(pieceOnTargetSquare, Board.friendlyColour)) {
      continue;
    }

    //bool isCapture = Piece.IsColour (pieceOnTargetSquare, Board.opponentColour);

    moves.add(Move(startSquare, targetSquare));
    // print(moveName(startSquare, targetSquare));
  }
}

/*---------------------------------*/

void generateKnightMoves(startSquare) {
  for (int knightMoveIndex = 0; knightMoveIndex < knightMoves[startSquare].length; knightMoveIndex++) {
    int targetSquare = knightMoves[startSquare][knightMoveIndex];
    int targetSquarePiece = Board.square[targetSquare];
    /*bool isCapture = Piece.IsColour(targetSquarePiece, Board.opponentColour);
    if (isCapture) {
      
    }*/

    // Skip if square contains friendly piece, or if in check and knight is not interposing/capturing checking piece
    if (Piece.isColour(targetSquarePiece, Board.friendlyColour)) {
      continue;
    }
    moves.add(Move(startSquare, targetSquare));
    // print(moveName(startSquare, targetSquare));
  }
}

/*---------------------------------*/

void generatePawnMoves(startSquare) {
  int pawnOffset = (Board.friendlyColour == Piece.white) ? 8 : -8;
  int startRank = (Board.whiteToMove) ? 1 : 6;
  // int finalRankBeforePromotion = (Board.whiteToMove) ? 6 : 1;

  int rank = rankIndex(startSquare);

  int squareOneForward = startSquare + pawnOffset;
  if (Board.square[squareOneForward] == Piece.none) {
    moves.add(Move(startSquare, squareOneForward));
    if (rank == startRank) {
      int squareTwoForward = squareOneForward + pawnOffset;
      if (Board.square[squareTwoForward] == Piece.none) {
        moves.add(Move(startSquare, squareTwoForward));
      }
    }
  }
}
