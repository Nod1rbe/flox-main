import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/feature/builder/configs/multiple_choice_config/mc_default_style_config.dart';
import 'package:flox/ui_components/components/atoms/drop_down_atom.dart';
import 'package:flox/ui_components/components/atoms/text_atom.dart';
import 'package:flox/ui_components/components/atoms/text_field_atom.dart';
import 'package:flox/ui_components/components/molecules/color_picker_molecule.dart';
import 'package:flox/ui_components/components/molecules/drop_down_molecule.dart';
import 'package:flox/ui_components/components/molecules/font_family_selector_molecule.dart';
import 'package:flox/ui_components/components/molecules/switch_molecule.dart';
import 'package:flox/ui_components/components/molecules/text_field_with_label_molecule.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class McDefaultStyleSection extends StatefulWidget {
  final Function(bool) onMultiSelectionChanged;
  final Function(bool) onShowIconsChanged;
  final Function(double) onCornerRadiusChanged;
  final Function(TextAlign) onAlignmentChanged;
  final Function(Color) onTextColorChanged;
  final Function(Color) onBackgroundColorChanged;
  final Function(FontWeight) onFontWeightChanged;
  final Function(double) onFontSizeChanged;
  final Function(String) onFontFamilyChanged;
  final McDefaultStyleConfig config;

  const McDefaultStyleSection({
    super.key,
    required this.onMultiSelectionChanged,
    required this.onShowIconsChanged,
    required this.onCornerRadiusChanged,
    required this.onAlignmentChanged,
    required this.onTextColorChanged,
    required this.onBackgroundColorChanged,
    required this.onFontWeightChanged,
    required this.onFontSizeChanged,
    required this.onFontFamilyChanged,
    required this.config,
  });

  @override
  State<McDefaultStyleSection> createState() => _McDefaultStyleSectionState();
}

class _McDefaultStyleSectionState extends State<McDefaultStyleSection> {
  final List<String> _alignmentDisplayValues = ['left', 'center', 'right'];
  final Map<String, TextAlign> _stringToAlignmentMap = {
    'left': TextAlign.left,
    'center': TextAlign.center,
    'right': TextAlign.right,
  };
  final Map<TextAlign, String> _alignmentToStringMap = {
    TextAlign.left: 'left',
    TextAlign.center: 'center',
    TextAlign.right: 'right',
  };
  final List<String> _fontWeightDisplayValues = ['Thin', 'Normal', 'Bold'];
  final Map<String, FontWeight> _stringToFontWeightMap = {
    'Thin': FontWeight.w200,
    'Normal': FontWeight.w400,
    'Bold': FontWeight.w700,
  };

  late final TextEditingController _cornerRadiusController;
  late final TextEditingController _fontSizeController;
  late final FocusNode _cornerRadiusFocusNode;
  late final FocusNode _fontSizeFocusNode;

  @override
  void initState() {
    super.initState();
    _cornerRadiusController = TextEditingController(text: widget.config.cornerRadius.toString());
    _fontSizeController = TextEditingController(text: widget.config.fontSize.toString());
    _cornerRadiusFocusNode = FocusNode();
    _fontSizeFocusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant McDefaultStyleSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newRadiusText = widget.config.cornerRadius.toString();
    final newSizeText = widget.config.fontSize.toString();

    if (newRadiusText != _cornerRadiusController.text && !_cornerRadiusFocusNode.hasFocus) {
      _updateControllerValue(_cornerRadiusController, newRadiusText);
    }

    if (newSizeText != _fontSizeController.text && !_fontSizeFocusNode.hasFocus) {
      _updateControllerValue(_fontSizeController, newSizeText);
    }
  }

  void _updateControllerValue(TextEditingController controller, String newText) {
    controller.value = controller.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }

  String _getFontWeightDisplayString(FontWeight weight) {
    if (weight == FontWeight.w200) return 'Thin';
    if (weight == FontWeight.w700) return 'Bold';
    return 'Normal';
  }

  @override
  void dispose() {
    _cornerRadiusController.dispose();
    _fontSizeController.dispose();
    _cornerRadiusFocusNode.dispose();
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
          const TextAtom(
            text: 'Default Style',
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 16),
          SwitchMolecule(
            name: 'Multi selection',
            initialValue: widget.config.multiSelection,
            onChanged: widget.onMultiSelectionChanged,
          ),
          const SizedBox(height: 16),
          SwitchMolecule(
            name: 'Show icons',
            initialValue: widget.config.showIcon,
            onChanged: widget.onShowIconsChanged,
          ),
          const SizedBox(height: 16),
          TextFieldWithLabelMolecule(
            name: 'Corner radius',
            backgroundColor: AppColors.defaultButtonBackground,
            controller: _cornerRadiusController,
            focusNode: _cornerRadiusFocusNode,
            currentValue: _cornerRadiusController.text,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) {
              final newRadius = double.tryParse(value);
              if (newRadius != null) {
                widget.onCornerRadiusChanged(newRadius);
              }
            },
            defaultSize: 76,
          ),
          DropDownMolecule(
            name: 'Alignment',
            items: _alignmentDisplayValues,
            initialValue: _alignmentToStringMap[widget.config.alignment] ?? 'left',
            onChanged: (value) {
              if (_stringToAlignmentMap.containsKey(value)) {
                widget.onAlignmentChanged(_stringToAlignmentMap[value]!);
              }
            },
          ),
          const SizedBox(height: 16),
          ColorPickerMolecule(
            initialColor: widget.config.textColor,
            name: 'Text color',
            onColorChanged: widget.onTextColorChanged,
          ),
          const SizedBox(height: 16),
          ColorPickerMolecule(
            name: 'Background color',
            initialColor: widget.config.backgroundColor,
            onColorChanged: widget.onBackgroundColorChanged,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropDownAtom(
                  items: _fontWeightDisplayValues,
                  initialValue: _getFontWeightDisplayString(widget.config.fontWeight),
                  onChanged: (value) {
                    if (_stringToFontWeightMap.containsKey(value)) {
                      widget.onFontWeightChanged(_stringToFontWeightMap[value]!);
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 100,
                child: TextFieldAtom(
                  controller: _fontSizeController,
                  focusNode: _fontSizeFocusNode,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    final newSize = double.tryParse(value);
                    if (newSize != null) {
                      widget.onFontSizeChanged(newSize);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FontFamilySelectorMolecule(
            selectedFontFamily: widget.config.fontFamily,
            onChanged: widget.onFontFamilyChanged,
          ),
        ],
      ),
    );
  }
}
