import 'package:flutter/widgets.dart';

enum BasicTextAlignmentType {
  left(TextAlign.left, 'left'),
  center(TextAlign.center, 'center'),
  right(TextAlign.right, 'right'),
  ;

  final TextAlign textAlign;
  final String name;

  const BasicTextAlignmentType(this.textAlign, this.name);

  static TextAlign fromModel(String name) {
    return BasicTextAlignmentType.values
        .firstWhere(
          (e) => e.name == name,
          orElse: () => BasicTextAlignmentType.center,
        )
        .textAlign;
  }

  static String toModel(TextAlign textAlign) {
    return BasicTextAlignmentType.values
        .firstWhere(
          (e) => e.textAlign == textAlign,
          orElse: () => BasicTextAlignmentType.center,
        )
        .name;
  }
}
