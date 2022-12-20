import 'dart:math';

import 'package:sym/move_generator.dart';
import 'package:sym/position.dart';
import 'package:sym/utils/constants.dart';

import 'move.dart';
import 'piece.dart';

class Node {
  final List<List<Piece?>> board;
  final Set<Move> moves;
  final Move? move;
  final Node? parent;
  final Random _random = Random();
  final double c = 1.4; // Tuning constant for UCB1 score

  List<Node> children = [];
  int visits = 0;
  double winScore = 0;

  Node(this.board, this.moves, {this.move, this.parent});

  bool isLeaf() => children.isEmpty;
  bool isFullyExpanded() => moves.length == children.length;

  Node select() {
    // Select the child node with the highest UCB1 score
    Node? selected;
    double maxScore = double.negativeInfinity;
    for (Node child in children) {
      double score = child.winScore / child.visits + c * sqrt(2 * log(visits) / child.visits);
      if (score > maxScore) {
        selected = child;
        maxScore = score;
      }
    }
    return selected ?? Node(board, moves);
  }

  Node expand() {
    // Expand a random untried child node
    Set<Move> untried = moves.difference(children.toSet()); // moves.difference(children.map((child) => child.move));
    if (untried.isNotEmpty) {
      int index = _random.nextInt(untried.length);
      Move move = untried.elementAt(index);
      List<List<Piece?>> copy = MoveGenerator().deepCopyBoard(board);
      copy[move.newRow][move.newColumn] = copy[move.row][move.column];
      copy[move.row][move.column] = null;
      Node child = Node(copy, MoveGenerator().generateMoves(copy, activeColor), move: move, parent: this);
      children.add(child);
      return child;
    }
    return Node(board, moves);
  }

  double simulate() {
    var localIteration = iteration;
    // Simulate a random playout of the game to completion
    List<List<Piece?>> copy = MoveGenerator().deepCopyBoard(board);
    while (true) {
      Set<Move> moves = MoveGenerator().generateMoves(copy, activeColor);
      if (moves.isEmpty) {
        // Game is over, return the win score
        return Position().evaluatePosition(copy).toDouble();
      }
      int index = _random.nextInt(moves.length);
      Move move = moves.elementAt(index);
      copy[move.newRow][move.newColumn] = copy[move.row][move.column];
      copy[move.row][move.column] = null;
      localIteration--;
      if (localIteration <= 0) {
        return Position().evaluatePosition(copy).toDouble();
      }
    }
  }

  double evaluate() {
    // Compute the score based on the material balance and position of the pieces
    double score = 0;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = board[i][j];
        if (piece != null) {
          score += piece.color == white ? piece.value : -piece.value;
        }
      }
    }
    return score;
  }

  void backpropagate(double result) {
    // Update the win score and visit count for the node and its ancestors
    visits++;
    winScore += result;
    if (parent != null) {
      parent?.backpropagate(result);
    }
  }
}
