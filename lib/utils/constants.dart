import '../board.dart';
import '../models/move.dart';
import '../models/piece.dart';
import 'enums.dart';

// Board
List<List<Piece?>> board = List.generate(8, (_) => List.generate(8, (index) => null));

// Files in the board
const List<String> files = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];

// Constants for chess piece colors
const PieceColor white = PieceColor.white;
const PieceColor black = PieceColor.black;

// Starting Position FEN
const startingPosition = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';

ChessBoard chessBoard = ChessBoard();
PieceColor activeColor = white;
Map<String, bool> castling = {
  'K': false,
  'Q': false,
  'k': false,
  'q': false,
};
String enPassant = '-';
int halfMoveClock = 0;
int fullMoveClock = 0;

int minValue = -2147483648;
int maxValue = 2147483647;

List<Move> moveHistory = [];

String squareName(int x, int y) => files[y] + (x + 1).toString();
int iteration = 100;

int whiteMoves = 0;
int blackMoves = 0;
