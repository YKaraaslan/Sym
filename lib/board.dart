import 'models/bishop.dart';
import 'models/king.dart';
import 'models/knight.dart';
import 'models/move.dart';
import 'models/pawn.dart';
import 'models/piece.dart';
import 'models/queen.dart';
import 'models/rook.dart';
import 'utils/constants.dart';
import 'utils/enums.dart';
import 'utils/extensions.dart';

// Represents a chess board with pieces
class ChessBoard {
  // A helper function to parse a FEN string and populate the chess board
  List<List<Piece?>> loadPositionFromFen(String fen) {
    List<List<Piece?>> board = List.generate(8, (_) => List.generate(8, (index) => null));
    // Split the FEN string into parts
    List<String> parts = fen.trim().split(' ');
    if (parts.length != 6) {
      throw Exception('Invalid FEN String');
    }
    List<String> fenResult = fen.split(' ');
    String fenBoard = fenResult[0];
    String colorResult = fenResult[1];
    String castlingResult = fenResult[2];
    String enPassantResult = fenResult[3];
    String halfMoveClockResult = fenResult[4];
    String fullMoveNumberResult = fenResult[5];
    var file = 0, rank = 7;
    for (int i = 0; i < fenBoard.length; i++) {
      var character = fenBoard[i];
      if (character == '/') {
        file = 0;
        rank--;
      } else if (character.isNumeric()) {
        file += int.parse(character);
      } else {
        board[rank][file] = getPiece(character, rank, file);
        file++;
      }
    }
    activeColor = colorResult.toLowerCase() == 'w' ? white : black;
    castling = {
      'K': castlingResult.contains('K'),
      'Q': castlingResult.contains('Q'),
      'k': castlingResult.contains('k'),
      'q': castlingResult.contains('q'),
    };
    enPassant = enPassantResult;
    halfMoveClock = int.parse(halfMoveClockResult);
    fullMoveClock = int.parse(fullMoveNumberResult);

    return board;
  }

  Piece? getPiece(String symbol, int x, int y) {
    PieceColor color = symbol.isUpperCase() ? white : black;
    var hasMoved = !initialPosition(symbol.toLowerCase(), color, x, y);
    var pieceTypeFromSymbol = {
      'k': King(x, y, color, 1000000, symbol, hasMoved, false),
      'q': Queen(x, y, color, 900, symbol, hasMoved, false),
      'r': Rook(x, y, color, 500, symbol, hasMoved, false),
      'b': Bishop(x, y, color, 330, symbol, hasMoved, false),
      'n': Knight(x, y, color, 320, symbol, hasMoved, false),
      'p': Pawn(x, y, color, 100, symbol, hasMoved, false),
    };
    return pieceTypeFromSymbol[symbol.toLowerCase()];
  }

  bool initialPosition(String symbol, PieceColor color, int x, int y) {
    if (color == white) {
      switch (symbol) {
        case 'k':
          return x == 0 && y == 4;
        case 'q':
          return x == 0 && y == 3;
        case 'r':
          return (x == 0 && y == 0) || (x == 0 && y == 7);
        case 'b':
          return (x == 0 && y == 2) || (x == 0 && y == 5);
        case 'n':
          return (x == 0 && y == 1) || (x == 0 && y == 6);
        case 'p':
          return x == 1;
        default:
          return false;
      }
    } else {
      switch (symbol) {
        case 'k':
          return x == 7 && y == 4;
        case 'q':
          return x == 7 && y == 3;
        case 'r':
          return (x == 7 && y == 0) || (x == 7 && y == 7);
        case 'b':
          return (x == 7 && y == 2) || (x == 7 && y == 5);
        case 'n':
          return (x == 7 && y == 1) || (x == 7 && y == 6);
        case 'p':
          return x == 6;
        default:
          return false;
      }
    }
  }

  void makeMove(List<List<Piece?>> localBoard, Move move, {bool isDeepCopy = false}) {
    if (move.isCastling) {
      int newRookCol = (move.newColumn > move.column) ? move.newColumn - 1 : move.newColumn + 1;
      int oldRookCol = (move.newColumn > move.column) ? 7 : 0;

      // Set the position of the rook
      localBoard[move.row][oldRookCol]!.x = move.newRow;
      localBoard[move.row][oldRookCol]!.y = newRookCol;
      localBoard[move.row][newRookCol] = localBoard[move.row][oldRookCol];
      localBoard[move.row][oldRookCol] = null;

      // Update the hasMoved property of the king and rook
      (localBoard[move.row][newRookCol] as Rook).hasMoved = true;
      (localBoard[move.row][move.column] as King).hasMoved = true;
    }

    // Store the captured piece (if any) in the Move object
    if (localBoard[move.newRow][move.newColumn] != null && localBoard[move.newRow][move.newColumn]!.color != localBoard[move.row][move.column]!.color) {
      move.capturedPiece = localBoard[move.newRow][move.newColumn];
    }

    // Perform a regular move
    localBoard[move.row][move.column]!.x = move.newRow;
    localBoard[move.row][move.column]!.y = move.newColumn;
    localBoard[move.row][move.column]!.hasMoved = true;
    localBoard[move.newRow][move.newColumn] = localBoard[move.row][move.column];
    localBoard[move.row][move.column] = null;

    // Delete when the move is en passant
    if (move.isEnPassant) {
      localBoard[move.row][move.newColumn] = null;
    }

    // Check if the moved piece is a pawn that has reached the end of the localBoard
    if (localBoard[move.newRow][move.newColumn] is Pawn && (move.newRow == 0 || move.newRow == 7)) {
      switch (move.promotion?.toLowerCase()) {
        case 'r':
          localBoard[move.newRow][move.newColumn] = Rook(
            move.newRow,
            move.newColumn,
            localBoard[move.newRow][move.newColumn]!.color,
            500,
            move.promotion ?? '',
            localBoard[move.newRow][move.newColumn]!.hasMoved,
            localBoard[move.newRow][move.newColumn]!.enPassant,
          );
          break;
        case 'b':
          localBoard[move.newRow][move.newColumn] = Bishop(
            move.newRow,
            move.newColumn,
            localBoard[move.newRow][move.newColumn]!.color,
            330,
            move.promotion ?? '',
            localBoard[move.newRow][move.newColumn]!.hasMoved,
            localBoard[move.newRow][move.newColumn]!.enPassant,
          );
          break;
        case 'n':
          localBoard[move.newRow][move.newColumn] = Knight(
            move.newRow,
            move.newColumn,
            localBoard[move.newRow][move.newColumn]!.color,
            320,
            move.promotion ?? '',
            localBoard[move.newRow][move.newColumn]!.hasMoved,
            localBoard[move.newRow][move.newColumn]!.enPassant,
          );
          break;
        default:
          localBoard[move.newRow][move.newColumn] = Queen(
            move.newRow,
            move.newColumn,
            localBoard[move.newRow][move.newColumn]!.color,
            900,
            move.promotion ?? '',
            localBoard[move.newRow][move.newColumn]!.hasMoved,
            localBoard[move.newRow][move.newColumn]!.enPassant,
          );
          break;
      }
    }

    // Remove En Passant
    for (var i = 3; i <= 4; i++) {
      for (var piece in localBoard[i]) {
        if (piece != null && piece is Pawn) {
          piece.enPassant = false;
        }
      }
    }

    // Check En passant
    if (activeColor == white && move.row == 1 && move.newRow == 3) {
      localBoard[move.newRow][move.newColumn]?.enPassant = true;
    } else if (activeColor == black && move.row == 6 && move.newRow == 4) {
      localBoard[move.newRow][move.newColumn]?.enPassant = true;
    }

    if (!isDeepCopy) {
      // Update the move numbers
      if (activeColor == white) {
        whiteMoves++;
      } else {
        blackMoves++;
      }

      // Update the clocks
      halfMoveClock++;
      if (activeColor == black) {
        fullMoveClock++;
      }

      // Update the active color and other internal state
      activeColor = activeColor == white ? black : white;

      // Add to the move history
      moveHistory.add(move);
    }
  }

  void undoMove(List<List<Piece?>> localBoard, Move move, {bool isDeepCopy = false}) {
    if (move.isCastling) {
      int newRookCol = (move.newColumn > move.column) ? move.newColumn - 1 : move.newColumn + 1;
      int oldRookCol = (move.newColumn > move.column) ? 7 : 0;

      // Set the position of the rook to its original square
      localBoard[move.row][newRookCol]!.x = move.row;
      localBoard[move.row][newRookCol]!.y = move.column;
      localBoard[move.row][oldRookCol] = localBoard[move.row][newRookCol];
      localBoard[move.row][newRookCol] = null;

      // Update the hasMoved property of the king and rook
      (localBoard[move.row][oldRookCol] as Rook).hasMoved = false;
      (localBoard[move.row][move.newColumn] as King).hasMoved = false;
    }

    // Undo a regular move
    localBoard[move.newRow][move.newColumn]!.x = move.row;
    localBoard[move.newRow][move.newColumn]!.y = move.column;
    localBoard[move.row][move.column] = localBoard[move.newRow][move.newColumn];
    localBoard[move.newRow][move.newColumn] = null;

    // Put the captured piece back on the localBoard (if any)
    if (move.capturedPiece != null) {
      localBoard[move.capturedPiece!.x][move.capturedPiece!.y] = move.capturedPiece;
    }

    // Undo en passant
    if (move.isEnPassant) {
      localBoard[move.row][move.column] = Pawn(
        move.row,
        move.column,
        localBoard[move.row][move.column]!.color,
        100,
        localBoard[move.row][move.column]!.symbol,
        localBoard[move.row][move.column]!.hasMoved,
        localBoard[move.row][move.column]!.enPassant,
      );
    }

    // Undo pawn promotion
    if (localBoard[move.row][move.column] is Pawn && (move.newRow == 0 || move.newRow == 7)) {
      localBoard[move.row][move.column] = Pawn(
        move.row,
        move.column,
        localBoard[move.row][move.column]!.color,
        100,
        localBoard[move.row][move.column]!.symbol,
        localBoard[move.row][move.column]!.hasMoved,
        localBoard[move.row][move.column]!.enPassant,
      );
    }

    if (!isDeepCopy) {
      // Update the move numbers
      if (activeColor == white) {
        whiteMoves--;
      } else {
        blackMoves--;
      }

      // Update the clocks
      halfMoveClock--;
      if (activeColor == black) {
        fullMoveClock--;
      }

      // Update the active color and other internal state
      activeColor = activeColor == white ? black : white;
    }
  }

  List<List<Piece?>> deepCopyBoard(List<List<Piece?>> board) {
    List<List<Piece?>> copy = [];
    for (int i = 0; i < board.length; i++) {
      List<Piece?> row = [];
      for (int j = 0; j < board[i].length; j++) {
        if (board[i][j] != null) {
          row.add(board[i][j]?.copy());
        } else {
          row.add(null);
        }
      }
      copy.add(row);
    }
    return copy;
  }

  void printTheBoard(List<List<Piece?>> localBoard) {
    print('\n' * 10);
    for (var i = localBoard.length - 1; i >= 0; i--) {
      var symbol = '';
      for (var element in localBoard[i]) {
        symbol += '${element?.getSymbol() ?? '.'} ';
      }
      print('$i-     $symbol');
    }
    print('\n' * 5);
  }
}
