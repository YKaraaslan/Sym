import 'dart:core';

class Piece { 
  static final int None = 0;
  static final int King = 1;
  static final int Pawn = 2;
  static final int Knight = 3;
  static final int Bishop = 4;
  static final int Rook = 5;
  static final int Queen = 6;

  static final int White = 8;
  static final int Black = 16;

  static const int typeMask = 0x00111;
  static const int blackMask = 0x10000;
  static const int whiteMask = 0x01000;
  static const int colourMask = whiteMask | blackMask;

    static bool IsColour (int piece, int colour) {
    return (piece & colourMask) == colour;
  }

    static int Colour (int piece) {
    return piece & colourMask;
  }

    static int PieceType (int piece) {
    return piece & typeMask;
  }

    static bool IsRookOrQueen (int piece) {
    return (piece & 0x110) == 0x110;
  }

    static bool IsBishopOrQueen (int piece) {
    return (piece & 0x101) == 0x101;
  }

    static bool IsSlidingPiece (int piece) {
    return (piece & 0x100) != 0;
  }
}