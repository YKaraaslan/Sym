import 'engine.dart';
import 'models/bishop.dart';
import 'models/king.dart';
import 'models/knight.dart';
import 'models/move.dart';
import 'models/pawn.dart';
import 'models/piece.dart';
import 'models/queen.dart';
import 'models/rook.dart';
import 'move_generator.dart';
import 'utils/constants.dart';
import 'utils/enums.dart';
import 'utils/heatmaps.dart';

class SquareEvaluation {
  List<List<int>> createHeatMap(PieceColor color) {
    List<List<int>> heatMap = List.generate(8, (_) => List.generate(8, (index) => 0));

    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        heatMap[i][j] = _evaluateSquare(i, j);
      }
    }

    return heatMap;
  }

  int _evaluateSquare(int i, int j) {
    int evaluation = 0;

    // Material balance heuristic
    Piece? piece = board[i][j];
    if (piece != null) {
      evaluation += piece.value;

      // Piece mobility heuristic
      Set<Move> moves = MoveGenerator().generateMoves(board, piece.color);
      evaluation += moves.length;

      // King safety heuristic
      King king = Engine().findKing(board, piece.color);
      int distance = (i - king.x).abs() + (j - king.y).abs();
      evaluation -= distance;
    }

    // Pawn structure heuristic
    evaluation += _evaluatePawnStructure();

    // Tempo heuristic
    evaluation += _evaluateTempo();

    // Control of key squares heuristic
    if (i == 3 || i == 4) {
      if (j == 3 || j == 4) {
        evaluation += 1;
      }
    }
    if (i == 3 || i == 4) {
      if (j == 3 || j == 4) {
        evaluation += 1;
      }
    }

    // Piece development heuristic
    if (piece is Knight || piece is Bishop || piece is Rook || piece is Queen) {
      if (i > 0) {
        evaluation += 1;
      }
    }

    // Add the relative value of the square for the piece type
    if (piece is Pawn) {
      evaluation += HeatMaps.pawnHeatMap[i][j];
    } else if (piece is Knight) {
      evaluation += HeatMaps.knightHeatMap[i][j];
    } else if (piece is Bishop) {
      evaluation += HeatMaps.bishopHeatMap[i][j];
    } else if (piece is Rook) {
      evaluation += HeatMaps.rookHeatMap[i][j];
    } else if (piece is Queen) {
      evaluation += HeatMaps.queenHeatMap[i][j];
    } else if (piece is King) {
      evaluation += HeatMaps.kingHeatMap[i][j];
    }

    // Return the evaluation
    return evaluation;
  }

  int _evaluatePawnStructure() {
    int evaluation = 0;

    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = board[i][j];
        if (piece is Pawn && piece.color == activeColor) {
          // Check for isolated pawns
          if (i > 0 && i < 7 && board[i - 1][j] is! Pawn && board[i + 1][j] is! Pawn) {
            evaluation -= 10;
          }
          // Check for doubled pawns
          if (i > 0 && board[i - 1][j] is Pawn && board[i - 1][j]?.color == activeColor) {
            evaluation -= 5;
          }
          if (i < 7 && board[i + 1][j] is Pawn && board[i + 1][j]?.color == activeColor) {
            evaluation -= 5;
          }
          // Check for pawn chains
          if (i > 0 && board[i - 1][j] is Pawn && board[i - 1][j]?.color == activeColor) {
            evaluation += 2;
          }
          if (i < 7 && board[i + 1][j] is Pawn && board[i + 1][j]?.color == activeColor) {
            evaluation += 2;
          }
        }
      }
    }

    return evaluation;
  }

  int _evaluateTempo() {
    int evaluation = 0;

    // Calculate the relative amount of time for each player
    int whiteTime = 40 - whiteMoves;
    int blackTime = 40 - blackMoves;

    // Assign a value to each player based on their relative amount of time
    if (whiteTime > blackTime) {
      evaluation += (whiteTime - blackTime) * 10;
    } else if (blackTime > whiteTime) {
      evaluation -= (blackTime - whiteTime) * 10;
    }

    return evaluation;
  }
}
