import 'package:flox/core/constants/font_options.dart';
import 'package:flox/ui_components/components/molecules/drop_down_molecule.dart';
import 'package:flutter/material.dart';

class FontFamilySelectorMolecule extends StatelessWidget {
  final String selectedFontFamily;
  final ValueChanged<String> onChanged;
  final String label;

  const FontFamilySelectorMolecule({
    super.key,
    required this.selectedFontFamily,
    required this.onChanged,
    this.label = 'Font family',
  });

  @override
  Widget build(BuildContext context) {
    final initialValue = FontOptions.supported.contains(selectedFontFamily)
        ? selectedFontFamily
        : FontOptions.defaultFont;

    return DropDownMolecule(
      name: label,
      items: FontOptions.supported,
      initialValue: initialValue,
      onChanged: onChanged,
    );
  }
}
