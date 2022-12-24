import 'package:sym/utils/constants.dart';

import 'piece.dart';

class Move {
  int row;
  int column;
  int newRow;
  int newColumn;
  String oldSquare;
  String newSquare;
  bool isCastling;
  bool isEnPassant;
  String? promotion;
  Piece? capturedPiece;

  Move({
    required this.row,
    required this.column,
    required this.newRow,
    required this.newColumn,
    required this.oldSquare,
    required this.newSquare,
    this.isCastling = false,
    this.isEnPassant = false,
    this.promotion,
    this.capturedPiece,
  });

  String toUciString() {
    // If the move is a castling move, return the appropriate UCI string
    if (isCastling) {
      // Return the appropriate UCI castle move string
      if (newColumn == 6) {
        return (row == 7) ? 'e8g8' : 'e1g1';
      } else {
        return (row == 7) ? 'e8c8' : 'e1c1';
      }
    }

    // Build the UCI string
    String uciString = '$oldSquare$newSquare';

    // Append the 'e.p.' indicator if the move is an en passant capture
    if (isEnPassant) {
      uciString += ' e.p.';
    } else if (promotion != null) {
      uciString += promotion!;
    }

    return uciString;
  }

  static Move fromUciString(String moveString) {
    int row = (moveString[1] == '1') ? 0 : 7;
    // Check if the move is a castle move
    if (moveString == 'e1g1' || moveString == 'e8g8') {
      // Kingside castle
      return Move(
        row: row,
        column: 4,
        newRow: row,
        newColumn: 6,
        isCastling: true,
        oldSquare: '${files[4]}${row + 1}',
        newSquare: '${files[6]}${row + 1}',
      );
    } else if (moveString == 'e1c1' || moveString == 'e8c8') {
      // Queenside castle
      return Move(
        row: row,
        column: 4,
        newRow: row,
        newColumn: 2,
        isCastling: true,
        oldSquare: '${files[4]}${row + 1}',
        newSquare: '${files[2]}${row + 1}',
      );
    } else {
      // Parse the starting square
      int column = moveString.codeUnitAt(0) - 97;
      int row = int.parse(moveString[1]) - 1;

      // Parse the destination square
      int newColumn = moveString.codeUnitAt(2) - 97;
      int newRow = int.parse(moveString[3]) - 1;

      // Check if the move is an en passant capture
      bool isEnPassant = (row - newRow).abs() == 1 && column != newColumn;

      // Check if the move is a pawn promotion
      String? promotion;
      if (moveString.length == 5) {
        promotion = moveString[4];
      }

      return Move(
        row: row,
        column: column,
        newRow: newRow,
        newColumn: newColumn,
        isEnPassant: isEnPassant,
        promotion: promotion,
        oldSquare: '${files[column]}${row + 1}',
        newSquare: '${files[newColumn]}${newRow + 1}',
      );
    }
  }
}
