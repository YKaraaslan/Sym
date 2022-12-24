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

class Position {
  int evaluatePosition(List<List<Piece?>> board) {
    int evaluation = 0;

    // Calculate the material value for each color
    int whiteMaterialValue = 0;
    int blackMaterialValue = 0;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = board[i][j];
        if (piece != null && piece.color == white) {
          if (piece is Pawn) {
            whiteMaterialValue += 100;
          }
          if (piece is Knight) {
            whiteMaterialValue += 320;
          }
          if (piece is Bishop) {
            whiteMaterialValue += 330;
          }
          if (piece is Rook) {
            whiteMaterialValue += 500;
          }
          if (piece is Queen) {
            whiteMaterialValue += 900;
          }
        }
        if (piece != null && piece.color == black) {
          if (piece is Pawn) {
            blackMaterialValue += 100;
          }
          if (piece is Knight) {
            blackMaterialValue += 320;
          }
          if (piece is Bishop) {
            blackMaterialValue += 330;
          }
          if (piece is Rook) {
            blackMaterialValue += 500;
          }
          if (piece is Queen) {
            blackMaterialValue += 900;
          }
        }
      }
    }
    evaluation += whiteMaterialValue - blackMaterialValue;

    // Calculate the material balance for each color
    int whiteMaterial = 0;
    int blackMaterial = 0;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = board[i][j];
        if (piece != null) {
          if (piece.color == white) {
            whiteMaterial += piece.value;
          } else {
            blackMaterial += piece.value;
          }
        }
      }
    }
    evaluation += whiteMaterial - blackMaterial;

    // Calculate the mobility for each color
    int whiteMobility = 0;
    int blackMobility = 0;
    Set<Move> whiteMoves = MoveGenerator().generateMoves(board, white);
    Set<Move> blackMoves = MoveGenerator().generateMoves(board, black);
    whiteMobility = whiteMoves.length;
    blackMobility = blackMoves.length;

    // Calculate the development for each color
    int whiteDevelopment = 0;
    int blackDevelopment = 0;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = board[i][j];
        if (piece != null && piece.color == white) {
          if (piece is Pawn) {
            if (i > 0) {
              whiteDevelopment += 1;
            }
          } else {
            whiteDevelopment += 1;
          }
        }
        if (piece != null && piece.color == black) {
          if (piece is Pawn) {
            if (i < 7) {
              blackDevelopment += 1;
            }
          } else {
            blackDevelopment += 1;
          }
        }
      }
    }
    evaluation += whiteDevelopment - blackDevelopment;
    evaluation += whiteMobility - blackMobility;

    // Calculate the pawn structure for each color
    int whitePawnStructure = 0;
    int blackPawnStructure = 0;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = board[i][j];
        if (piece != null && piece is Pawn) {
          bool isolated = true;
          bool backward = false;
          for (int k = -1; k <= 1; k++) {
            if (i + k < 0 || i + k > 7) {
              continue;
            }
            if (board[i + k][j] is Pawn) {
              isolated = false;
              break;
            }
          }
          if (isolated) {
            if (piece.color == white) {
              whitePawnStructure -= 1;
            } else {
              blackPawnStructure -= 1;
            }
          }
          if (j > 0 && board[i][j - 1] is Pawn && board[i][j - 1]?.color == piece.color) {
            if (piece.color == white) {
              if (i > 0) {
                backward = true;
              }
            } else {
              if (i < 7) {
                backward = true;
              }
            }
          }
          if (j < 7 && board[i][j + 1] is Pawn && board[i][j + 1]?.color == piece.color) {
            if (piece.color == white) {
              if (i > 0) {
                backward = true;
              }
            } else {
              if (i < 7) {
                backward = true;
              }
            }
          }
          if (backward) {
            if (piece.color == white) {
              whitePawnStructure -= 1;
            } else {
              blackPawnStructure -= 1;
            }
          }
        }
      }
    }
    evaluation += whitePawnStructure - blackPawnStructure;

    // Calculate the king safety for each color
    int whiteKingSafety = 0;
    int blackKingSafety = 0;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = board[i][j];
        if (piece != null && piece.color == white) {
          if (piece is King) {
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
          }
        }
        if (piece != null && piece.color == black) {
          if (piece is King) {
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
      }
    }
    evaluation += whiteKingSafety - blackKingSafety;

    // Calculate control of the center
    int whiteCenterControl = 0;
    int blackCenterControl = 0;
    for (int i = 3; i <= 4; i++) {
      for (int j = 3; j <= 4; j++) {
        Piece? piece = board[i][j];
        if (piece != null && piece.color == white) {
          whiteCenterControl += 1;
        }
        if (piece != null && piece.color == black) {
          blackCenterControl += 1;
        }
      }
    }
    evaluation += whiteCenterControl - blackCenterControl;

    // Calculate piece coordination
    int whitePieceCoordination = 0;
    int blackPieceCoordination = 0;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = board[i][j];
        if (piece != null && piece.color == white) {
          if (piece is Knight || piece is Bishop) {
            whitePieceCoordination += 1;
          }
          if (piece is Rook || piece is Queen) {
            whitePieceCoordination += 2;
          }
        }
        if (piece != null && piece.color == black) {
          if (piece is Knight || piece is Bishop) {
            blackPieceCoordination += 1;
          }
          if (piece is Rook || piece is Queen) {
            blackPieceCoordination += 2;
          }
        }
      }
    }
    evaluation += whitePieceCoordination - blackPieceCoordination;

    // Calculate piece activity
    int whitePieceActivity = 0;
    int blackPieceActivity = 0;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = board[i][j];
        if (piece != null && piece.color == white) {
          Set<Move> moves = piece.generateMoves(board);
          whitePieceActivity += moves.length;
        }
        if (piece != null && piece.color == black) {
          Set<Move> moves = piece.generateMoves(board);
          blackPieceActivity += moves.length;
        }
      }
    }
    evaluation += whitePieceActivity - blackPieceActivity;

    // Calculate space
    int whiteSpace = 0;
    int blackSpace = 0;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = board[i][j];
        if (piece != null && piece.color == white) {
          whiteSpace += piece.getControl(board).length;
        }
        if (piece != null && piece.color == black) {
          blackSpace += piece.getControl(board).length;
        }
      }
    }
    evaluation += whiteSpace - blackSpace;

    // Determine the square of the white king
    String whiteKingSquare = '';
    String blackKingSquare = '';
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = board[i][j];
        if (piece != null && piece is King) {
          if (piece.color == white) {
            whiteKingSquare = newSquareString(i, j);
          } else if (piece.color == black) {
            blackKingSquare = newSquareString(i, j);
          }
        }
      }
    }

    // Calculate attack and defense
    int whiteAttack = 0;
    int blackAttack = 0;
    int whiteDefense = 0;
    int blackDefense = 0;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = board[i][j];
        if (piece != null && piece.color == white) {
          Set<String> control = piece.getControl(board);
          if (control.contains(blackKingSquare)) {
            whiteAttack++;
          } else {
            whiteDefense += control.length;
          }
        }
        if (piece != null && piece.color == black) {
          Set<String> control = piece.getControl(board);
          if (control.contains(whiteKingSquare)) {
            blackAttack++;
          } else {
            blackDefense += control.length;
          }
        }
      }
    }
    evaluation += (whiteAttack + whiteDefense) - (blackAttack + blackDefense);

    // Safety of pieces heuristic
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        Piece? piece = board[i][j];
        if (piece != null) {
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
          int defendingPieces = 0;
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
    }

    // Bonus for first move
    if (activeColor == white) {
      evaluation += 10;
    } else {
      evaluation -= 10;
    }

    // Return the evaluation for the active color
    return evaluation;
  }
}
