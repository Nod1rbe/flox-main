import 'package:flutter/material.dart';

extension HexColorExtensions on String? {
  Color get toColor {
    final hex = (this ?? 'FFFFFFFF').toUpperCase().replaceAll('#', '');
    if (hex.length == 6) {
      return Color(int.parse('FF$hex', radix: 16));
    } else if (hex.length == 8) {
      return Color(int.parse(hex, radix: 16));
    } else {
      return const Color(0xFFFFFFFF);
    }
  }
}

extension ToHexString on Color {
  String toHexString({bool leadingHashSign = true}) {
    return '${leadingHashSign ? '#' : ''}'
            '${alpha.toRadixString(16).padLeft(2, '0')}'
            '${red.toRadixString(16).padLeft(2, '0')}'
            '${green.toRadixString(16).padLeft(2, '0')}'
            '${blue.toRadixString(16).padLeft(2, '0')}'
        .toUpperCase();
  }
}
