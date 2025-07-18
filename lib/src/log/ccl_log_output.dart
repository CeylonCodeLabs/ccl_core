import 'package:logger/logger.dart';

class CclLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    final sb = StringBuffer();
    event.lines.forEach(sb.writeln);
    print(sb.toString());
  }
}