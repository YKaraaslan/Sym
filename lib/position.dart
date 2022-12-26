import 'engine.dart';
import 'models/king.dart';
import 'models/move.dart';
import 'models/pawn.dart';
import 'models/piece.dart';
import 'move_generator.dart';
import 'utils/constants.dart';

class Position {
  double evaluation = 0;

  // Calculate the material value for each color
  double whiteMaterialValue = 0;
  double blackMaterialValue = 0;

  // Calculate the development for each color
  double whiteDevelopment = 0;
  double blackDevelopment = 0;

  // Calculate the pawn structure for each color
  double whitePawnStructure = 0;
  double blackPawnStructure = 0;

  // Calculate the king safety for each color
  double whiteKingSafety = 0;
  double blackKingSafety = 0;

  // Calculate control of the center
  double whiteCenterControl = 0;
  double blackCenterControl = 0;

  // Calculate piece coordination
  double whitePieceCoordination = 0;
  double blackPieceCoordination = 0;

  // Calculate piece activity
  double whitePieceActivity = 0;
  double blackPieceActivity = 0;

  double evaluatePosition(List<List<Piece?>> board) {
    // Check if the current player is in checkmate
    if (Engine().isCheckmate(board, white)) {
      // Give a very high score to positions where the current player is in checkmate
      return double.negativeInfinity;
    } else if (Engine().isCheckmate(board, black)) {
      // Give a very high score to positions where the current player is in checkmate
      return double.infinity;
    }

    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = board[i][j];
        if (piece != null) {
          // Calculate the material value for each color
          _materialValue(piece);

          // Calculate the development for each color
          _development(piece);

          // Calculate the king safety for each color and determine the square of the white king
          _kingSafety(piece, i, j);

          // Calculate piece coordination and piece activity
          _pieceCoordination(piece);

          // Calculate the pawn structure for each color
          _pawnStructure(piece, i, j);

          // Calculate control of the center
          _centerControl(piece, i, j);

          // Calculate if the piece is in danger
          _isPieceInDanger(piece, i, j);
        }
      }
    }

    evaluation += whiteMaterialValue - blackMaterialValue;
    evaluation += whiteDevelopment - blackDevelopment;
    evaluation += whitePawnStructure - blackPawnStructure;
    evaluation += whiteKingSafety - blackKingSafety;
    evaluation += whiteCenterControl - blackCenterControl;
    evaluation += whitePieceCoordination - blackPieceCoordination;
    evaluation += whitePieceActivity - blackPieceActivity;

    // Calculate the mobility for each color
    int whiteMobility = MoveGenerator().generateMoves(board, white).length;
    int blackMobility = MoveGenerator().generateMoves(board, black).length;
    evaluation += whiteMobility - blackMobility;

    // Bonus for first move
    if (activeColor == white) {
      evaluation += 10;
    } else {
      evaluation -= 10;
    }

    // Return the evaluation for the active color
    return evaluation;
  }

  void _materialValue(Piece piece) {
    if (piece.color == white) {
      whiteMaterialValue += piece.value;
    } else if (piece.color == black) {
      blackMaterialValue += piece.value;
    }
  }

  void _development(Piece piece) {
    // Count the number of moved pieces for each color
    if (piece.hasMoved) {
      if (piece.color == white) {
        whiteDevelopment++;
      } else if (piece.color == black) {
        blackDevelopment++;
      }
    }
  }

  void _kingSafety(Piece piece, int i, int j) {
    if (piece is King && piece.color == white) {
      for (int k = -1; k <= 1; k++) {
        for (int l = -1; l <= 1; l++) {
          if (k == 0 && l == 0) {
            continue;
          }
          if (i + k >= 0 && i + k < 8 && j + l >= 0 && j + l < 8) {
            if (board[i + k][j + l] != null && board[i + k][j + l]?.color == black) {
              whiteKingSafety -= 1;
            }
          }
        }
      }
    } else if (piece is King && piece.color == black) {
      for (int k = -1; k <= 1; k++) {
        for (int l = -1; l <= 1; l++) {
          if (k == 0 && l == 0) {
            continue;
          }
          if (i + k >= 0 && i + k < 8 && j + l >= 0 && j + l < 8) {
            if (board[i + k][j + l] != null && board[i + k][j + l]?.color == white) {
              blackKingSafety -= 1;
            }
          }
        }
      }
    }
  }

  void _pieceCoordination(Piece piece) {
    if (piece.color == white) {
      // Generate the moves for the piece
      Set<Move> moves = piece.generateMoves(board);
      // Calculate piece activity
      whitePieceActivity += moves.length;
      // Count the number of attacks on enemy pieces
      for (Move move in moves) {
        Piece? target = board[move.newRow][move.newColumn];
        if (target != null && target.color != piece.color) {
          whitePieceCoordination++;
        }
      }
    } else if (piece.color == black) {
      // Generate the moves for the piece
      Set<Move> moves = piece.generateMoves(board);
      // Calculate piece activity
      blackPieceActivity += moves.length;
      // Count the number of attacks on enemy pieces
      for (Move move in moves) {
        Piece? target = board[move.newRow][move.newColumn];
        if (target != null && target.color != piece.color) {
          blackPieceCoordination++;
        }
      }
    }
  }

  void _pawnStructure(Piece piece, int i, int j) {
    if (piece is Pawn) {
      // Check for pawn chains and isolated pawns
      bool hasFriendlyPawnOnLeft = j > 0 && board[i][j - 1] is Pawn && board[i][j - 1]!.color == piece.color;
      bool hasFriendlyPawnOnRight = j < 7 && board[i][j + 1] is Pawn && board[i][j + 1]!.color == piece.color;
      if (hasFriendlyPawnOnLeft || hasFriendlyPawnOnRight) {
        if (piece.color == white) {
          whitePawnStructure++;
        } else if (piece.color == black) {
          blackPawnStructure++;
        }
      } else if (!hasFriendlyPawnOnLeft && !hasFriendlyPawnOnRight) {
        if (piece.color == white) {
          whitePawnStructure--;
        } else if (piece.color == black) {
          blackPawnStructure--;
        }
      }
    }
  }

  void _centerControl(Piece piece, int i, int j) {
    if ((i == 3 || i == 4) && (j == 3 || j == 4)) {
      if (piece.color == white) {
        whiteCenterControl += 1;
      }
      if (piece.color == black) {
        blackCenterControl += 1;
      }
    }
  }

  void _isPieceInDanger(Piece piece, int i, int j) {
    // Calculate the number of attacking pieces
    int attackingPieces = 0;
    for (int k = -1; k <= 1; k++) {
      for (int l = -1; l <= 1; l++) {
        if (i + k < 0 || i + k > 7 || j + l < 0 || j + l > 7) {
          continue;
        }
        Piece? attackingPiece = board[i + k][j + l];
        if (attackingPiece != null && attackingPiece.color != piece.color) {
          attackingPieces += 1;
        }
      }
    }

    // Calculate the number of defending pieces
    double defendingPieces = 0;
    for (int k = -1; k <= 1; k++) {
      for (int l = -1; l <= 1; l++) {
        if (i + k < 0 || i + k > 7 || j + l < 0 || j + l > 7) {
          continue;
        }
        Piece? defendingPiece = board[i + k][j + l];
        if (defendingPiece != null && defendingPiece.color == piece.color) {
          defendingPieces += 1;
        }
      }
    }

    // Adjust the evaluation based on the safety of the piece
    if (defendingPieces > attackingPieces) {
      // Piece is well defended
      if (piece.color == white) {
        evaluation += 1;
      } else {
        evaluation -= 1;
      }
    } else if (attackingPieces > defendingPieces) {
      // Piece is in danger
      if (piece.color == white) {
        evaluation -= 1;
      } else {
        evaluation += 1;
      }
    }
  }
}
