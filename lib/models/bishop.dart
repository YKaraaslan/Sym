import 'package:sym/precomputed_mode_data.dart';

import '../utils/constants.dart';
import '../utils/enums.dart';
import 'move.dart';
import 'piece.dart';

class Bishop extends Piece {
  Bishop(int x, int y, PieceColor color, int value) : super(x, y, color, value);

  @override
  Set<Move> generateMoves(List<List<Piece?>> board) {
    Set<Move> moves = {};

    // Get the precomputed bishop moves for this square.
    List<int> bishopMoves = PrecomputedMoveData.bishopMoves[x * 8 + y];

    // Iterate through the precomputed moves.
    for (int move in bishopMoves) {
      int newRow = move ~/ 8;
      int newCol = move % 8;

      // Check if the destination square is empty or contains an opponent's piece.
      if (board[newRow][newCol] == null || board[newRow][newCol]?.color != color) {
        moves.add(Move(row: x, column: y, newRow: newRow, newColumn: newCol, fromSquare: squareName(x, y), toSquare: squareName(newRow, newCol)));
      }
    }

    return moves;
  }

  @override
  Bishop copy() {
    return Bishop(x, y, color, value);
  }

  @override
  String getSymbol() {
    return color == white ? 'B' : 'b';
  }

  @override
  Set<String> getControl(List<List<Piece?>> board) {
    Set<String> control = {};
    Set<Move> moves = generateMoves(board);
    for (Move move in moves) {
      control.add(move.toSquare);
    }
    return control;
  }
}
