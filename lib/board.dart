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

    // printTheBoard();
  }

  Piece? getPiece(String symbol, int x, int y) {
    PieceColor color = symbol.isUpperCase() ? white : black;
    var pieceTypeFromSymbol = {
      'k': King(x, y, color, maxValue),
      'p': Pawn(x, y, color, 100),
      'n': Knight(x, y, color, 320),
      'b': Bishop(x, y, color, 330),
      'r': Rook(x, y, color, 500),
      'q': Queen(x, y, color, 900),
    };
    return pieceTypeFromSymbol[symbol.toLowerCase()];
  }

  void makeMove(Move move) {
    if (move.isCastling) {
      int rookRow = move.row;
      int rookCol = (move.newColumn > move.column) ? 7 : 0;
      Piece? rook = board[rookRow][rookCol];
      board[rookRow][rookCol] = null;
      int newRookCol = (move.newColumn > move.column) ? move.newColumn - 1 : move.newColumn + 1;
      board[rookRow][newRookCol] = rook;

      // Update the hasMoved property of the king and rook
      (board[move.row][move.column] as King).hasMoved = true;
      (board[rookRow][newRookCol] as Rook).hasMoved = true;
    } else {
      // Perform a regular move
      board[move.newRow][move.newColumn] = board[move.row][move.column];
      board[move.newRow][move.newColumn]?.hasMoved = true;
      board[move.row][move.column] = null;
    }

    // Delete when the move is en passant
    if (move.isEnPassant) {
      board[move.row][move.newColumn] = null;
    }

    // Check if the moved piece is a pawn that has reached the end of the board
    if (board[move.newRow][move.newColumn] is Pawn && (move.newRow == 0 || move.newRow == 7)) {
      // Pawn has reached the end of the board, promote to a Queen
      board[move.newRow][move.newColumn] = Queen(move.newRow, move.newColumn, board[move.newRow][move.newColumn]!.color, 900);
    }

    // Check En passant
    if (activeColor == white && move.row == 1 && move.newRow == 3) {
      for (var piece in board[move.newRow]) {
        if (piece != null) {
          piece.enPassant = false;
        }
      }
      board[move.newRow][move.newColumn]?.enPassant = true;
    } else if (activeColor == black && move.row == 6 && move.newRow == 4) {
      for (var piece in board[move.newRow]) {
        if (piece != null) {
          piece.enPassant = false;
        }
      }
      board[move.newRow][move.newColumn]?.enPassant = true;
    }

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

  void makeMoveForBoard(List<List<Piece?>> localBoard, Move move) {
    if (move.isCastling) {
      int rookRow = move.row;
      int rookCol = (move.newColumn > move.column) ? 7 : 0;
      Piece? rook = localBoard[rookRow][rookCol];
      localBoard[rookRow][rookCol] = null;
      int newRookCol = (move.newColumn > move.column) ? move.newColumn - 1 : move.newColumn + 1;
      localBoard[rookRow][newRookCol] = rook;

      // Update the hasMoved property of the king and rook
      (localBoard[move.row][move.column] as King).hasMoved = true;
      (localBoard[rookRow][newRookCol] as Rook).hasMoved = true;
    } else {
      // Perform a regular move
      localBoard[move.newRow][move.newColumn] = localBoard[move.row][move.column];
      localBoard[move.newRow][move.newColumn]?.hasMoved = true;
      localBoard[move.row][move.column] = null;
    }

    // Delete when the move is en passant
    if (move.isEnPassant) {
      localBoard[move.row][move.newColumn] = null;
    }

    // Check if the moved piece is a pawn that has reached the end of the localBoard
    if (localBoard[move.newRow][move.newColumn] is Pawn && (move.newRow == 0 || move.newRow == 7)) {
      // Pawn has reached the end of the localBoard, promote to a Queen
      localBoard[move.newRow][move.newColumn] = Queen(move.newRow, move.newColumn, localBoard[move.newRow][move.newColumn]!.color, 900);
    }

    // Check En passant
    if (activeColor == white && move.row == 1 && move.newRow == 3) {
      for (var piece in localBoard[move.newRow]) {
        if (piece != null) {
          piece.enPassant = false;
        }
      }
      localBoard[move.newRow][move.newColumn]?.enPassant = true;
    } else if (activeColor == black && move.row == 6 && move.newRow == 4) {
      for (var piece in localBoard[move.newRow]) {
        if (piece != null) {
          piece.enPassant = false;
        }
      }
      localBoard[move.newRow][move.newColumn]?.enPassant = true;
    }

    // Update the active color and other internal state
    activeColor = activeColor == white ? black : white;
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
