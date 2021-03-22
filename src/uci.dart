import 'dart:io';

import 'board.dart';
import 'movegen.dart';
import 'position.dart';

void loop() {
  while (true) {
    String msg = stdin.readLineSync()!;

    if (msg == 'quit') {
      exit(1);
    }

    if (msg == 'uci') {
      print('id name Sym');
      print('id author Yunus KARAASLAN');
      print('uciok');
    }

    if (msg == 'isready') {
      print('readyok');
    }

    if (msg == 'ucinewgame') {
      return;
    }

    if (msg.contains('position startpos moves')) {
      var splitMsg = msg.split(' ');
      var moves = splitMsg.skip(3).take(splitMsg.length - 3);
      loadPositionFromFen(Board.startFEN);
      print(Board.startFEN);

      for (var move in moves) {
        print(move);
      }
    }

    if (msg.contains('position fen')) {
      var splitMsg = msg.split(' ');
      var fen = splitMsg.skip(2).take(splitMsg.length - 2).join(' ');
      loadPositionFromFen(fen);
      GenerateMoves();
    }

    if (msg.startsWith('go')) {
      print('find best move');
    }

    sleep(Duration(milliseconds: 1000));



    // Delete this

    if (msg.contains('ok')) {
      loadPositionFromFen(Board.startFEN);
      GenerateMoves();
    }
  }
}


// position fen rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1

// position fen rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2

// position fen r1bq1rk1/ppp3pp/5n2/3Pp3/1bB5/2N2N2/PP3PPP/R2Q1RK1 w - - 5 12