import 'package:flutter/material.dart';

enum BasicAlignmentType {
  topLeft(Alignment.topLeft, 'topLeft'),
  topCenter(Alignment.topCenter, 'topCenter'),
  topRight(Alignment.topRight, 'topRight'),
  centerLeft(Alignment.centerLeft, 'centerLeft'),
  center(Alignment.center, 'center'),
  centerRight(Alignment.centerRight, 'centerRight'),
  bottomLeft(Alignment.bottomLeft, 'bottomLeft'),
  bottomCenter(Alignment.bottomCenter, 'bottomCenter'),
  bottomRight(Alignment.bottomRight, 'bottomRight');

  final Alignment alignment;
  final String name;

  const BasicAlignmentType(this.alignment, this.name);

  static Alignment fromModel(String? name) {
    return BasicAlignmentType.values
        .firstWhere((e) => e.name == name, orElse: () => BasicAlignmentType.center)
        .alignment;
  }

  static String toModel(Alignment alignment) {
    return BasicAlignmentType.values
        .firstWhere((e) => e.alignment == alignment, orElse: () => BasicAlignmentType.center)
        .name;
  }
}
