import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/ui_components/components/atoms/text_atom.dart';
import 'package:flutter/material.dart';

class AlignmentSelectorMolecule extends StatelessWidget {
  final String label;
  final Alignment currentAlignment;
  final void Function(Alignment) onAlignmentChanged;

  const AlignmentSelectorMolecule({
    super.key,
    required this.label,
    required this.currentAlignment,
    required this.onAlignmentChanged,
  });

  static Map<Alignment, String> alignmentOptions = {
    Alignment.topLeft: 'Top Left',
    Alignment.topCenter: 'Top Center',
    Alignment.topRight: 'Top Right',
    Alignment.centerLeft: 'Center Left',
    Alignment.center: 'Center',
    Alignment.centerRight: 'Center Right',
    Alignment.bottomLeft: 'Bottom Left',
    Alignment.bottomCenter: 'Bottom Center',
    Alignment.bottomRight: 'Bottom Right',
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextAtom(text: label, fontSize: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.layoutBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<Alignment>(
              value: currentAlignment,
              underline: const SizedBox.shrink(),
              icon: Icon(Icons.keyboard_arrow_down, color: AppColors.white),
              dropdownColor: AppColors.defaultButtonBackground,
              style: TextStyle(color: AppColors.white, fontSize: 14),
              onChanged: (Alignment? newValue) {
                if (newValue != null) {
                  onAlignmentChanged(newValue);
                }
              },
              items: alignmentOptions.entries.map<DropdownMenuItem<Alignment>>((entry) {
                return DropdownMenuItem<Alignment>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
