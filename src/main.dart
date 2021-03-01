import 'board.dart';
import 'position.dart' as position;
import 'uci.dart' as uci;

void main(List<String> args) {
  print('Sym by Yunus Karaaslan');
  Board();
  position.init();
  uci.loop();
}
