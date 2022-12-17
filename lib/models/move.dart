class Move {
  int startSquare;
  int targetSquare;

  Move(this.startSquare, this.targetSquare);

  @override
  bool operator ==(covariant Move other) {
    if (identical(this, other)) return true;

    return other.startSquare == startSquare && other.targetSquare == targetSquare;
  }

  @override
  int get hashCode => startSquare.hashCode ^ targetSquare.hashCode;

  static String moveName(int startSquare, int targetSquare) {
    String res = '';
    var aSquares = [0, 8, 16, 24, 32, 40, 48, 56];
    var bSquares = [1, 9, 17, 25, 33, 41, 49, 57];
    var cSquares = [2, 10, 18, 26, 34, 42, 50, 58];
    var dSquares = [3, 11, 19, 27, 35, 43, 51, 59];
    var eSquares = [4, 12, 20, 28, 36, 44, 52, 60];
    var fSquares = [5, 13, 21, 29, 37, 45, 53, 61];
    var gSquares = [6, 14, 22, 30, 38, 46, 54, 62];
    var hSquares = [7, 15, 23, 31, 39, 47, 55, 63];
    var allSquares = [aSquares, bSquares, cSquares, dSquares, eSquares, fSquares, gSquares, hSquares];
    var squareNames = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
    for (var i = 0; i < allSquares.length; i++) {
      for (var j = 0; j < allSquares[i].length; j++) {
        if (startSquare == allSquares[i][j]) {
          res += squareNames[i] + (j + 1).toString();
        }
      }
    }
    for (var i = 0; i < allSquares.length; i++) {
      for (var j = 0; j < allSquares[i].length; j++) {
        if (targetSquare == allSquares[i][j]) {
          res += squareNames[i] + (j + 1).toString();
        }
      }
    }
    return res;
  }
}
