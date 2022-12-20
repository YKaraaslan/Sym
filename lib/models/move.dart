import 'package:sym/utils/constants.dart';

class Move {
  int row;
  int column;
  int newRow;
  int newColumn;
  String newSquare;
  bool isCastling;
  bool isEnPassant;

  Move({
    required this.row,
    required this.column,
    required this.newRow,
    required this.newColumn,
    required this.newSquare,
    this.isCastling = false,
    this.isEnPassant = false,
  });

  String toUciString() {
    String file1 = String.fromCharCode(column + 'a'.codeUnitAt(0));
    String file2 = String.fromCharCode(newColumn + 'a'.codeUnitAt(0));
    String rank1 = (row + 1).toString();
    String rank2 = (newRow + 1).toString();
    return '$file1$rank1$file2$rank2';
  }

  static Move fromUciString(String uci) {
    int x1 = int.parse(uci[1]) - 1;
    int y1 = uci.codeUnitAt(0) - 'a'.codeUnitAt(0);
    int x2 = int.parse(uci[3]) - 1;
    int y2 = uci.codeUnitAt(2) - 'a'.codeUnitAt(0);
    return Move(row: x1, column: y1, newRow: x2, newColumn: y2, newSquare: newSquareString(x2, y2));
  }
}
