import 'dart:math';

import '../board.dart';
import '../engine.dart';
import '../move_generator.dart';
import '../utils/constants.dart';
import 'move.dart';
import 'piece.dart';

class MCTSNode {
  final List<List<Piece?>> board;
  final Set<Move> moves;
  final Map<Move, MCTSNode> children;
  int visits = 0;
  double value = 0;
  final double c = sqrt(2); // Tuning constant for UCB1 score

  MCTSNode(this.board, this.moves) : children = {};

  // Select a child node using UCB1
  MCTSNode select() {
    MCTSNode? bestNode;
    double bestScore = double.negativeInfinity;
    for (MCTSNode child in children.values) {
      double score = child.value / child.visits + c * sqrt(log(visits) / child.visits);
      if (score > bestScore) {
        bestScore = score;
        bestNode = child;
      }
    }
    return bestNode ?? MCTSNode(board, moves);
  }

  // Expand the node by adding its children to the tree
  void expand() {
    for (Move move in moves) {
      // Make the move on a copy of the board
      List<List<Piece?>> newBoard = ChessBoard().deepCopyBoard(board);
      ChessBoard().makeMove(newBoard, move, isDeepCopy: true);
      // Generate the legal moves for the new position
      Set<Move> newMoves = MoveGenerator().generateMoves(newBoard, activeColor);
      // Add the child node to the tree
      MCTSNode child = MCTSNode(newBoard, newMoves);
      children[move] = child;
    }
  }

  // Simulate the game from the current node
  double simulate() {
    // Make a copy of the board
    List<List<Piece?>> simulationBoard = ChessBoard().deepCopyBoard(board);
    simulationActiveColor = activeColor;
    // Simulate the game by randomly selecting moves until a terminal position is reached
    while (true) {
      Set<Move> simulationMoves = MoveGenerator().generateMoves(simulationBoard, simulationActiveColor);
      if (simulationMoves.isEmpty) {
        // The game is over
        if (Engine().isCheckmate(simulationBoard, simulationActiveColor == white ? black : white)) {
          // The active color is in checkmate, return -1 if it is the maximizing player or 1 if it is the minimizing player
          return simulationActiveColor == white ? -1 : 1;
        } else {
          // The game is a draw, return 0
          return 0;
        }
      }
      // Randomly select a move from the set of legal moves
      Move move = simulationMoves.elementAt(Random().nextInt(simulationMoves.length));
      ChessBoard().makeMove(simulationBoard, move, isDeepCopy: true);
      simulationActiveColor = simulationActiveColor == white ? black : white;
      if (Engine().isDraw(simulationBoard)) {
        return 0;
      }
    }
  }

  // Backpropagate the results of the simulation to the root node
  void backpropagate(double value) {
    visits++;
    this.value += value;
  }

  // Select the best move using MCTS
  Move mcts() {
    for (int i = 0; i < iteration; i++) {
      MCTSNode node = this;
      // Select a leaf node
      while (node.children.isNotEmpty) {
        node = node.select();
      }
      // Expand the leaf node
      node.expand();
      // Simulate the game from the leaf node
      double value = node.simulate();
      // Backpropagate the results of the simulation to the root node
      node.backpropagate(value);
    }
    // Return the best move in the root node
    return bestMove();
  }

  Move bestMove() {
    Move? bestMove;
    double bestValue = double.negativeInfinity;
    for (Move move in children.keys) {
      MCTSNode child = children[move]!;
      if (child.value > bestValue) {
        bestValue = child.value;
        bestMove = move;
      }
    }
    return bestMove ?? children.keys.first;
  }
}
