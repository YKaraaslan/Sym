class PrecomputedMoveData {
  // These lists will store the possible moves for each piece in each square.
  static final List<List<List<int>>> pawnMoves = [
    whitePawnMoves,
    blackPawnMoves,
  ];
  static final List<List<int>> whitePawnMoves = List.generate(64, (_) => List.empty(growable: true));
  static final List<List<int>> blackPawnMoves = List.generate(64, (_) => List.empty(growable: true));
  static final List<List<int>> knightMoves = List.generate(64, (_) => List.empty(growable: true));
  static final List<List<int>> bishopMoves = List.generate(64, (_) => List.empty(growable: true));
  static final List<List<int>> rookMoves = List.generate(64, (_) => List.empty(growable: true));
  static final List<List<int>> queenMoves = List.generate(64, (_) => List.empty(growable: true));
  static final List<List<int>> kingMoves = List.generate(64, (_) => List.empty(growable: true));

  // These lists will store the move offsets for each piece.
  List<List<int>> whitePawnMoveOffsets = [
    [1, 0],
    [2, 0],
    [1, -1],
    [1, 1]
  ];
  List<List<int>> blackPawnMoveOffsets = [
    [-1, 0],
    [-2, 0],
    [-1, -1],
    [-1, 1]
  ];
  List<List<int>> knightMoveOffsets = [
    [-2, -1],
    [-2, 1],
    [-1, -2],
    [-1, 2],
    [1, -2],
    [1, 2],
    [2, -1],
    [2, 1]
  ];
  List<List<int>> bishopMoveOffsets = [
    [-1, -1],
    [-1, 1],
    [1, -1],
    [1, 1]
  ];
  List<List<int>> rookMoveOffsets = [
    [0, -1],
    [0, 1],
    [-1, 0],
    [1, 0]
  ];
  List<List<int>> queenMoveOffsets = [
    [-1, -1],
    [-1, 1],
    [1, -1],
    [1, 1],
    [0, -1],
    [0, 1],
    [-1, 0],
    [1, 0]
  ];
  List<List<int>> kingMoveOffsets = [
    [0, -1],
    [0, 1],
    [-1, 0],
    [1, 0],
    [-1, -1],
    [-1, 1],
    [1, -1],
    [1, 1]
  ];

  void calculate() {
    // Calculate the possible moves for each piece in each square and store them in the appropriate list.
    for (int i = 0; i < 64; i++) {
      int row = i ~/ 8;
      int col = i % 8;

      // Calculate pawn moves.
      whitePawnMoves[i].addAll(_calculatePawnMoves(row, col, true)); // for white pawns
      blackPawnMoves[i].addAll(_calculatePawnMoves(row, col, false)); // for black pawns

      // Calculate knight moves.
      knightMoves[i].addAll(_calculateMoves(knightMoveOffsets, row, col));

      // Calculate bishop moves.
      bishopMoves[i].addAll(_calculateMoves(bishopMoveOffsets, row, col));

      // Calculate rook moves.
      rookMoves[i].addAll(_calculateMoves(rookMoveOffsets, row, col));

      // Calculate queen moves.
      queenMoves[i].addAll(_calculateMoves(queenMoveOffsets, row, col));

      // Calculate king moves.
      kingMoves[i].addAll(_calculateMoves(kingMoveOffsets, row, col));
    }
  }

  // Calculate the possible moves for a pawn at the given row and column.
  List<int> _calculatePawnMoves(int row, int col, bool isWhite) {
    List<int> moves = [];

    // Pawns can move forward one square.
    int forwardRow = isWhite ? row - 1 : row + 1;
    if (forwardRow >= 0 && forwardRow < 8) {
      moves.add((forwardRow * 8) + (row * 8) + col);
    }

    // Pawns can also move forward two squares on their first move.
    int firstMoveRow = isWhite ? 6 : 1;
    if (row == firstMoveRow) {
      int forward2Row = isWhite ? row - 2 : row + 2;
      if (forward2Row >= 0 && forward2Row < 8) {
        moves.add(forward2Row * 8 + col);
      }
    }

    // Pawns can capture diagonally.
    int captureRow = isWhite ? row - 1 : row + 1;
    int captureCol = col - 1;
    if (captureRow >= 0 && captureRow < 8 && captureCol >= 0 && captureCol < 8) {
      moves.add(captureRow * 8 + captureCol);
    }
    captureCol = col + 1;
    if (captureRow >= 0 && captureRow < 8 && captureCol >= 0 && captureCol < 8) {
      moves.add(captureRow * 8 + captureCol);
    }

    return moves;
  }

  // Calculate the possible moves for a king at the given row and column.
  List<int> _calculateMoves(List<List<int>> offsets, int row, int col) {
    List<int> moves = [];

    // Kings can move to any of the squares adjacent to their current position.
    for (List<int> offset in offsets) {
      int newRow = row + offset[0];
      int newCol = col + offset[1];
      if (newRow >= 0 && newRow < 8 && newCol >= 0 && newCol < 8) {
        moves.add(newRow * 8 + newCol);
      }
    }

    return moves;
  }
}
