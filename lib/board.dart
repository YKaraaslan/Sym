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
  void loadPositionFromFen(String fen) {
    board = List.generate(8, (_) => List.generate(8, (index) => null));
    // Split the FEN string into parts
    List<String> parts = fen.split(' ');
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

    printTheBoard();
  }

  Piece? getPiece(String symbol, int x, int y) {
    PieceColor color = symbol.isUpperCase() ? white : black;
    var pieceTypeFromSymbol = {
      'k': King(x, y, color, maxValue),
      'p': Pawn(x, y, color, 1),
      'n': Knight(x, y, color, 3),
      'b': Bishop(x, y, color, 3),
      'r': Rook(x, y, color, 5),
      'q': Queen(x, y, color, 9),
    };
    return pieceTypeFromSymbol[symbol.toLowerCase()];
  }

  void makeMove(String moveString) {
    // Parse the UCI string and make the move on the chess board
    Move move = Move.fromUciString(moveString);

    if (move.isCastling) {
      int rookx1;
      int rooky1;
      if (move.newRow > move.row) {
        // Kingside castling
        board[move.row + 1][move.column] = board[move.row + 3][move.column];
        board[move.row + 3][move.column] = null;
        rookx1 = move.row + 1;
        rooky1 = move.column;
      } else {
        // Queenside castling
        board[move.row - 1][move.column] = board[move.row - 4][move.column];
        board[move.row - 4][move.column] = null;
        rookx1 = move.row - 1;
        rooky1 = move.column;
      }
      // Update the hasMoved property of the king and rook
      (board[move.row][move.column] as King).hasMoved = true;
      (board[rookx1][rooky1] as Rook).hasMoved = true;
    } else {
      // Perform a regular move
      board[move.newRow][move.newColumn] = board[move.row][move.column];
      board[move.row][move.column] = null;
    }
    //Check En passant
    if (activeColor == white && move.row == 1 && move.newRow == 3) {
      board[move.newRow][move.newColumn]?.enPassant = true;
    } else if (activeColor == black && move.row == 6 && move.newRow == 4) {
      board[move.newRow][move.newColumn]?.enPassant = true;
    }
    // Update the active color and other internal state
    activeColor = activeColor == white ? black : white;
    halfMoveClock++;
    if (activeColor == black) {
      fullMoveClock++;
    }
    moveHistory.add(move);
  }

  void makeMoveForBoard(List<List<Piece?>> localBoard, String moveString) {
    // Parse the UCI string and make the move on the chess board
    Move move = Move.fromUciString(moveString);

    if (move.isCastling) {
      int rookx1;
      int rooky1;
      if (move.newRow > move.row) {
        // Kingside castling
        localBoard[move.row + 1][move.column] = localBoard[move.row + 3][move.column];
        localBoard[move.row + 3][move.column] = null;
        rookx1 = move.row + 1;
        rooky1 = move.column;
      } else {
        // Queenside castling
        localBoard[move.row - 1][move.column] = localBoard[move.row - 4][move.column];
        localBoard[move.row - 4][move.column] = null;
        rookx1 = move.row - 1;
        rooky1 = move.column;
      }
      // Update the hasMoved property of the king and rook
      (localBoard[move.row][move.column] as King).hasMoved = true;
      (localBoard[rookx1][rooky1] as Rook).hasMoved = true;
    } else {
      // Perform a regular move
      localBoard[move.newRow][move.newColumn] = localBoard[move.row][move.column];
      localBoard[move.row][move.column] = null;
    }
    //Check En passant
    if (activeColor == white && move.row == 1 && move.newRow == 3) {
      localBoard[move.newRow][move.newColumn]?.enPassant = true;
    } else if (activeColor == black && move.row == 6 && move.newRow == 4) {
      localBoard[move.newRow][move.newColumn]?.enPassant = true;
    }
  }

  void printTheBoard() {
    print('\n' * 10);
    for (var i = board.length - 1; i >= 0; i--) {
      var symbol = '';
      for (var element in board[i]) {
        symbol += '${element?.getSymbol() ?? '.'} ';
      }
      print(symbol);
    }
    print('\n' * 5);
  }
}
