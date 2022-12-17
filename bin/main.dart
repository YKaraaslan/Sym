import 'package:sym/board.dart';
import 'package:sym/move_generator.dart';
import 'package:sym/opponent_moves.dart';
import 'package:sym/precomputed_move_data.dart';
import 'package:sym/preposition.dart';

void main(List<String> arguments) {
  loadPositionFromFen(Board.laterFEN);
  precomputedMoveData();
  getAttackedSquares();
  generateLegalMoves();
}
