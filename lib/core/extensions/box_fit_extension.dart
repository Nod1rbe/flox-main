import 'package:flutter/widgets.dart';

extension NullableStringToBoxFit on String? {
  BoxFit toBoxFit({BoxFit defaultValue = BoxFit.contain}) {
    switch (this) {
      case 'fill':
        return BoxFit.fill;
      case 'contain':
        return BoxFit.contain;
      case 'cover':
        return BoxFit.cover;
      case 'fitWidth':
        return BoxFit.fitWidth;
      case 'fitHeight':
        return BoxFit.fitHeight;
      case 'none':
        return BoxFit.none;
      case 'scaleDown':
        return BoxFit.scaleDown;
      default:
        return defaultValue; // Agar null yoki mos kelmasa
    }
  }
}
