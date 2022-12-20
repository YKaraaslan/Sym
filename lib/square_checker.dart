import 'models/bishop.dart';
import 'models/king.dart';
import 'models/knight.dart';
import 'models/pawn.dart';
import 'models/piece.dart';
import 'models/queen.dart';
import 'models/rook.dart';
import 'utils/constants.dart';
import 'utils/enums.dart';

class SquareChecker {
  bool isSquareAttacked(
      List<List<Piece?>> board, int row, int col, PieceColor attackedByColor) {
    // Check for attacks by pawns
    if (attackedByColor == white) {
      if (row > 0 &&
          col > 0 &&
          board[row - 1][col - 1] is Pawn &&
          board[row - 1][col - 1]!.color == white) {
        return true;
      }
      if (row > 0 &&
          col < board[0].length - 1 &&
          board[row - 1][col + 1] is Pawn &&
          board[row - 1][col + 1]!.color == white) {
        return true;
      }
    } else {
      if (row < board.length - 1 &&
          col > 0 &&
          board[row + 1][col - 1] is Pawn &&
          board[row + 1][col - 1]!.color == black) {
        return true;
      }
      if (row < board.length - 1 &&
          col < board[0].length - 1 &&
          board[row + 1][col + 1] is Pawn &&
          board[row + 1][col + 1]!.color == black) {
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
            board[row + r][col + c]!.color == attackedByColor) {
          return true;
        }
      }
    }

    // Check for attacks by bishops
    // Check for attacks from the top-left
    for (int c = col - 1, r = row - 1; c >= 0 && r >= 0; c--, r--) {
      // Check if the destination square contains a bishop of the correct color
      if (board[r][c] is Bishop && board[r][c]!.color == attackedByColor) {
        return true;
      }
      // Stop if an obstacle is encountered
      if (board[r][c] != null) break;
    }
    // Check for attacks from the top-right
    for (int c = col + 1, r = row - 1; c < 8 && r >= 0; c++, r--) {
      // Check if the destination square contains a bishop of the correct color
      if (board[r][c] is Bishop && board[r][c]!.color == attackedByColor) {
        return true;
      }
      // Stop if an obstacle is encountered
      if (board[r][c] != null) break;
    }
    // Check for attacks from the bottom-left
    for (int c = col - 1, r = row + 1; c >= 0 && r < 8; c--, r++) {
      // Check if the destination square contains a bishop of the correct color
      if (board[r][c] is Bishop && board[r][c]!.color == attackedByColor) {
        return true;
      }
      // Stop if an obstacle is encountered
      if (board[r][c] != null) break;
    }
    // Check for attacks from the bottom-right
    for (int c = col + 1, r = row + 1; c < 8 && r < 8; c++, r++) {
      // Check if the destination square contains a bishop of the correct color
      if (board[r][c] is Bishop && board[r][c]!.color == attackedByColor) {
        return true;
      }
      // Stop if an obstacle is encountered
      if (board[r][c] != null) break;
    }

    // Check for attacks by rooks
    // Check for attacks from the left
    for (int c = col - 1; c >= 0; c--) {
      // Check if the destination square contains a rook of the correct color
      if (board[row][c] is Rook && board[row][c]!.color == attackedByColor) {
        return true;
      }
      // Stop if an obstacle is encountered
      if (board[row][c] != null) break;
    }
    // Check for attacks from the right
    for (int c = col + 1; c < 8; c++) {
      // Check if the destination square contains a rook of the correct color
      if (board[row][c] is Rook && board[row][c]!.color == attackedByColor) {
        return true;
      }
      // Stop if an obstacle is encountered
      if (board[row][c] != null) break;
    }
    // Check for attacks from the top
    for (int r = row - 1; r >= 0; r--) {
      // Check if the destination square contains a rook of the correct color
      if (board[r][col] is Rook && board[r][col]!.color == attackedByColor) {
        return true;
      }
      // Stop if an obstacle is encountered
      if (board[r][col] != null) break;
    }
    // Check for attacks from the bottom
    for (int r = row + 1; r < 8; r++) {
      // Check if the destination square contains a rook of the correct color
      if (board[r][col] is Rook && board[r][col]!.color == attackedByColor) {
        return true;
      }
      // Stop if an obstacle is encountered
      if (board[r][col] != null) break;
    }

    // Check the rows and columns for attacks by a queen
    for (int i = 0; i < board.length; i++) {
      if (i == row) continue; // skip the current row
      if (board[i][col] is Queen && board[i][col]!.color == attackedByColor) {
        return true;
      }
    }
    for (int j = 0; j < board[0].length; j++) {
      if (j == col) continue; // skip the current column
      if (board[row][j] is Queen && board[row][j]!.color == attackedByColor) {
        return true;
      }
    }

    // Check along the diagonals for attacks by a queen
    int r = row - 1;
    int c = col - 1;
    while (r >= 0 && c >= 0) {
      if (board[r][c] is Queen && board[r][c]!.color == attackedByColor) {
        return true;
      }
      if (board[r][c] != null) break; // stop if a piece is encountered
      r--;
      c--;
    }
    r = row - 1;
    c = col + 1;
    while (r >= 0 && c < board[0].length) {
      if (board[r][c] is Queen && board[r][c]!.color == attackedByColor) {
        return true;
      }
      if (board[r][c] != null) break;
      r--;
      c++;
    }
    r = row + 1;
    c = col - 1;
    while (r < board.length && c >= 0) {
      if (board[r][c] is Queen && board[r][c]!.color == attackedByColor) {
        return true;
      }
      if (board[r][c] != null) break;
      r++;
      c--;
    }
    r = row + 1;
    c = col + 1;
    while (r < board.length && c < board[0].length) {
      if (board[r][c] is Queen && board[r][c]!.color == attackedByColor) {
        return true;
      }
      if (board[r][c] != null) break;
      r++;
      c++;
    }

    // Check for king attacks
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        if (i == 0 && j == 0) continue; // skip the current square
        int r = row + i;
        int c = col + j;
        if (r >= 0 &&
            r < board.length &&
            c >= 0 &&
            c < board[0].length &&
            board[r][c] is King &&
            board[r][c]!.color == attackedByColor) {
          return true;
        }
      }
    }

    return false;
  }
}
