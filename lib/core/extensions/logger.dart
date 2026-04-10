import 'package:flutter/cupertino.dart';

extension LoggerExtension on Object {
  void appLog([dynamic arg]) {
    final now = DateTime.now();
    final nowString = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second
        .toString().padLeft(2, '0')}.${now.millisecond.toString().padLeft(4, '0')}';
    final message =
        '[$nowString] $runtimeType[$hashCode]: $arg';
    debugPrint(message);
  }
}
