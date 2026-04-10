import 'package:another_flushbar/flushbar.dart';
import 'package:flox/core/enums/ui_enums/flushbar_type.dart';
import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  double get width => MediaQuery.of(this).size.width;

  double get height => MediaQuery.of(this).size.height;
}

extension FlushbarExtension on BuildContext {
  void showFlushbar({String? title, required String message, required FlushbarType type}) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(12),
      backgroundColor: type.color,
      boxShadows: [
        BoxShadow(
          color: type.color.withValues(alpha: 0.4),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
      titleText: Text(
        title ?? type.name,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      messageText: Text(
        message,
        style: TextStyle(fontSize: 16, color: type.color),
      ),
      duration: const Duration(seconds: 4),
      forwardAnimationCurve: Curves.easeOut,
      reverseAnimationCurve: Curves.easeIn,
    ).show(this);
  }
}
