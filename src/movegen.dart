import 'board.dart';
import 'piece.dart';
import 'move.dart';
import 'precomputed_movedata.dart';

var moves;
var directionOffsets = [8, -8, -1, 1, 7, -7, 9, -9];

List<Move> GenerateMoves() {
  PrecomputedMoveData();
  moves = <Move>[];

  for (var startSquare = 0; startSquare < 64; startSquare++) {
    int piece = Board.Square[startSquare];
    if (Piece.IsColour(piece, Board.colorToMove)) {
      if (Piece.IsSlidingPiece(piece)) {
        GenerateSlidingMoves(startSquare, piece);
      } else if (Piece.IsKnight(piece)) {
        GenerateKnightMoves(startSquare);
      } else if (Piece.IsPawn(piece)) {
        GeneratePawnMoves(startSquare);
      } else if (Piece.IsKing(piece)) {
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
    for (var n = 0; n < numSquaresToEdge[startSquare][directionIndex]; n++) {
      int targetSquare =
          (startSquare + directionOffsets[directionIndex] * (n + 1)).round();

        if (!targetSquare.isNegative) {
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
}

/*------------------------------*/

void GenerateKingMoves(int startSquare) {}

void GeneratePawnMoves(int startSquare) {}

/*---------------------------------*/

void GenerateKnightMoves(startSquare) {
  for (int knightMoveIndex = 0;
      knightMoveIndex < knightMoves[startSquare].length;
      knightMoveIndex++) {
    int targetSquare = knightMoves[startSquare][knightMoveIndex];
    int targetSquarePiece = Board.Square[targetSquare];
    /*bool isCapture = Piece.IsColour(targetSquarePiece, Board.opponentColour);
    if (isCapture) {
      
    }*/

    // Skip if square contains friendly piece, or if in check and knight is not interposing/capturing checking piece
      if (Piece.IsColour(targetSquarePiece, Board.friendlyColour)) {
        continue;
      }
      moves.add(new Move(startSquare, targetSquare));
      print(moveName(startSquare, targetSquare));
  }
}
