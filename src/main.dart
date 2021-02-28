import 'position.dart' as position;
import 'movegen.dart' as movegen;
import 'uci.dart' as uci;

void main(List<String> args) {
  print('Sym by Yunus Karaaslan');
  position.init();
  movegen.init();
  uci.loop();
}