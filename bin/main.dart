import 'opponent_moves.dart';
import 'precomputed_move_data.dart';
import 'preposition.dart';

void main(List<String> arguments) {
  Preposition preposition = Preposition();
  preposition.init();
  precomputedMoveData();
  getAttackedSquares();
  //getMoves(3);
}
