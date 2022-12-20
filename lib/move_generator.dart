import 'dart:math';

import 'package:sym/board.dart';
import 'package:sym/square_evaluation.dart';

import 'engine.dart';
import 'models/king.dart';
import 'models/move.dart';
import 'models/node.dart';
import 'models/piece.dart';
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

    var heatMap = SquareEvaluation().createHeatMap(activeColor);
    var moveList = moves.toList();
    moveList.sort((a, b) =>
        heatMap[b.newRow][b.newColumn] - heatMap[a.newRow][a.newColumn]);
    moves = moveList.toSet();
    // Choose a move using some strategy, such as minimax with alpha-beta pruning
    Move move = chooseMove(board, moves);
    return move.toUciString();
  }

  Move chooseMove(List<List<Piece?>> board, Set<Move> moves) {
    // Create a root node for the MCTS tree
    Node root = Node(board, moves);

    mcts(root);

    // Use minimax with alpha-beta pruning to evaluate the strength of each move
    Move? bestMove;
    double maxScore = double.negativeInfinity;
    for (Node child in root.children) {
      double score = minimax(child,
          depth: iteration,
          alpha: double.negativeInfinity,
          beta: double.infinity,
          maximizingPlayer: false);
      if (score > maxScore) {
        bestMove = child.move;
        maxScore = score;
      }
    }

    // If no move was found, choose a random move
    return bestMove ?? moves.elementAt(Random().nextInt(moves.length));
  }

  void mcts(Node root) {
    for (int i = 0; i < iteration; i++) {
      // Selection
      Node current = root;
      while (!current.isLeaf()) {
        current = current.select();
      }

      // Expansion
      if (!current.isFullyExpanded()) {
        current = current.expand();
      }

      // Simulation
      double result = current.simulate();

      // Backpropagation
      current.backpropagate(result);
    }
  }

  double minimax(Node node,
      {int depth = 4,
      double alpha = double.negativeInfinity,
      double beta = double.infinity,
      bool maximizingPlayer = true}) {
    // Check if the node is a leaf or the depth limit has been reached
    if (node.isLeaf() || depth == 0) {
      return node.evaluate();
    }

    if (maximizingPlayer) {
      // Maximizing player: find the maximum score
      double value = double.negativeInfinity;
      for (Node child in node.children) {
        value = max(
            value,
            minimax(child,
                depth: depth - 1,
                alpha: alpha,
                beta: beta,
                maximizingPlayer: false));
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
      for (Node child in node.children) {
        value = min(
            value,
            minimax(child,
                depth: depth - 1,
                alpha: alpha,
                beta: beta,
                maximizingPlayer: true));
        beta = min(beta, value);
        if (beta <= alpha) {
          // Prune the remaining branches
          break;
        }
      }
      return value;
    }
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
        if (piece != null && piece.color == color) {
          // Generate a list of valid moves for the current piece
          Set<Move> validMoves = piece.generateMoves(board);

          // Filter the list of moves to only include legal moves
          validMoves = filterMoves(board, validMoves, color);

          // Add the legal moves to the set of all moves
          moves.addAll(validMoves);
        }
      }
    }

    return moves;
  }

  Set<Move> filterMoves(
      List<List<Piece?>> board, Set<Move> moves, PieceColor activeColor) {
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
