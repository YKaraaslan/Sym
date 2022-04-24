import 'board.dart';
import 'piece.dart';
import 'precomputed_move_data.dart';

void getMoves(int square) {
  var res = Board.square[square];

  if (Piece.isQueen(res)) {
    generateLegalMoves(queenMoves[square]);
  } else if (Piece.isRook(res)) {
    print(rookMoves[square]);
  } else if (Piece.isKnight(res)) {
    print(knightMoves[square]);
  } else if (Piece.isBishop(res)) {
    print(bishopMoves[square]);
  } else if (Piece.isPawn(res)) {
    //pawn
  } else if (Piece.isKing(res)) {
    print(kingMoves[square]);
  }
}

void generateLegalMoves(List<int> pieceMoves) {
  for (var move in pieceMoves) {
    if (Board.square[move] == 0) {}
  }
}
