class HeatMaps {
  static final List<List<int>> pawnHeatMap = [
    [0, 0, 0, 0, 0, 0, 0, 0],
    [5, 5, 5, 5, 5, 5, 5, 5],
    [1, 1, 2, 3, 3, 2, 1, 1],
    [0, 0, 0, 2, 2, 0, 0, 0],
    [0, 0, 0, 1, 1, 0, 0, 0],
    [-3, -3, -2, -1, -1, -2, -3, -3],
    [-5, -5, -5, -5, -5, -5, -5, -5],
    [0, 0, 0, 0, 0, 0, 0, 0],
  ];

  static final List<List<int>> knightHeatMap = [
    [-5, -4, -3, -3, -3, -3, -4, -5],
    [-4, -2, 0, 0, 0, 0, -2, -4],
    [-3, 0, 1, 1, 1, 1, 0, -3],
    [-3, 0, 1, 2, 2, 1, 0, -3],
    [-3, 0, 1, 2, 2, 1, 0, -3],
    [-3, 0, 1, 1, 1, 1, 0, -3],
    [-4, -2, 0, 0, 0, 0, -2, -4],
    [-5, -4, -3, -3, -3, -3, -4, -5],
  ];

  static final List<List<int>> bishopHeatMap = [
    [-2, -1, -1, -1, -1, -1, -1, -2],
    [-1, 0, 0, 0, 0, 0, 0, -1],
    [-1, 0, 1, 1, 1, 1, 0, -1],
    [-1, 0, 1, 2, 2, 1, 0, -1],
    [-1, 0, 1, 2, 2, 1, 0, -1],
    [-1, 0, 1, 1, 1, 1, 0, -1],
    [-1, 0, 0, 0, 0, 0, 0, -1],
    [-2, -1, -1, -1, -1, -1, -1, -2],
  ];

  static final List<List<int>> rookHeatMap = [
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [1, 1, 1, 1, 1, 1, 1, 1],
    [-5, -5, -5, -5, -5, -5, -5, -5],
  ];

  static final List<List<int>> queenHeatMap = [
    [-2, -1, -1, 0, 0, -1, -1, -2],
    [-1, 0, 0, 0, 0, 0, 0, -1],
    [-1, 0, 0, 0, 0, 0, 0, -1],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0],
    [-1, 0, 0, 0, 0, 0, 0, -1],
    [-1, 0, 0, 0, 0, 0, 0, -1],
    [-2, -1, -1, 0, 0, -1, -1, -2],
  ];

  static final List<List<int>> kingHeatMap = [
    [-3, -4, -4, -5, -5, -4, -4, -3],
    [-3, -4, -4, -5, -5, -4, -4, -3],
    [-3, -4, -4, -5, -5, -4, -4, -3],
    [-3, -4, -4, -5, -5, -4, -4, -3],
    [-2, -3, -3, -4, -4, -3, -3, -2],
    [-1, -2, -2, -2, -2, -2, -2, -1],
    [2, 2, 0, 0, 0, 0, 2, 2],
    [2, 3, 1, 0, 0, 1, 3, 2],
  ];
}
