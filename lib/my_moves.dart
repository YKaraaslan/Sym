import 'board.dart';
import 'models/checking_piece.dart';
import 'models/move.dart';
import 'opponent_moves.dart';
import 'piece.dart';
import 'precomputed_move_data.dart';
import 'src/extensions.dart';

class MyMoves {
  MyMoves._privateConstructor();
  static final MyMoves _instance = MyMoves._privateConstructor();
  factory MyMoves() {
    return _instance;
  }

  List<Move> moves = [];
  List<Move> captures = [];
  List<int> directionOffsets = [8, -8, -1, 1, 7, -7, 9, -9];
  List<CheckingPiece> piecesChecking = OpponentMoves().piecesChecking;
  List<int> attackedSquares = OpponentMoves().attackedSquares;

  List<Move> generateLegalMoves() {
    if (piecesChecking.length >= 2) {
      for (var startSquare = 0; startSquare < 64; startSquare++) {
        int piece = Board.square[startSquare];
        if (Piece.isMyKing(piece)) {
          generateKingMoves(startSquare);
        }
      }
    } else if (piecesChecking.isNotEmpty) {
      if (Piece.isKnight(piecesChecking.first.checkingPiece)) {
        for (var startSquare = 0; startSquare < 64; startSquare++) {
          int piece = Board.square[startSquare];
          if (Piece.isMyKing(piece)) {
            generateKingMoves(startSquare);
          } else if (Piece.isMySliding(piece)) {
            generateSlidingMoves(startSquare, piece, isCaptureCheck: true);
          } else if (Piece.isMyKnight(piece)) {
            generateKnightMoves(startSquare, isCaptureCheck: true);
          }
        }
      }
    } else {
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
    }
    if (piecesChecking.isNotEmpty) {
      moves.addAll(captures.where(
        (element) => element.targetSquare == piecesChecking.first.square,
      ));
    }
    moves.removeWhere((element) {
      return attackedSquares.contains(element.targetSquare);
    });
    moves = moves.toSet().toList();
    for (var move in moves) {
      print(Move.moveName(move.startSquare, move.targetSquare));
    }
    return moves;
  }

// rook, bishop, queen
  void generateSlidingMoves(int startSquare, int piece, {bool isCaptureCheck = false}) {
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
          } else if (Piece.isColour(pieceOnTargetSquare, Board.opponentColour)) {
            captures.add(Move(startSquare, targetSquare));
            if (isCaptureCheck) break;
          }

          if (!isCaptureCheck) moves.add(Move(startSquare, targetSquare));
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
      } else if (Piece.isColour(pieceOnTargetSquare, Board.opponentColour)) {
        captures.add(Move(startSquare, targetSquare));
      }

      //bool isCapture = Piece.IsColour (pieceOnTargetSquare, Board.opponentColour);

      moves.add(Move(startSquare, targetSquare));
      // print(moveName(startSquare, targetSquare));
    }
  }

/*---------------------------------*/

  void generateKnightMoves(int startSquare, {bool isCaptureCheck = false}) {
    for (int knightMoveIndex = 0; knightMoveIndex < knightMoves[startSquare].length; knightMoveIndex++) {
      int targetSquare = knightMoves[startSquare][knightMoveIndex];
      int targetSquarePiece = Board.square[targetSquare];

      // Skip if square contains friendly piece, or if in check and knight is not interposing/capturing checking piece
      if (Piece.isColour(targetSquarePiece, Board.friendlyColour)) {
        continue;
      } else if (Piece.isColour(targetSquarePiece, Board.opponentColour)) {
        captures.add(Move(startSquare, targetSquare));
        if (isCaptureCheck) continue;
      }
      if (!isCaptureCheck) moves.add(Move(startSquare, targetSquare));
      // print(moveName(startSquare, targetSquare));
    }
  }

/*---------------------------------*/

  void generatePawnMoves(int startSquare) {
    int pawnOffset = (Board.friendlyColour == Piece.white) ? 8 : -8;
    int startRank = (Board.whiteToMove) ? 1 : 6;
    // int finalRankBeforePromotion = (Board.whiteToMove) ? 6 : 1;
    int rank = startSquare.rankIndex();
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
}
