import 'package:flox/ui_components/components/atoms/color_selector_atom.dart';
import 'package:flox/ui_components/components/atoms/text_atom.dart';
import 'package:flutter/material.dart';

class ColorPickerMolecule extends StatelessWidget {
  final ValueChanged<Color> onColorChanged;
  final EdgeInsets padding;
  final String name;
  final Color initialColor;
  const ColorPickerMolecule({
    super.key,
    this.initialColor = Colors.black,
    this.name = 'Color',
    this.padding = EdgeInsets.zero,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: padding,
      decoration: BoxDecoration(
        color: Color(0xFF444444),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextAtom(
            text: name,
            fontSize: 16,
            padding: EdgeInsets.only(left: 12, right: 24),
          ),
          ColorSelectorAtom(
            initialColor: initialColor,
            outerPadding: EdgeInsets.zero,
            onColorChanged: (p0) {
              onColorChanged(p0);
            },
          ),
        ],
      ),
    );
  }
}
