import 'package:flutter/widgets.dart';

enum BasicBoxFitType {
  fill(BoxFit.fill, 'fill'),
  contain(BoxFit.contain, 'contain'),
  cover(BoxFit.cover, 'cover'),
  fitWidth(BoxFit.fitWidth, 'fitWidth'),
  fitHeight(BoxFit.fitHeight, 'fitHeight'),
  none(BoxFit.none, 'none'),
  scaleDown(BoxFit.scaleDown, 'scaleDown');

  final BoxFit fit;
  final String name;

  const BasicBoxFitType(this.fit, this.name);

  static BoxFit fromModel(String? name) {
    return BasicBoxFitType.values
        .firstWhere(
          (e) => e.name == name,
          orElse: () => BasicBoxFitType.contain,
        )
        .fit;
  }

  static String toModel(BoxFit fit) {
    return BasicBoxFitType.values
        .firstWhere(
          (e) => e.fit == fit,
          orElse: () => BasicBoxFitType.contain,
        )
        .name;
  }
}
