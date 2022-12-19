class Move {
  int row;
  int column;
  int newRow;
  int newColumn;
  bool isCastling;
  bool isEnPassant;

  Move(this.row, this.column, this.newRow, this.newColumn,
      {this.isCastling = false, this.isEnPassant = false});

  String toUciString() {
    String file1 = String.fromCharCode(column + 'a'.codeUnitAt(0));
    String file2 = String.fromCharCode(newColumn + 'a'.codeUnitAt(0));
    String rank1 = (row + 1).toString();
    String rank2 = (newRow + 1).toString();
    return '$file1$rank1$file2$rank2';
  }

  static Move fromUciString(String uci) {
    int x1 = uci.codeUnitAt(0) - 'a'.codeUnitAt(0);
    int y1 = int.parse(uci[1]) - 1;
    int x2 = uci.codeUnitAt(2) - 'a'.codeUnitAt(0);
    int y2 = int.parse(uci[3]) - 1;
    return Move(x1, y1, x2, y2);
  }
}
