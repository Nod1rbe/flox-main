import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/core/extensions/alignment_extensions.dart';
import 'package:flox/feature/builder/configs/button_config/button_config.dart';
import 'package:flox/ui_components/components/atoms/drop_down_atom.dart';
import 'package:flox/ui_components/components/atoms/text_atom.dart';
import 'package:flox/ui_components/components/atoms/text_field_atom.dart';
import 'package:flox/ui_components/components/molecules/color_picker_molecule.dart';
import 'package:flox/ui_components/components/molecules/drop_down_molecule.dart';
import 'package:flox/ui_components/components/molecules/font_family_selector_molecule.dart';
import 'package:flox/ui_components/components/molecules/text_field_with_label_molecule.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ButtonSection extends StatefulWidget {
  final void Function(Color) onButtonColorChanged;
  final void Function(Color) onTextColorChanged;
  final void Function(Alignment) onAlignmentChanged;
  final void Function(double) onRadiusChanged;
  final void Function(double) onWidthChanged;
  final void Function(double) onHeightChanged;
  final void Function(double) onTextSizeChanged;
  final void Function(FontWeight) onFontWeightChanged;
  final void Function(String) onFontFamilyChanged;
  final void Function(String) onTextChanged;
  final ButtonConfig buttonConfig;

  const ButtonSection({
    super.key,
    required this.onTextChanged,
    required this.onButtonColorChanged,
    required this.onTextColorChanged,
    required this.onRadiusChanged,
    required this.onWidthChanged,
    required this.onHeightChanged,
    required this.onTextSizeChanged,
    required this.onFontWeightChanged,
    required this.onFontFamilyChanged,
    required this.onAlignmentChanged,
    required this.buttonConfig,
  });

  @override
  State<ButtonSection> createState() => _ButtonSectionState();
}

class _ButtonSectionState extends State<ButtonSection> {
  final List<String> items = ['Left', 'Center', 'Right'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextAtom(text: 'Button', fontSize: 24).centerLeft,
          ColorPickerMolecule(
            padding: const EdgeInsets.only(top: 16),
            onColorChanged: widget.onButtonColorChanged,
          ),
          ColorPickerMolecule(
            name: 'Text color',
            initialColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            onColorChanged: widget.onTextColorChanged,
          ),
          DropDownMolecule(
            name: 'Alignment',
            items: items,
            initialValue: 'Center',
            isPrimary: true,
            onChanged: (value) {
              switch (value) {
                case 'Left':
                  widget.onAlignmentChanged(Alignment.centerLeft);
                  break;
                case 'Right':
                  widget.onAlignmentChanged(Alignment.centerRight);
                  break;
                default:
                  widget.onAlignmentChanged(Alignment.center);
              }
            },
          ),
          const SizedBox(height: 16),
          TextFieldWithLabelMolecule(
            padding: const EdgeInsets.all(12),
            currentValue: widget.buttonConfig.radius.toString(),
            name: 'Radius',
            backgroundColor: AppColors.defaultButtonBackground,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (val) => widget.onRadiusChanged(double.tryParse(val) ?? 0),
            defaultSize: 100,
          ),
          TextFieldWithLabelMolecule(
            padding: const EdgeInsets.all(12),
            currentValue: widget.buttonConfig.height.toString(),
            name: 'Height',
            backgroundColor: AppColors.defaultButtonBackground,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (val) => widget.onHeightChanged(double.tryParse(val) ?? 0),
            defaultSize: 100,
          ),
          TextFieldWithLabelMolecule(
            padding: const EdgeInsets.all(12),
            currentValue: widget.buttonConfig.width.toString(),
            name: 'Width',
            backgroundColor: AppColors.defaultButtonBackground,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (val) => widget.onWidthChanged(double.tryParse(val) ?? 0),
            defaultSize: 100,
          ),
          Row(
            children: [
              Expanded(
                child: DropDownAtom(
                  items: ['Thin', 'Normal', 'Bold'],
                  initialValue: getFontWeightInitial(widget.buttonConfig.textWeight),
                  onChanged: (value) {
                    FontWeight selectedFontWeight = FontWeight.w400;
                    switch (value) {
                      case 'Thin':
                        selectedFontWeight = FontWeight.w200;
                        break;
                      case 'Bold':
                        selectedFontWeight = FontWeight.w700;
                        break;
                    }
                    widget.onFontWeightChanged(selectedFontWeight);
                  },
                ),
              ),
              const SizedBox(width: 16),
              TextFieldAtom(
                width: 100,
                keyboardType: TextInputType.number,
                initialValue: widget.buttonConfig.textSize.toString(),
                // controller: textSizeController,
                onChanged: (value) {
                  widget.onTextSizeChanged(double.tryParse(value) ?? 8);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          FontFamilySelectorMolecule(
            selectedFontFamily: widget.buttonConfig.fontFamily,
            onChanged: widget.onFontFamilyChanged,
          ),
          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.defaultButtonBackground,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Text',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                TextFieldAtom(
                  initialValue: widget.buttonConfig.text,
                  fillColor: AppColors.layoutBackground,
                  onChanged: widget.onTextChanged,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String getFontWeightInitial(FontWeight weight) {
    switch (weight) {
      case FontWeight.w700:
        return 'Bold';
      case FontWeight.w200:
        return 'Thin';
      default:
        return 'Normal';
    }
  }
}
