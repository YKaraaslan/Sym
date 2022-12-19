import 'models/bishop.dart';
import 'models/knight.dart';
import 'models/pawn.dart';
import 'models/piece.dart';
import 'models/queen.dart';
import 'models/rook.dart';
import 'utils/constants.dart';
import 'utils/enums.dart';

class SquareChecker {
  bool isSquareAttacked(
      List<List<Piece?>> board, int row, int col, PieceColor color) {
    // Check for attacks by pawns
    if (color == white) {
      // Check for attacks from the left
      if (col > 0 &&
          row > 0 &&
          board[row - 1][col - 1] is Pawn &&
          board[row - 1][col - 1]!.color == black) {
        return true;
      }
      // Check for attacks from the right
      if (col < 7 &&
          row > 0 &&
          board[row - 1][col + 1] is Pawn &&
          board[row - 1][col + 1]!.color == black) {
        return true;
      }
    } else {
      // Check for attacks from the left
      if (col > 0 &&
          row < 7 &&
          board[row + 1][col - 1] is Pawn &&
          board[row + 1][col - 1]!.color == white) {
        return true;
      }
      // Check for attacks from the right
      if (col < 7 &&
          row < 7 &&
          board[row + 1][col + 1] is Pawn &&
          board[row + 1][col + 1]!.color == white) {
        return true;
      }
    }

    // Check for attacks by knights
    for (int c = -2; c <= 2; c++) {
      for (int r = -2; r <= 2; r++) {
        // Skip non-knight moves
        if (c.abs() + r.abs() != 3) continue;
        // Check if the destination square is within the board bounds
        if (row + r < 0 || row + r >= 8 || col + c < 0 || col + c >= 8) {
          continue;
        }
        // Check if the destination square contains a knight of the correct color
        if (board[row + r][col + c] is Knight &&
            board[row + r][col + c]!.color == color) {
          return true;
        }
      }
    }

    // Check for attacks by bishops
    // Check for attacks from the top-left
    for (int c = col - 1, r = row - 1; c >= 0 && r >= 0; c--, r--) {
      // Check if the destination square contains a bishop of the correct color
      if (board[r][c] is Bishop && board[r][c]!.color == color) {
        return true;
      }
      // Stop if an obstacle is encountered
      if (board[r][c] != null) break;
    }
    // Check for attacks from the top-right
    for (int c = col + 1, r = row - 1; c < 8 && r >= 0; c++, r--) {
      // Check if the destination square contains a bishop of the correct color
      if (board[r][c] is Bishop && board[r][c]!.color == color) {
        return true;
      }
      // Stop if an obstacle is encountered
      if (board[r][c] != null) break;
    }
    // Check for attacks from the bottom-left
    for (int c = col - 1, r = row + 1; c >= 0 && r < 8; c--, r++) {
      // Check if the destination square contains a bishop of the correct color
      if (board[r][c] is Bishop && board[r][c]!.color == color) {
        return true;
      }
      // Stop if an obstacle is encountered
      if (board[r][c] != null) break;
    }
    // Check for attacks from the bottom-right
    for (int c = col + 1, r = row + 1; c < 8 && r < 8; c++, r++) {
      // Check if the destination square contains a bishop of the correct color
      if (board[r][c] is Bishop && board[r][c]!.color == color) {
        return true;
      }
      // Stop if an obstacle is encountered
      if (board[r][c] != null) break;
    }

    // Check for attacks by rooks
    // Check for attacks from the left
    for (int c = col - 1; c >= 0; c--) {
      // Check if the destination square contains a rook of the correct color
      if (board[row][c] is Rook && board[row][c]!.color == color) {
        return true;
      }
      // Stop if an obstacle is encountered
      if (board[row][c] != null) break;
    }
    // Check for attacks from the right
    for (int c = col + 1; c < 8; c++) {
      // Check if the destination square contains a rook of the correct color
      if (board[row][c] is Rook && board[row][c]!.color == color) {
        return true;
      }
      // Stop if an obstacle is encountered
      if (board[row][c] != null) break;
    }
    // Check for attacks from the top
    for (int r = row - 1; r >= 0; r--) {
      // Check if the destination square contains a rook of the correct color
      if (board[r][col] is Rook && board[r][col]!.color == color) {
        return true;
      }
      // Stop if an obstacle is encountered
      if (board[r][col] != null) break;
    }
    // Check for attacks from the bottom
    for (int r = row + 1; r < 8; r++) {
      // Check if the destination square contains a rook of the correct color
      if (board[r][col] is Rook && board[r][col]!.color == color) {
        return true;
      }
      // Stop if an obstacle is encountered
      if (board[r][col] != null) break;
    }

    // Check the rows and columns for attacks by a queen
    for (int i = 0; i < 8; i++) {
      if (board[row][i]?.color == color && board[row][i] is Queen) {
        return true;
      }
      if (board[i][col]?.color == color && board[i][col] is Queen) {
        return true;
      }
    }

    // Check the diagonals for attacks by a queen
    int r = row;
    int c = col;
    while (r > 0 && c > 0) {
      r--;
      c--;
    }
    while (r < 8 && c < 8) {
      if (board[r][c]?.color == color && board[r][c] is Queen) {
        return true;
      }
      r++;
      c++;
    }

    r = row;
    c = col;
    while (r > 0 && c < 7) {
      r--;
      c++;
    }
    while (r < 8 && c >= 0) {
      if (board[r][c]?.color == color && board[r][c] is Queen) {
        return true;
      }
      r++;
      c--;
    }

    return false;
  }
}
