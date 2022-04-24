import 'move_generator.dart';
import 'opponent_moves.dart';
import 'precomputed_move_data.dart';
import 'preposition.dart';

void main(List<String> arguments) {
  Preposition preposition = Preposition();
  preposition.init();
  precomputedMoveData();
  getAttackedSquares();
  generateMoves();
  //getMoves(3);
}


// [17, 42, 26, 27, 29, 51, 59, 35, 41, 40, 44, 45, 52, 61, 34, 25, 37, 39, 47, 57, 30, 23]