import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/extensions/edge_insets.dart';
import 'package:flox/ui_components/components/molecules/text_field_with_label_molecule.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaddingPropertiesSection extends StatefulWidget {
  const PaddingPropertiesSection({super.key, required this.onPaddingChanged, required this.currentPadding});

  final Function(EdgeInsets padding) onPaddingChanged;
  final EdgeInsets currentPadding;

  @override
  State<PaddingPropertiesSection> createState() => _PaddingPropertiesSectionState();
}

class _PaddingPropertiesSectionState extends State<PaddingPropertiesSection> {
  late EdgeInsets currentPadding;

  @override
  void initState() {
    super.initState();
    currentPadding = widget.currentPadding;
  }

  @override
  Widget build(BuildContext context) {
    final onlyDigits = [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(5),
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Paddings',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
          TextFieldWithLabelMolecule(
            name: 'Top',
            backgroundColor: AppColors.defaultButtonBackground,
            currentValue: currentPadding.top.toString(),
            textInputType: TextInputType.number,
            inputFormatters: onlyDigits,
            onChanged: (value) {
              currentPadding = currentPadding.changeTop(double.tryParse(value) ?? 0);
              widget.onPaddingChanged.call(currentPadding);
            },
          ),
          TextFieldWithLabelMolecule(
            name: 'Right',
            backgroundColor: AppColors.defaultButtonBackground,
            currentValue: currentPadding.right.toString(),
            textInputType: TextInputType.number,
            inputFormatters: onlyDigits,
            onChanged: (value) {
              currentPadding = currentPadding.changeRight(double.tryParse(value) ?? 0);
              widget.onPaddingChanged(currentPadding);
            },
          ),
          TextFieldWithLabelMolecule(
            name: 'Bottom',
            backgroundColor: AppColors.defaultButtonBackground,
            currentValue: currentPadding.bottom.toString(),
            textInputType: TextInputType.number,
            inputFormatters: onlyDigits,
            onChanged: (value) {
              currentPadding = currentPadding.changeBottom(double.tryParse(value) ?? 0);
              widget.onPaddingChanged(currentPadding);
            },
          ),
          TextFieldWithLabelMolecule(
            name: 'Left',
            backgroundColor: AppColors.defaultButtonBackground,
            currentValue: currentPadding.left.toString(),
            textInputType: TextInputType.number,
            inputFormatters: onlyDigits,
            onChanged: (value) {
              currentPadding = currentPadding.changeLeft(double.tryParse(value) ?? 0);
              widget.onPaddingChanged(currentPadding);
            },
          ),
        ],
      ),
    );
  }
}
