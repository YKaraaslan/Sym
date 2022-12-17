import 'package:sym/board.dart';
import 'package:sym/my_moves.dart';
import 'package:sym/opponent_moves.dart';
import 'package:sym/precomputed_move_data.dart';
import 'package:sym/preposition.dart';

void main(List<String> arguments) {
  PrePosition().loadPositionFromFen(Board.laterFEN);
  PrecomputedMoveData().precomputedMoveData();
  OpponentMoves().getSquares();
  MyMoves().generateLegalMoves();
}
