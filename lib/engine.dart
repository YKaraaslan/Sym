import 'dart:io';
import 'dart:math';

import 'board.dart';

import 'models/bishop.dart';
import 'models/king.dart';
import 'models/knight.dart';
import 'models/move.dart';
import 'models/pawn.dart';
import 'models/piece.dart';
import 'models/queen.dart';
import 'models/rook.dart';
import 'move_generator.dart';
import 'utils/constants.dart';
import 'utils/enums.dart';

class Engine {
  void simulateChessGame() {
    // Simulate the game until it is over
    while (!MoveGenerator().isEndGame(board)) {
      // Make the move on the chess board
      ChessBoard().makeMove(MoveGenerator().generateMove(board));

      // Check if the game is over (i.e., there is a winner or the game is a draw)
      if (MoveGenerator().isEndGame(board)) {
        break;
      }

      // Switch the current player
      sleep(Duration(milliseconds: 250));
    }

    // Announce the winner or declare the game a draw
    if (isDraw(board)) {
      print('The game is a draw.');
    } else if (isCheckmate(board, white)) {
      print('Black wins.');
    } else if (isCheckmate(board, black)) {
      print('White wins.');
    }
  }

  bool isDraw(List<List<Piece?>> board) {
    // Check for a draw by 50-move rule
    if (halfMoveClock >= 100) {
      return true;
    }

    // Check for a draw by threefold repetition
    List<Move> positionsSeen = getPositionsSeen();
    if (positionsSeen.length > 3) {
      return true;
    }

    // Check if there are no legal moves for either player
    if (MoveGenerator().generateMoves(board, white).isEmpty && MoveGenerator().generateMoves(board, black).isEmpty) {
      return true;
    }

    // Check for a draw by insufficient material
    bool whiteHasBishopOrKnight = false;
    bool blackHasBishopOrKnight = false;
    bool whiteHasPawn = false;
    bool blackHasPawn = false;
    bool whiteHasRookOrQueen = false;
    bool blackHasRookOrQueen = false;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = board[i][j];
        if (piece == null) {
          continue;
        }
        if (piece.color == white) {
          if (piece is Bishop || piece is Knight) {
            whiteHasBishopOrKnight = true;
          } else if (piece is Pawn) {
            whiteHasPawn = true;
          } else if (piece is Rook || piece is Queen) {
            whiteHasRookOrQueen = true;
          }
        } else {
          if (piece is Bishop || piece is Knight) {
            blackHasBishopOrKnight = true;
          } else if (piece is Pawn) {
            blackHasPawn = true;
          } else if (piece is Rook || piece is Queen) {
            blackHasRookOrQueen = true;
          }
        }
      }
    }
    if (!whiteHasPawn && !blackHasPawn && !whiteHasRookOrQueen && !blackHasRookOrQueen) {
      if (!whiteHasBishopOrKnight || !blackHasBishopOrKnight) {
        return true;
      }
    }

    // Otherwise, the game is not a draw
    return false;
  }

  List<Move> getPositionsSeen() {
    List<Move> positionsSeen = [];
    for (Move move in moveHistory) {
      positionsSeen.add(move);
    }
    return positionsSeen;
  }

  bool isCheckmate(List<List<Piece?>> board, PieceColor color) {
    // Check if the king is in check
    if (!isCheck(board, color)) {
      return false;
    }

    // Generate a list of legal moves for the current player
    Set<Move> moves = MoveGenerator().generateMoves(board, color);

    // Check if any of the legal moves can get the king out of check
    for (Move move in moves) {
      // Make the move on a copy of the board
      List<List<Piece?>> copy = MoveGenerator().deepCopyBoard(board);
      ChessBoard().makeMoveForBoard(copy, move.toUciString());

      // If the king is no longer in check on the copy of the board, it is not checkmate
      if (!isCheck(copy, color)) {
        return false;
      }
    }

    // If none of the legal moves can get the king out of check, it is checkmate
    return true;
  }

  bool isCheck(List<List<Piece?>> board, PieceColor kingColor) {
    // Find the square of the king of the given color.
    String kingSquare = '';
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = board[i][j];
        if (piece != null && piece is King && piece.color == kingColor) {
          kingSquare = newSquareString(i, j);
          break;
        }
      }
    }

    // Iterate through the board and check if any of the opponent's pieces
    // can attack the king.
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = board[i][j];
        if (piece != null && piece.color != kingColor) {
          Set<String> control = piece.getControl(board);
          if (control.contains(kingSquare)) {
            return true;
          }
        }
      }
    }

    return false;
  }

  // Find the king of the given color on the board
  King findKing(List<List<Piece?>> board, PieceColor color) {
    late King king;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = board[i][j];
        if (piece != null && piece is King && piece.color == color) {
          king = piece;
        }
      }
    }
    return king;
  }

  // Remove the king from the board
  void removeKing(List<List<Piece?>> board, King king) {
    board[king.x][king.y] = null;
  }

  // Put the king back on the board
  void putKingBack(List<List<Piece?>> board, King king) {
    var isFound = false;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = board[i][j];
        if (piece != null && piece is King && piece.color == king.color) {
          isFound = true;
          break;
        }
      }
    }
    if (!isFound) {
      board[king.x][king.y] = king;
    }
  }
}
