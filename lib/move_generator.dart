import 'dart:math';

import 'package:sym/position.dart';

import 'board.dart';
import 'engine.dart';
import 'models/move.dart';
import 'models/piece.dart';
import 'square_evaluation.dart';
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
    var heatMap = SquareEvaluation().createHeatMap(board, activeColor);
    var moveList = moves.toList();
    moveList.sort((a, b) => heatMap[b.newRow][b.newColumn] - heatMap[a.newRow][a.newColumn]);
    moves = moveList.toSet();
    // Choose a move using some strategy, such as minimax with alpha-beta pruning
    Move move = chooseMove(board, moves);
    return move.toUciString();
  }

  Move chooseMove(List<List<Piece?>> board, Set<Move> moves) {
    // Set up the initial values for alpha and beta
    double alpha = double.negativeInfinity;
    double beta = double.infinity;

    // Set up the initial best move to the first move in the list
    Move bestMove = moves.first;

    // Set up the maximizing player flag
    bool maximizingPlayer = activeColor == white;

    // Iterate through the moves and select the best one using minimax
    for (Move move in moves) {
      // Make the move on a copy of the board
      List<List<Piece?>> newBoard = ChessBoard().deepCopyBoard(board);
      ChessBoard().makeMove(newBoard, move, isDeepCopy: true);
      Map<List<List<Piece?>>, double> transTable = {};
      // Evaluate the move using minimax
      double value = minimax(newBoard, alpha: alpha, beta: beta, maximizingPlayer: !maximizingPlayer, transTable: transTable);
      // Undo move
      ChessBoard().undoMove(newBoard, move, isDeepCopy: true);
      // Update the best move and alpha/beta values if necessary
      if (maximizingPlayer && value > alpha) {
        alpha = value;
        bestMove = move;
      } else if (!maximizingPlayer && value < beta) {
        beta = value;
        bestMove = move;
      }
    }
    // Return the best move
    return bestMove;
  }

  int i = 0;

  double minimax(List<List<Piece?>> board,
      {int depth = 3, double alpha = double.negativeInfinity, double beta = double.infinity, required bool maximizingPlayer, required Map<List<List<Piece?>>, double> transTable}) {
    // Check if the node is a leaf or the depth limit has been reached
    if (depth == 0 || Engine().isEndGame(board)) {
      return Position().evaluatePosition(board, activeColor);
    }

    // Check if the position has been evaluated before
    if (transTable.containsKey(board)) {
      return transTable[board]!;
    }

    // Generate a list of legal moves for the current player
    Set<Move> moves = generateMoves(board, maximizingPlayer ? white : black);

    if (maximizingPlayer) {
      // Maximizing player: find the maximum score
      double value = double.negativeInfinity;
      for (Move move in moves) {
        // Make the move on a copy of the board
        List<List<Piece?>> newBoard = ChessBoard().deepCopyBoard(board);
        ChessBoard().makeMove(newBoard, move, isDeepCopy: true);
        i++;

        // Evaluate the position after making the move
        double score = Position().evaluatePosition(newBoard, white);
        // Check if the move leads to checkmate
        if (score == double.infinity) {
          return score;
        }
        // Recursively evaluate the move using minimax
        value = max(value, minimax(newBoard, depth: depth - 1, alpha: alpha, beta: beta, maximizingPlayer: false, transTable: transTable));
        alpha = max(alpha, value);
        if (beta <= alpha) {
          // Prune the remaining branches
          break;
        }
      }
      return value;
    } else {
      // Minimizing player: find the minimum score
      double value = double.infinity;
      for (Move move in moves) {
        // Make the move on a copy of the board
        List<List<Piece?>> newBoard = ChessBoard().deepCopyBoard(board);
        ChessBoard().makeMove(newBoard, move, isDeepCopy: true);

        // Evaluate the position after making the move
        double score = Position().evaluatePosition(newBoard, black);
        // Check if the move leads to checkmate
        if (score == double.negativeInfinity) {
          return score;
        }
        // Recursively evaluate the move using minimax
        value = min(value, minimax(newBoard, depth: depth - 1, alpha: alpha, beta: beta, maximizingPlayer: true, transTable: transTable));
        beta = min(beta, value);
        if (beta <= alpha) {
          // Prune the remaining branches
          break;
        }
      }
      return value;
    }
  }

  Set<Move> generateMoves(List<List<Piece?>> board, PieceColor color) {
    Set<Move> moves = {};
    Set<Move> validMoves = {};

    // Iterate over the board and generate moves for each piece
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = board[i][j];
        if (piece != null && piece.color == color) {
          // Generate a list of valid moves for the current piece
          Set<Move> pieceMoves = piece.generateMoves(board);

          // Search for captures
          Set<Move> captureMoves = pieceMoves.where((move) => board[move.newRow][move.newColumn]?.color != color).toSet();
          moves.addAll(captureMoves);

          // Search for forks
          Set<Move> forkMoves = pieceMoves.where((move) => Engine().isFork(board, move, piece)).toSet();
          moves.addAll(forkMoves);

          // Search for discoveries
          Set<Move> discoveryMoves = pieceMoves.where((move) => Engine().isDiscovery(board, move, color)).toSet();
          moves.addAll(discoveryMoves);

          // Rest of the moves
          moves.addAll(pieceMoves);

          // Only add the move if it doesn't put the king in check
          for (var move in pieceMoves) {
            // If the king is not in check on the new board, add the move to the list of legal moves.
            if (!movePutsKingInCheck(board, move, color)) {
              validMoves.add(move);
            }
          }
        }
      }
    }

    return validMoves;
  }

  bool movePutsKingInCheck(List<List<Piece?>> board, Move move, PieceColor color) {
    // Make the move on a copy of the board
    var newBoard = ChessBoard().deepCopyBoard(board);
    ChessBoard().makeMove(newBoard, move, isDeepCopy: true);

    // Check if the king is in check on the new board
    return Engine().isCheck(newBoard, color);
  }
}
