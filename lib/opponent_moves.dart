import 'board.dart';
import 'piece.dart';
import 'precomputed_move_data.dart';
import 'src/checking_piece_model.dart';
import 'src/utils.dart';

List<int> directionOffsets = [8, -8, -1, 1, 7, -7, 9, -9];
List<int> attackedSquares = <int>[];
List<CheckingPieceModel> piecesChecking = <CheckingPieceModel>[];

List getAttackedSquares() {
  for (var startSquare = 0; startSquare < 64; startSquare++) {
    int piece = Board.square[startSquare];
    if (Piece.isColour(piece, Board.opponentColour)) {
      if (Piece.isSlidingPiece(piece)) {
        generateSlidingMovesForOpponent(startSquare, piece);
      } else if (Piece.isKnight(piece)) {
        generateKnightMovesForOpponent(startSquare);
      } else if (Piece.isPawn(piece)) {
        generatePawnMoves(startSquare);
      } else if (Piece.isKing(piece)) {
        generateKingMovesForOpponent(startSquare);
      }
    }
  }
  return attackedSquares;
}

// rook, bishop, queen
void generateSlidingMovesForOpponent(int startSquare, int piece) {
  int startDirIndex = Piece.pieceType(piece) == Piece.bishop ? 4 : 0;
  int endDirIndex = Piece.pieceType(piece) == Piece.rook ? 4 : 8;

  for (var directionIndex = startDirIndex;
      directionIndex < endDirIndex;
      directionIndex++) {
    for (var n = 0; n < numSquaresToEdge[startSquare][directionIndex]; n++) {
      int targetSquare =
          (startSquare + directionOffsets[directionIndex] * (n + 1)).round();
      if (!targetSquare.isNegative) {
        int pieceOnTargetSquare = Board.square[targetSquare];
        // Blocked by friendly piece, so can't move any further in this direction.
        if (Piece.isColour(pieceOnTargetSquare, Board.opponentColour)) {
          break;
        }
        if (Piece.isMyKing(pieceOnTargetSquare)) {
          var model = CheckingPieceModel(
            checkingPiece: Board.square[startSquare],
            square: startSquare,
            allTargetSquares: [],
          );
          if (Piece.isRook(piece)) {
            model.allTargetSquares = rookMoves[startSquare];
          } else if (Piece.isBishop(piece)) {
            model.allTargetSquares = bishopMoves[startSquare];
          } else if (Piece.isQueen(piece)) {
            model.allTargetSquares = queenMoves[startSquare];
          }
          piecesChecking.add(model);
        }

        if (!attackedSquares.contains(targetSquare)) {
          attackedSquares.add(targetSquare);
        }
        // Can't move any further in this direction after capturing opponent's piece

        if (Piece.isColour(pieceOnTargetSquare, Board.friendlyColour)) {
          break;
        }
      }
    }
  }
}

/*------------------------------*/

void generateKingMovesForOpponent(int startSquare) {
  for (int kingMoveIndex = 0;
      kingMoveIndex < kingMoves[startSquare].length;
      kingMoveIndex++) {
    int targetSquare = kingMoves[startSquare][kingMoveIndex];
    int pieceOnTargetSquare = Board.square[targetSquare];

    if (Piece.isColour(pieceOnTargetSquare, Board.opponentColour)) {
      continue;
    }

    //bool isCapture = Piece.IsColour (pieceOnTargetSquare, Board.friendlyColour);

    if (!attackedSquares.contains(targetSquare)) {
      attackedSquares.add(targetSquare);
    }

    // print(moveName(startSquare, targetSquare));
  }
}

/*---------------------------------*/

void generateKnightMovesForOpponent(int startSquare) {
  for (int knightMoveIndex = 0;
      knightMoveIndex < knightMoves[startSquare].length;
      knightMoveIndex++) {
    int targetSquare = knightMoves[startSquare][knightMoveIndex];
    int targetSquarePiece = Board.square[targetSquare];
    /*bool isCapture = Piece.IsColour(targetSquarePiece, Board.friendlyColour);
    if (isCapture) {
      
    }*/

    if (Piece.isMyKing(targetSquarePiece)) {
      piecesChecking.add(CheckingPieceModel(
          checkingPiece: Board.square[startSquare],
          square: startSquare,
          allTargetSquares: knightMoves[startSquare]));
    }

    // Skip if square contains friendly piece, or if in check and knight is not interposing/capturing checking piece
    if (Piece.isColour(targetSquarePiece, Board.opponentColour)) {
      continue;
    }

    if (!attackedSquares.contains(targetSquare)) {
      attackedSquares.add(targetSquare);
    }
    // print(moveName(startSquare, targetSquare));
  }
}

/*---------------------------------*/

void generateBlackPawnMovesForOpponent(int startSquare) {
  for (int blackPawnMoveIndex = 0;
      blackPawnMoveIndex < pawnAttacksBlack[startSquare].length;
      blackPawnMoveIndex++) {
    int targetSquare = pawnAttacksBlack[startSquare][blackPawnMoveIndex];
    int targetSquarePiece = Board.square[targetSquare];

    // Skip if square contains friendly piece, or if in check and knight is not interposing/capturing checking piece
    if (Piece.isColour(targetSquarePiece, Board.opponentColour)) {
      continue;
    }

    if (!attackedSquares.contains(targetSquare)) {
      attackedSquares.add(targetSquare);
    }
    // print(moveName(startSquare, targetSquare));
  }
}

/*---------------------------------*/

void generatePawnMoves(int startSquare) {
  int pawnOffset = (Board.friendlyColour == Piece.white) ? 8 : -8;
  int startRank = (Board.whiteToMove) ? 1 : 6;
  // int finalRankBeforePromotion = (Board.whiteToMove) ? 6 : 1;

  int rank = rankIndex(startSquare);

  int squareOneForward = startSquare + pawnOffset;
  if (Board.square[squareOneForward] == Piece.none) {
    attackedSquares.add(squareOneForward);
    if (rank == startRank) {
      int squareTwoForward = squareOneForward + pawnOffset;
      if (Board.square[squareTwoForward] == Piece.none) {
        attackedSquares.add(squareTwoForward);
      }
    }
  }
}
