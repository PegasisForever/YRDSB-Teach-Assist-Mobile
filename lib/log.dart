import 'package:intl/intl.dart';

DateFormat _logTimeFormatter = DateFormat('yyyy/MM/dd HH:mm:ss');
int _maxLogLength = 1000 - 30;

List<String> logBuffer=[];

void logError(dynamic msg, {StackTrace trace}) {
  log("ERROR: $msg\n${trace ?? StackTrace.current}");
}

void log(String msg) {
  logBuffer.add("[${_logTimeFormatter.format(DateTime.now())}] ${msg}");

  var list = <String>[];
  while (true) {
    if (msg.length <= _maxLogLength) {
      list.add(msg);
      break;
    } else {
      list.add(msg.substring(0, _maxLogLength));
      msg = msg.substring(_maxLogLength);
    }
  }
  if (list.length == 1) {
    print("[${_logTimeFormatter.format(DateTime.now())}] ${list[0]}");
  } else {
    for (var i = 0; i < list.length; i++) {
      print(
          "[${_logTimeFormatter.format(DateTime.now())}] [#${i + 1}] ${list[i]}");
    }
  }
}
