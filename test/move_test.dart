import 'package:sym/board.dart';
import 'package:sym/move_generator.dart';
import 'package:sym/utils/constants.dart';
import 'package:test/test.dart';

void main() {
  ChessBoard chessBoard = ChessBoard();
  MoveGenerator moveGenerator = MoveGenerator();

  group('bishop', () {
    test('move', () {
      chessBoard = ChessBoard();
      chessBoard.loadPositionFromFen('r1b2knr/pp1nb2p/2p1p2p/3p1p2/qP3P2/2PPP1PB/4Q2P/1N2K1NR w K - 0 2');
      var moves = moveGenerator.generateMove(board);
      expect(moves, isNotEmpty);
    });
  });
}
