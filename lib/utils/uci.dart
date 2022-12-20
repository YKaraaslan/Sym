import 'dart:convert';
import 'dart:io';

import '../board.dart';

class Uci {
  void communicate(ChessBoard chessBoard) {
    stdin.transform(utf8.decoder).listen((input) {
      // Split the input into a list of commands
      List<String> commands = input.split('\n');

      // Iterate through the commands and execute them
      for (String command in commands) {
        if (command == 'uci') {
          // Send the "uci" command response
          print('id name Sym Chess Bot');
          print('id author Yunus Karaaslan');
          print('uciok');
        } else if (command.startsWith('position')) {
          // Parse the "position" command and update the board
          List<String> parts = command.split(' ');
          if (parts[1] == 'startpos') {
            // Reset the board to the starting position
            chessBoard = ChessBoard();
          } else {
            // Implement support for setting up a custom position ---
          }
          if (parts.contains('moves')) {
            // Make the specified moves on the board
            for (int i = parts.indexOf('moves') + 1; i < parts.length; i++) {
              chessBoard.makeMove(parts[i]);
            }
          }
        } else if (command == 'go') {
          // Implement the AI for making a move  ---
          String move = 'e2e4'; // Placeholder for the AI's chosen move
          print('bestmove $move');
        } else if (command == 'isready') {
          print('readyok'); // Send the "isready" command response
        } else if (command == 'quit') {
          exit(0); // Quit the program
        }
      }
    });
  }
}
