import 'dart:io';

import 'package:sym/models/move.dart';
import 'package:sym/models/piece.dart';
import 'package:sym/move_generator.dart';
import 'package:sym/position.dart';
import 'package:sym/utils/constants.dart';
import 'package:sym/utils/enums.dart';

Stopwatch stopwatch = Stopwatch();
int fullDepth = 5;

void main() {
  // Initialize the chess board to the starting po`sition
  chessBoard.loadPositionFromFen('r1bqkbnr/pppp1ppp/8/3Pp3/3nP3/8/PPP2PPP/RNBQKBNR w KQkq - 1 4');
  print(Position().evaluatePosition(board));

  chessBoard.printTheBoard(board);
  stdout.write('bestmove: ');

  // Generate and make a move, and send it to the GUI
  String move = MoveGenerator().generateMove(board);
  chessBoard.makeMove(board, Move.fromUciString(move));
  chessBoard.printTheBoard(board);
  stdout.write('bestmove: $move\n');
  print(Position().evaluatePosition(board));

  // Set up the input and output streams
  // stdin.transform(utf8.decoder).transform(LineSplitter()).listen(handleInput);

  // Send the "uci" command to the GUI to initiate the UCI communication
  // stdout.write('uci\n');
}

int moveGenerationTest(List<List<Piece?>> board, PieceColor color, Map<List<List<Piece?>>, int> transTable, int depth) {
  if (depth == 0) {
    return 1;
  }

  if (transTable.containsKey(board)) {
    return transTable[board]!;
  }

  Set<Move> moves = MoveGenerator().generateMoves(board, color);
  int numberOfPositions = 0;
  var top = 0;

  for (Move move in moves) {
    List<List<Piece?>> newBoard = chessBoard.deepCopyBoard(board);
    chessBoard.makeMove(newBoard, move);
    top = moveGenerationTest(newBoard, color == white ? black : white, transTable, depth - 1);
    chessBoard.undoMove(newBoard, moveHistory.removeLast());
    numberOfPositions += top;
    if (depth == fullDepth) {
      print('${move.toUciString()}:  $top');
    }
  }

  // Store the result in the transposition table
  transTable[board] = numberOfPositions;

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
      chessBoard.loadPositionFromFen(startingPosition);
      break;
    case 'position':
      // Set the position on the chess board according to the FEN string or moves list
      if (tokens[1] == 'startpos') {
        chessBoard.loadPositionFromFen(startingPosition);
      } else if (tokens[1] == 'fen') {
        String fen = tokens.sublist(2, tokens.length).join(' ');
        chessBoard.loadPositionFromFen(fen);
      }
      if (tokens[tokens.length - 2] == 'moves') {
        for (int i = tokens.length - 1; i < tokens.length; i++) {
          String move = tokens[i];
          // Make the move on the chess board and update the internal state
          chessBoard.makeMove(board, Move.fromUciString(move));
        }
      }
      break;
    case 'go':
      // Generate and make a move, and send it to the GUI
      String move = MoveGenerator().generateMove(board);
      chessBoard.makeMove(board, Move.fromUciString(move));
      stdout.write('bestmove $move\n');
      chessBoard.printTheBoard(board);
      break;
    case 'move':
      chessBoard.makeMove(board, Move.fromUciString(tokens[1]));
      chessBoard.printTheBoard(board);
      stdout.write('bestmove: ');
      String move = MoveGenerator().generateMove(board);
      chessBoard.makeMove(board, Move.fromUciString(move));
      chessBoard.printTheBoard(board);
      stdout.write('bestmove: $move\n');
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
