import 'models/bishop.dart';
import 'models/king.dart';
import 'models/knight.dart';
import 'models/pawn.dart';
import 'models/piece.dart';
import 'models/queen.dart';
import 'models/rook.dart';
import 'utils/constants.dart';
import 'utils/enums.dart';
import 'utils/extensions.dart';

// Represents a chess board with pieces
class ChessBoard {
  List<List<Piece?>> board = List.generate(8, (_) => List.generate(8, (index) => null));

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

  // Makes a move on the board
  void makeMove(String move) {
    // Parse the move string and get the source and destination coordinates
    int sourceX = 'abcdefgh'.indexOf(move[0]);
    int sourceY = int.parse(move[1]) - 1;
    int destX = 'abcdefgh'.indexOf(move[2]);
    int destY = int.parse(move[3]) - 1;

    // Perform the move
    board[destY][destX] = board[sourceY][sourceX];
    board[sourceY][sourceX] = null;

    // Switch the turn
    activeColor = (activeColor == white) ? black : white;
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
