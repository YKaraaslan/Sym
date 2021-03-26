import 'board.dart';
import 'piece.dart';
import 'move.dart';
import 'precomputed_movedata.dart';

var directionOffsets = [8, -8, -1, 1, 7, -7, 9, -9];
var attackedSquares = <int>[];

List getAttackedSquares() {
  for (var startSquare = 0; startSquare < 64; startSquare++) {
    int piece = Board.Square[startSquare];
    if (Piece.IsColour(piece, Board.opponentColour)) {
      if (Piece.IsSlidingPiece(piece)) {
        print('IsSlidingPiece');
        GenerateSlidingMovesForOpponent(startSquare, piece);
      } else if (Piece.IsKnight(piece)) {
        print('IsKnight');
        GenerateKnightMovesForOpponent(startSquare);
      } else if (Piece.IsPawn(piece)) {
        print('IsPawn');
        GeneratePawnMovesForOpponent(startSquare);
      } else if (Piece.IsKing(piece)) {
        print('IsKing');
        GenerateKingMovesForOpponent(startSquare);
      }
    }
  }
  return attackedSquares;
}

// rook, bishop, queen
void GenerateSlidingMovesForOpponent(int startSquare, int piece) {
  int startDirIndex = Piece.PieceType(piece) == Piece.Bishop ? 4 : 0;
  int endDirIndex = Piece.PieceType(piece) == Piece.Rook ? 4 : 8;

  for (var directionIndex = startDirIndex;
      directionIndex < endDirIndex;
      directionIndex++) {
    for (var n = 0; n < numSquaresToEdge[startSquare][directionIndex]; n++) {
      int targetSquare =
          (startSquare + directionOffsets[directionIndex] * (n + 1)).round();

      if (!targetSquare.isNegative) {
        int pieceOnTargetSquare = Board.Square[targetSquare];

        // Blocked by friendly piece, so can't move any further in this direction.
        if (Piece.IsColour(pieceOnTargetSquare, Board.opponentColour)) {
          break;
        }

        if (!attackedSquares.contains(targetSquare)) {
          attackedSquares.add(targetSquare);
        }
        // Can't move any further in this direction after capturing opponent's piece

        if (Piece.IsColour(pieceOnTargetSquare, Board.friendlyColour)) {
          break;
        }
      }
    }
  }
}

/*------------------------------*/

void GenerateKingMovesForOpponent(int startSquare) {
  for (int kingMoveIndex = 0;
      kingMoveIndex < kingMoves[startSquare].length;
      kingMoveIndex++) {
    int targetSquare = kingMoves[startSquare][kingMoveIndex];
    int pieceOnTargetSquare = Board.Square[targetSquare];

    if (Piece.IsColour(pieceOnTargetSquare, Board.opponentColour)) {
      continue;
    }

    //bool isCapture = Piece.IsColour (pieceOnTargetSquare, Board.friendlyColour);

    if (!attackedSquares.contains(targetSquare)) {
      attackedSquares.add(targetSquare);
    }

    print(moveName(startSquare, targetSquare));
  }
}

/*---------------------------------*/

void GenerateKnightMovesForOpponent(startSquare) {
  for (int knightMoveIndex = 0;
      knightMoveIndex < knightMoves[startSquare].length;
      knightMoveIndex++) {
    int targetSquare = knightMoves[startSquare][knightMoveIndex];
    int targetSquarePiece = Board.Square[targetSquare];
    /*bool isCapture = Piece.IsColour(targetSquarePiece, Board.friendlyColour);
    if (isCapture) {
      
    }*/

    // Skip if square contains friendly piece, or if in check and knight is not interposing/capturing checking piece
    if (Piece.IsColour(targetSquarePiece, Board.opponentColour)) {
      continue;
    }

    if (!attackedSquares.contains(targetSquare)) {
      attackedSquares.add(targetSquare);
    }
    print(moveName(startSquare, targetSquare));
  }
}

/*---------------------------------*/

void GeneratePawnMovesForOpponent(startSquare) {}
