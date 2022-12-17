import 'dart:core';

import 'board.dart';

class Piece {
  static final int none = 0;
  static final int king = 1;
  static final int pawn = 2;
  static final int knight = 3;
  static final int bishop = 4;
  static final int rook = 5;
  static final int queen = 6;

  static final int white = 8;
  static final int black = 16;

  static const int typeMask = 7;
  static const int blackMask = 16;
  static const int whiteMask = 8;
  static const int colourMask = whiteMask | blackMask;

  static bool isColour(int piece, int colour) {
    return (piece & colourMask) == colour;
  }

  static int pieceType(int piece) {
    return piece & typeMask;
  }

  static bool isSlidingPiece(int piece) {
    return (piece & 4) != 0;
  }

  static bool isMyQueen(int piece) {
    return Piece.queen | Board.friendlyColour == piece;
  }

  static bool isMyRook(int piece) {
    return Piece.rook | Board.friendlyColour == piece;
  }

  static bool isMyBishop(int piece) {
    return Piece.bishop | Board.friendlyColour == piece;
  }

  static bool isMyKnight(int piece) {
    return Piece.knight | Board.friendlyColour == piece;
  }

  static bool isMyPawn(int piece) {
    return Piece.pawn | Board.friendlyColour == piece;
  }

  static bool isMyKing(int piece) {
    return Piece.king | Board.friendlyColour == piece;
  }

  static bool isMySliding(int piece) {
    return isMyQueen(piece) || isMyRook(piece) || isMyBishop(piece);
  }

  static bool isOpponentsSliding(int piece) {
    return isOpponentsQueen(piece) || isOpponentsRook(piece) || isOpponentsBishop(piece);
  }

  static bool isOpponentsQueen(int piece) {
    return Piece.queen | Board.opponentColour == piece;
  }

  static bool isOpponentsRook(int piece) {
    return Piece.rook | Board.opponentColour == piece;
  }

  static bool isOpponentsBishop(int piece) {
    return Piece.bishop | Board.opponentColour == piece;
  }

  static bool isOpponentsKnight(int piece) {
    return Piece.knight | Board.opponentColour == piece;
  }

  static bool isOpponentsPawn(int piece) {
    return Piece.pawn | Board.opponentColour == piece;
  }

  static bool isOpponentsKing(int piece) {
    return Piece.king | Board.opponentColour == piece;
  }

  static bool isQueen(int piece) {
    return (piece & 6) == 6;
  }

  static bool isRook(int piece) {
    return (piece & 5) == 5;
  }

  static bool isBishop(int piece) {
    return (piece & 4) == 4;
  }

  static bool isKnight(int piece) {
    return (piece & 3) == 3;
  }

  static bool isPawn(int piece) {
    return (piece & 2) == 2;
  }

  static bool isKing(int piece) {
    return (piece & 1) == 1;
  }

  static String pieceName(int piece) {
    if (isQueen(piece)) {
      return 'Queen';
    }
    if (isRook(piece)) {
      return 'Rook';
    }
    if (isBishop(piece)) {
      return 'Bishop';
    }
    if (isKnight(piece)) {
      return 'Knight';
    }
    if (isKing(piece)) {
      return 'King';
    }
    if (isPawn(piece)) {
      return 'Pawn';
    } else {
      return '';
    }
  }
}
