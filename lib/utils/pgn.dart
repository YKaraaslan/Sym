import 'dart:convert';
import 'dart:io';

import '../models/move.dart';
import 'constants.dart';

class PGN {
  Future<void> open() async {
    // Open the PGN file
    File file = File('assets/games.pgn');
    String pgn = await file.readAsString();

    // Split the PGN contents into individual lines
    List<String> lines = LineSplitter.split(pgn).toList();

    // Parse the PGN data
    Map<String, String> tags = {};
    List<String> moves = [];
    for (String line in lines) {
      if (line.startsWith('[')) {
        // This line is a tag
        int closingBracketIndex = line.indexOf(']');
        String tagName = line.substring(1, closingBracketIndex);
        String tagValue = line.substring(closingBracketIndex + 2);
        tags[tagName] = tagValue;
      } else {
        // This line is a move
        moves.add(line);
      }
    }

    // Access the game data
    print(tags['White']);
    print(tags['Black']);
    print(tags['Result']);
    print(moves);
    // ...
  }

  String moveHistoryToPGNMoves(List<Move> moveHistory) {
    for (Move move in moveHistory) {
      // Get the from and to squares
      String fromSquare = '';
      String toSquare = newSquareString(move.newRow, move.newColumn);

      // Determine the piece type and the move type
      String pieceType, moveType;
      if (move.pieceSymbol.toLowerCase() == 'p') {
        // This is a pawn move
        pieceType = '';
        moveType = '';
        if (move.column != move.newColumn) {
          fromSquare = newSquareString(move.row, move.column)[0];
        }
      } else {
        // This is a piece move
        pieceType = move.pieceSymbol;
        moveType = '';
        if (move.capturedPiece != null) {
          // This is a capture
          moveType = 'x';
        } else if (move.isEnPassant) {
          // This is an en passant capture
          moveType = 'x';
        }
      }
      // Generate the PGN notation for the move
      String pgnMove = '';

      // Handle castling
      if (move.isCastling) {
        pieceType = '';
        if (move.newColumn > move.column) {
          // King-side castle
          pgnMove = '0-0';
        } else {
          // Queen-side castle
          pgnMove = '0-0-0';
        }
      }

      // Handle promotion
      if (move.promotion != null) {
        toSquare += '=${move.promotion!}';
      }

      if (moveNumber % 2 == 1) {
        // White move
        pgnMove += '${moveNumber ~/ 2 + 1}. ';
      }
      pgnMove += '$pieceType$fromSquare$moveType$toSquare';
      pgnMoves += ' $pgnMove';

      moveNumber++;
    }
    return pgnMoves.trim();
  }
}
