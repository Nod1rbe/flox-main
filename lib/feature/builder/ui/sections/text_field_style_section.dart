import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/feature/builder/configs/text_field_config/text_field_config.dart';
import 'package:flox/ui_components/components/atoms/drop_down_atom.dart';
import 'package:flox/ui_components/components/atoms/text_atom.dart';
import 'package:flox/ui_components/components/molecules/color_picker_molecule.dart';
import 'package:flox/ui_components/components/molecules/drop_down_molecule.dart';
import 'package:flox/ui_components/components/molecules/font_family_selector_molecule.dart';
import 'package:flox/ui_components/components/molecules/text_field_with_label_molecule.dart';
import 'package:flutter/material.dart';

class TextFieldStyleSection extends StatefulWidget {
  final Function(double cornerRadius) onCornerRadiusChanged;
  final Function(Alignment alignment) onAlignmentChanged;
  final Function(Color textColor) onTextColorChanged;
  final Function(Color backgroundColor) onBackgroundColorChanged;
  final Function(FontWeight fontWeight) onFontWeightChanged;
  final Function(double fontSize) onFontSizeChanged;
  final Function(String fontFamily) onFontFamilyChanged;
  final Function(String hintText) onHintTextChanged;
  final TextFieldConfig config;

  const TextFieldStyleSection({
    super.key,
    required this.onHintTextChanged,
    required this.onCornerRadiusChanged,
    required this.onAlignmentChanged,
    required this.onTextColorChanged,
    required this.onBackgroundColorChanged,
    required this.onFontWeightChanged,
    required this.onFontSizeChanged, // Added
    required this.onFontFamilyChanged,
    required this.config, // Added
  });

  @override
  State<TextFieldStyleSection> createState() => _TextFieldStyleSectionState();
}

class _TextFieldStyleSectionState extends State<TextFieldStyleSection> {
  final List<String> _alignmentDisplayValues = ['left', 'center', 'right'];
  final Map<String, Alignment> _stringToAlignmentMap = {
    'left': Alignment.centerLeft,
    'center': Alignment.center,
    'right': Alignment.centerRight,
  };
  final Map<Alignment, String> _alignmentToStringMap = {
    Alignment.centerLeft: 'left',
    Alignment.center: 'center',
    Alignment.centerRight: 'right',
  };

  final List<String> _fontWeightDisplayValues = ['Thin', 'Normal', 'Bold'];
  final Map<String, FontWeight> _stringToFontWeightMap = {
    'Thin': FontWeight.w200,
    'Normal': FontWeight.normal, // w400
    'Bold': FontWeight.bold, // w700
  };

  late TextEditingController _cornerRadiusController;
  late TextEditingController _fontSizeController;
  late TextEditingController _hintTextController;

  @override
  void initState() {
    super.initState();
    _cornerRadiusController = TextEditingController(text: widget.config.cornerRadius.toStringAsFixed(0));
    _fontSizeController = TextEditingController(text: widget.config.fontSize.toStringAsFixed(0));
    _hintTextController = TextEditingController(text: widget.config.hintText);
  }

  @override
  void didUpdateWidget(covariant TextFieldStyleSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.config.cornerRadius != oldWidget.config.cornerRadius) {
      final newText = widget.config.cornerRadius.toStringAsFixed(0);
      if (_cornerRadiusController.text != newText) {
        _cornerRadiusController.text = newText;
      }
    }
    if (widget.config.fontSize != oldWidget.config.fontSize) {
      final newText = widget.config.fontSize.toStringAsFixed(0);
      if (_fontSizeController.text != newText) {
        _fontSizeController.text = newText;
      }
    }
  }

  String _getFontWeightDisplayString(FontWeight weight) {
    if (weight.value <= FontWeight.w300.value) return 'Thin';
    if (weight.value >= FontWeight.w700.value) return 'Bold';
    return 'Normal';
  }

  @override
  void dispose() {
    _cornerRadiusController.dispose();
    _fontSizeController.dispose();
    _hintTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextAtom(
            text: 'Style',
            fontSize: 24,
          ),
          const SizedBox(height: 12),
          TextFieldWithLabelMolecule(
            name: 'Corner radius',
            backgroundColor: AppColors.defaultButtonBackground,
            currentValue: _cornerRadiusController.text,
            textInputType: TextInputType.number,
            onChanged: (value) {
              final newRadius = double.tryParse(value);
              if (newRadius != null) {
                widget.onCornerRadiusChanged(newRadius);
              }
            },
          ),
          TextFieldWithLabelMolecule(
            name: 'Font size',
            backgroundColor: AppColors.defaultButtonBackground,
            currentValue: _fontSizeController.text,
            textInputType: TextInputType.number,
            onChanged: (value) {
              final newSize = double.tryParse(value);
              if (newSize != null) {
                widget.onFontSizeChanged(newSize);
              }
            },
          ),
          TextFieldWithLabelMolecule(
            name: 'Hint text',
            defaultSize: 200,
            backgroundColor: AppColors.defaultButtonBackground,
            currentValue: _hintTextController.text,
            onChanged: (value) {
              widget.onHintTextChanged(value);
            },
          ),
          DropDownMolecule(
            name: 'Alignment',
            items: _alignmentDisplayValues,
            initialValue: _alignmentToStringMap[widget.config.alignment] ?? _alignmentDisplayValues.first,
            onChanged: (value) {
              if (_stringToAlignmentMap.containsKey(value)) {
                widget.onAlignmentChanged(_stringToAlignmentMap[value]!);
              }
            },
          ),
          const SizedBox(height: 16),
          ColorPickerMolecule(
            name: 'Text color',
            initialColor: widget.config.textColor,
            onColorChanged: widget.onTextColorChanged,
          ),
          const SizedBox(height: 16),
          ColorPickerMolecule(
            initialColor: widget.config.backgroundColor,
            name: 'Background color',
            onColorChanged: widget.onBackgroundColorChanged,
          ),
          const SizedBox(height: 16),
          DropDownAtom(
            items: _fontWeightDisplayValues,
            initialValue: _getFontWeightDisplayString(widget.config.fontWeight),
            onChanged: (value) {
              if (_stringToFontWeightMap.containsKey(value)) {
                widget.onFontWeightChanged(_stringToFontWeightMap[value]!);
              }
            },
          ),
          const SizedBox(height: 16),
          FontFamilySelectorMolecule(
            selectedFontFamily: widget.config.fontFamily,
            onChanged: widget.onFontFamilyChanged,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
