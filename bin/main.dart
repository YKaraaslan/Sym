import 'dart:convert';
import 'dart:io';

import 'package:sym/board.dart';
import 'package:sym/models/move.dart';
import 'package:sym/models/piece.dart';
import 'package:sym/move_generator.dart';
import 'package:sym/utils/constants.dart';
import 'package:sym/utils/enums.dart';

Stopwatch stopwatch = Stopwatch();
int fullDepth = 5;

// Board
List<List<Piece?>> _board =
    List.generate(8, (_) => List.generate(8, (index) => null));

void main() {
  // Initialize the chess board to the starting po`sition
  _board = ChessBoard().loadPositionFromFen(
      'rnbqkbnr/pppp1ppp/8/4p3/8/4P3/PPPP1PPP/RNBQKBNR w KQkq - 0 2');

  // print(moveGenerationTest(board, activeColor, 5));

  // ChessBoard().printTheBoard(_board);
  // stdout.write('bestmove: ');

  // Generate and make a move, and send it to the GUI
  // String move = MoveGenerator().generateMove(_board);
  // ChessBoard().makeMove(_board, Move.fromUciString(move));
  // ChessBoard().printTheBoard(_board);
  // stdout.write('bestmove: $move\n');
  // print(Position().evaluatePosition(_board, activeColor));

  // Set up the input and output streams
  stdin.transform(utf8.decoder).transform(LineSplitter()).listen(handleInput);

  // Send the "uci" command to the GUI to initiate the UCI communication
  stdout.write('uci\n');
}

int moveGenerationTest(List<List<Piece?>> board, PieceColor color, int depth) {
  if (depth == 0) {
    return 1;
  }

  Set<Move> moves = MoveGenerator().generateMoves(board, color);
  int numberOfPositions = 0;
  var top = 0;

  for (Move move in moves) {
    List<List<Piece?>> newBoard = ChessBoard().deepCopyBoard(board);
    ChessBoard().makeMove(newBoard, move);
    top =
        moveGenerationTest(newBoard, color == white ? black : white, depth - 1);
    ChessBoard().undoMove(newBoard, moveHistory.removeLast());
    numberOfPositions += top;
    if (depth == fullDepth) {
      print('${move.toUciString()}:  $top');
    }
  }

  return numberOfPositions;
}

void handleInput(String input) {
  // Split the input string into tokens
  List<String> tokens = input.split(' ');
  String command = tokens[0];

  switch (command) {
    case 'uci':
      // Respond to the "uci" command with the engine's name and options
      stdout.write('id name Sym Chess Bot\n');
      stdout.write('id author Yunus Karaaslan\n');
      stdout.write('uciok\n');
      break;
    case 'isready':
      // Respond to the "isready" command with "readyok"
      stdout.write('readyok\n');
      break;
    case 'ucinewgame':
      // Reset the chess board and other internal state when starting a new game
      _board = ChessBoard().loadPositionFromFen(startingPosition);
      break;
    case 'position':
      // Set the position on the chess board according to the FEN string or moves list
      if (tokens[1] == 'startpos') {
        _board = List.generate(8, (_) => List.generate(8, (index) => null));
        _board = ChessBoard().loadPositionFromFen(startingPosition);
      } else if (tokens[1] == 'fen') {
        _board = List.generate(8, (_) => List.generate(8, (index) => null));
        String fen = tokens.sublist(2, tokens.length).join(' ');
        _board = ChessBoard().loadPositionFromFen(fen);
      }
      if (tokens[tokens.length - 2] == 'moves') {
        for (int i = tokens.length - 1; i < tokens.length; i++) {
          String move = tokens[i];
          // Make the move on the chess board and update the internal state
          ChessBoard().makeMove(_board, Move.fromUciString(move));
        }
      }
      break;
    case 'go':
      // Generate and make a move, and send it to the GUI
      String move = MoveGenerator().generateMove(_board);
      ChessBoard().makeMove(_board, Move.fromUciString(move));
      stdout.write('bestmove $move\n');
      ChessBoard().printTheBoard(_board);
      print(pgnMoves);
      break;
    case 'move':
      ChessBoard().makeMove(_board, Move.fromUciString(tokens[1]));
      ChessBoard().printTheBoard(_board);
      stdout.write('bestmove: ');
      String move = MoveGenerator().generateMove(_board);
      ChessBoard().makeMove(_board, Move.fromUciString(move));
      ChessBoard().printTheBoard(_board);
      stdout.write('bestmove: $move\n');
      print(pgnMoves);
      break;
    case 'stop':
      // Interrupt the search when receiving the "stop" command
      break;
    case 'quit':
      // Terminate the program when receiving the "quit" command
      exit(0);
    default:
      // Ignore unknown commands
      break;
  }
}
