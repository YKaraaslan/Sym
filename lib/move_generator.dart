import 'dart:math';

import 'package:sym/board.dart';

import 'engine.dart';
import 'models/king.dart';
import 'models/move.dart';
import 'models/piece.dart';
import 'position.dart';
import 'utils/constants.dart';
import 'utils/enums.dart';

class MoveGenerator {
  MoveGenerator._privateConstructor();
  static final MoveGenerator _instance = MoveGenerator._privateConstructor();
  factory MoveGenerator() {
    return _instance;
  }

  String generateMove(List<List<Piece?>> board) {
    // Generate a list of legal moves for the active color
    Set<Move> moves = generateMoves(board, activeColor);

    // Choose a move using some strategy, such as minimax with alpha-beta pruning
    Move move = chooseMove(board, moves);

    return move.toUciString();
  }

  Move chooseMove(List<List<Piece?>> board, Set<Move> moves) {
    int bestValue = -9999;
    Move? bestMove;

    for (Move move in moves) {
      // Make a copy of the board and perform the move
      List<List<Piece?>> copy = deepCopyBoard(board);
      copy[move.newRow][move.newColumn] = copy[move.row][move.column];
      copy[move.row][move.column] = null;

      // Evaluate the position using the evaluatePosition function
      int value = Position().evaluatePosition(copy);
      if (value > bestValue) {
        bestValue = value;
        bestMove = move;
      }
    }

    return bestMove!;
  }

  int minimax(List<List<Piece?>> board, int depth, int alpha, int beta, PieceColor color) {
    // Check if the depth limit has been reached or the game is in an end state
    if (depth == 0 || isEndGame(board)) {
      return Position().evaluatePosition(board);
    }

    // Initialize the best value based on the player's color
    int bestValue = (color == white) ? minValue : maxValue;

    // Generate a list of all legal moves for the current player
    Set<Move> moves = generateMoves(board, color);

    // Iterate over the list of moves
    for (Move move in moves) {
      // Make the move on a copy of the board
      List<List<Piece?>> copy = deepCopyBoard(board);
      copy[move.newRow][move.newColumn] = copy[move.row][move.column];
      copy[move.row][move.column] = null;

      // Recursively call the minimax function on the copy of the board
      int value = minimax(copy, depth - 1, alpha, beta, color == white ? black : white);

      // Update the best value based on the value returned from the recursive call
      if (color == white) {
        bestValue = max(bestValue, value);
        alpha = max(alpha, value);
      } else {
        bestValue = min(bestValue, value);
        beta = min(beta, value);
      }

      // If alpha-beta pruning is enabled, check if the current value exceeds beta for the minimizing player
      // or is less than alpha for the maximizing player. If so, return the best value found so far and exit the loop.
      if (alpha >= beta) {
        break;
      }
    }

    return bestValue;
  }

  PieceColor oppositecolor(PieceColor color) {
    return color == white ? black : white;
  }

  bool isEndGame(List<List<Piece?>> board) {
    // Check if the king of the active color is in check
    // int kingX, kingY;
    PieceColor kingcolor = activeColor;
    bool kingFound = false;
    List<String> positionsSeen = [];
    int positionsSeenCount = 0;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] is King && board[i][j]?.color == kingcolor) {
          // kingX = i;
          // kingY = j;
          kingFound = true;
          break;
        }
      }
      if (kingFound) {
        break;
      }
    }
    if (Engine().isCheck(board, kingcolor)) {
      // Check if the king has any legal moves
      Set<Move> moves = generateMoves(board, kingcolor);
      if (moves.isEmpty) {
        return true;
      }
    }

    // Check for the threefold repetition rule
    List<String> positions = [];
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] != null) {
          positions.add(board[i][j].toString());
        } else {
          positions.add('');
        }
      }
    }
    String positionString = positions.join();
    if (positionsSeen.contains(positionString)) {
      positionsSeenCount++;
    } else {
      positionsSeen.add(positionString);
      positionsSeenCount = 1;
    }
    if (positionsSeenCount >= 3) {
      return true;
    }

    // Check for the fifty-move rule
    if (halfMoveClock >= 50) {
      return true;
    }

    // The game is not over
    return false;
  }

  Set<Move> generateMoves(List<List<Piece?>> board, PieceColor color) {
    Set<Move> moves = {};

    // Iterate over the board and generate moves for each piece
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = board[i][j];
        if (piece?.color == color) {
          // Generate a list of valid moves for the current piece
          Set<Move> validMoves = piece!.generateMoves(board);

          // Filter the list of moves to only include legal moves
          validMoves = filterMoves(board, validMoves, color);

          // Add the legal moves to the set of all moves
          moves.addAll(validMoves);
        }
      }
    }

    return moves;
  }

  Set<Move> filterMoves(List<List<Piece?>> board, Set<Move> moves, PieceColor activeColor) {
    Set<Move> validMoves = {};

    for (Move move in moves.toList()) {
      // Make a copy of the board and try making the move.
      List<List<Piece?>> newBoard = deepCopyBoard(board);
      ChessBoard().makeMoveForBoard(newBoard, move.toUciString());

      // If the king is not in check on the new board, add the move to the list of legal moves.
      if (!Engine().isCheck(newBoard, activeColor)) {
        validMoves.add(move);
      }
    }

    return validMoves;
  }

  List<List<Piece?>> deepCopyBoard(List<List<Piece?>> board) {
    List<List<Piece?>> copy = [];
    for (int i = 0; i < 8; i++) {
      copy.add([]);
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == null) {
          copy[i].add(null);
        } else {
          copy[i].add(board[i][j]?.copy());
        }
      }
    }
    return copy;
  }
}
