import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/ui_components/components/atoms/drop_down_atom.dart';
import 'package:flox/ui_components/components/atoms/text_atom.dart';
import 'package:flutter/material.dart';

class DropDownMolecule extends StatelessWidget {
  final String name;
  final List<String> items;
  final bool isPrimary;
  final String initialValue;
  final ValueChanged<String> onChanged;

  const DropDownMolecule({
    super.key,
    required this.name,
    required this.items,
    this.isPrimary = true,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isPrimary ? AppColors.layoutBackground : AppColors.defaultButtonBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      // padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextAtom(
            text: name,
            fontSize: 16,
            padding: EdgeInsets.only(right: 50, left: isPrimary ? 0 : 12),
          ),
          Expanded(
            child: DropDownAtom(
              items: items,
              initialValue: initialValue,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
