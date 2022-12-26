import 'dart:io';

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
import 'square_checker.dart';
import 'utils/constants.dart';
import 'utils/enums.dart';

class Engine {
  void simulateChessGame(List<List<Piece?>> board) {
    // Simulate the game until it is over
    while (!isEndGame(board)) {
      // Make the move on the chess board
      ChessBoard().makeMove(board, Move.fromUciString(MoveGenerator().generateMove(board)));

      // Switch the current player
      sleep(Duration(milliseconds: 250));
    }
  }

  bool isEndGame(List<List<Piece?>> board) {
    // Announce the winner or declare the game a draw
    if (isDraw(board)) {
      print('The game is a draw.');
      return true;
    } else if (isCheckmate(board, white)) {
      print('Black wins.');
      return true;
    } else if (isCheckmate(board, black)) {
      print('White wins.');
      return true;
    }
    return false;
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

  bool isCheckmate(List<List<Piece?>> board, PieceColor kingColor) {
    Piece king = findKing(board, kingColor);
    if (Engine().isCheck(board, kingColor)) {
      // Check if the king has any legal moves
      if (MoveGenerator().generateMoves(board, kingColor).isEmpty) {
        return true;
      }
    }
    return false;
  }

  bool isCheck(List<List<Piece?>> board, PieceColor kingColor) {
    // Find the square of the king of the given color.
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = board[i][j];
        if (piece != null && piece is King && piece.color == kingColor) {
          return SquareChecker().isSquareAttacked(board, i, j, kingColor == white ? black : white);
        }
      }
    }

    return false;
  }

  // Find the king of the given color on the board
  King findKing(List<List<Piece?>> board, PieceColor color) {
    King? king;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = board[i][j];
        if (piece != null && piece is King && piece.color == color) {
          king = piece;
          return piece;
        }
      }
    }
    return king!;
  }

  bool isFork(List<List<Piece?>> board, Move move, Piece piece) {
    // Make a copy of the board and apply the move
    List<List<Piece?>> newBoard = ChessBoard().deepCopyBoard(board);
    ChessBoard().makeMove(newBoard, move, isDeepCopy: true);

    // Find the squares that are attackable by the moving piece
    Set<String> attackableSquares = piece.getControl(newBoard);

    // Check if there are two or more pieces of the opponent's color in the attackable squares
    int count = 0;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (newBoard[i][j] != null && newBoard[i][j]?.color != piece.color && attackableSquares.contains(newSquareString(i, j))) {
          count++;
        }
      }
    }

    return count >= 2;
  }

  bool isDiscovery(List<List<Piece?>> board, Move move, PieceColor color) {
    // Check if the move creates a new attack on the enemy king
    List<List<Piece?>> newBoard = ChessBoard().deepCopyBoard(board);
    ChessBoard().makeMove(newBoard, move, isDeepCopy: true);
    return Engine().isCheck(newBoard, color == white ? black : white);
  }
}
