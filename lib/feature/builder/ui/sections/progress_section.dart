import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/feature/builder/configs/progress_config/progress_config.dart';
import 'package:flox/ui_components/components/atoms/drop_down_atom.dart';
import 'package:flox/ui_components/components/atoms/text_atom.dart';
import 'package:flox/ui_components/components/atoms/text_field_atom.dart';
import 'package:flox/ui_components/components/molecules/color_picker_molecule.dart';
import 'package:flox/ui_components/components/molecules/font_family_selector_molecule.dart';
import 'package:flox/ui_components/components/molecules/switch_molecule.dart';
import 'package:flox/ui_components/components/molecules/text_field_with_label_molecule.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProgressSection extends StatefulWidget {
  final void Function(double value)? onHeightChanged;
  final void Function(double value)? onRadiusChanged;
  final void Function(bool showIcons)? onShowIconsChanged;
  final void Function(Color textColor)? onTextColorChanged;
  final void Function(Color backgroundColor)? onBackgroundColorChanged;
  final void Function(String progressType)? onProgressTypeChanged;
  final Function(FontWeight fontWeight)? onFontWeightChanged;
  final void Function(double fontSize)? onTextFontSizeChanged;
  final void Function(String fontFamily)? onFontFamilyChanged;
  final ProgressConfig config;

  const ProgressSection({
    super.key,
    this.onHeightChanged,
    this.onRadiusChanged,
    this.onShowIconsChanged,
    this.onTextColorChanged,
    required this.config,
    this.onBackgroundColorChanged,
    this.onProgressTypeChanged,
    this.onFontWeightChanged,
    this.onTextFontSizeChanged,
    this.onFontFamilyChanged,
  });

  @override
  State<ProgressSection> createState() => _ProgressSectionState();
}

class _ProgressSectionState extends State<ProgressSection> {
  final items = ['Linear', 'Circular'];
  final initialValue = 'Linear';

  late final TextEditingController _heightController;
  late final FocusNode _heightFocusNode;

  late final TextEditingController _radiusController;
  late final FocusNode _radiusFocusNode;

  late final TextEditingController _fontSizeController;
  late final FocusNode _fontSizeFocusNode;

  @override
  void initState() {
    super.initState();
    _heightController = TextEditingController(text: widget.config.height.toString());
    _heightFocusNode = FocusNode();

    _radiusController = TextEditingController(text: widget.config.cornerRadius.toString());
    _radiusFocusNode = FocusNode();

    _fontSizeController = TextEditingController(text: widget.config.fontSize.toString());
    _fontSizeFocusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant ProgressSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.config.height.toString() != _heightController.text && !_heightFocusNode.hasFocus) {
      _heightController.text = widget.config.height.toString();
    }
    if (widget.config.cornerRadius.toString() != _radiusController.text && !_radiusFocusNode.hasFocus) {
      _radiusController.text = widget.config.cornerRadius.toString();
    }
    if (widget.config.fontSize.toString() != _fontSizeController.text && !_fontSizeFocusNode.hasFocus) {
      _fontSizeController.text = widget.config.fontSize.toString();
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    _heightFocusNode.dispose();
    _radiusController.dispose();
    _radiusFocusNode.dispose();
    _fontSizeController.dispose();
    _fontSizeFocusNode.dispose();
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
            text: 'Progress style',
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
          TextFieldWithLabelMolecule(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            name: 'Height',
            backgroundColor: AppColors.defaultButtonBackground,
            currentValue: widget.config.height.toString(),
            controller: _heightController,
            focusNode: _heightFocusNode,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) {
              final doubleValue = double.tryParse(value);
              if (doubleValue != null) {
                widget.onHeightChanged?.call(doubleValue);
              }
            },
            defaultSize: 76,
          ),
          TextFieldWithLabelMolecule(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            currentValue: widget.config.cornerRadius.toString(),
            name: 'Corner radius',
            backgroundColor: AppColors.defaultButtonBackground,
            controller: _radiusController,
            focusNode: _radiusFocusNode,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) {
              final doubleValue = double.tryParse(value);
              if (doubleValue != null) {
                widget.onRadiusChanged?.call(doubleValue);
              }
            },
            defaultSize: 76,
          ),
          SwitchMolecule(
            name: 'Show icons',
            initialValue: widget.config.showIcon,
            onChanged: (value) {
              widget.onShowIconsChanged?.call(value);
            },
          ),
          const SizedBox(height: 16),
          ColorPickerMolecule(
            name: 'Text color',
            initialColor: widget.config.textColor,
            onColorChanged: (color) {
              widget.onTextColorChanged?.call(color);
            },
          ),
          const SizedBox(height: 16),
          ColorPickerMolecule(
            name: 'Background color',
            initialColor: widget.config.backgroundColor,
            onColorChanged: (color) {
              widget.onBackgroundColorChanged?.call(color);
            },
          ),
          const SizedBox(height: 16),
          DropDownAtom(
            items: items,
            initialValue: initialValue,
            onChanged: (value) {
              widget.onProgressTypeChanged?.call(value);
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropDownAtom(
                  items: ['Thin', 'Normal', 'Bold'],
                  initialValue: getFontWeightInitial(widget.config.fontWeight),
                  onChanged: (value) {
                    FontWeight selectedFontWeight = FontWeight.w400;
                    switch (value) {
                      case 'Thin':
                        selectedFontWeight = FontWeight.w200;
                        break;
                      case 'Bold':
                        selectedFontWeight = FontWeight.w700;
                        break;
                      case 'Normal':
                        selectedFontWeight = FontWeight.w400;
                        break;
                    }
                    widget.onFontWeightChanged?.call(selectedFontWeight);
                  },
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 100,
                child: TextFieldAtom(
                  controller: _fontSizeController,
                  focusNode: _fontSizeFocusNode,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    final doubleValue = double.tryParse(value);
                    if (doubleValue != null) {
                      widget.onTextFontSizeChanged?.call(doubleValue);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FontFamilySelectorMolecule(
            selectedFontFamily: widget.config.fontFamily,
            onChanged: (value) => widget.onFontFamilyChanged?.call(value),
          ),
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
