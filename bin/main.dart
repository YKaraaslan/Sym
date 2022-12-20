import 'dart:convert';
import 'dart:io';

import 'package:sym/move_generator.dart';
import 'package:sym/position.dart';
import 'package:sym/utils/constants.dart';

void main() {
  // Initialize the chess board
  initBoard();

  // Set up the input and output streams
  stdin.transform(utf8.decoder).transform(LineSplitter()).listen(handleInput);

  // Send the "uci" command to the GUI to initiate the UCI communication
  stdout.write('uci\n');
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
      initBoard();
      break;
    case 'position':
      // Set the position on the chess board according to the FEN string or moves list
      if (tokens[1] == 'startpos') {
        chessBoard.loadPositionFromFen(startingPosition);
      } else if (tokens[1] == 'fen') {
        String fen = tokens.sublist(2, tokens.length - 1).join(' ');
        chessBoard.loadPositionFromFen(fen);
      }
      if (tokens[tokens.length - 2] == 'moves') {
        for (int i = tokens.length - 1; i < tokens.length; i++) {
          String move = tokens[i];
          // Make the move on the chess board and update the internal state
          chessBoard.makeMove(move);
        }
      }
      break;
    case 'go':
      // Generate and make a move, and send it to the GUI
      String move = MoveGenerator().generateMove(board);
      chessBoard.makeMove(move);
      stdout.write('bestmove $move\n');
      print('\n' * 10);
      for (var i = board.length - 1; i >= 0; i--) {
        var symbol = '';
        for (var element in board[i]) {
          symbol += '${element?.getSymbol() ?? '.'} ';
        }
        print(symbol);
      }
      print('\n' * 5);
      break;
    case 'stop':
      // Interrupt the search when receiving the "stop" command
      break;
    case 'quit':
      // Terminate the program when receiving the "quit" command
      exit(0);
    case 'move':
      if (tokens[1].length != 4) break;
      chessBoard.makeMove(tokens[1]);
      break;
    case 'eval':
      print(Position().evaluatePosition(board));
      break;
    case 'change':
      activeColor = activeColor == white ? black : white;
      print(activeColor);
      break;
    default:
      // Ignore unknown commands
      break;
  }
}

void initBoard() {
  // Initialize the chess board to the starting position
  chessBoard.loadPositionFromFen('r1b2knr/pp1nb2p/2p1p2p/3p1p2/qP3P2/2PPP1PB/4Q2P/1N2K1NR w K - 0 2');
}
