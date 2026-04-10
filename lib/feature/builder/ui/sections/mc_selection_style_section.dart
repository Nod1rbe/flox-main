import 'package:flox/feature/builder/configs/multiple_choice_config/mc_selected_style_config.dart';
import 'package:flox/ui_components/components/atoms/drop_down_atom.dart';
import 'package:flox/ui_components/components/atoms/text_atom.dart';
import 'package:flox/ui_components/components/atoms/text_field_atom.dart';
import 'package:flox/ui_components/components/molecules/color_picker_molecule.dart';
import 'package:flox/ui_components/components/molecules/font_family_selector_molecule.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class McSelectionStyleSection extends StatefulWidget {
  final Function(Color) onTextColorChanged;
  final Function(Color) onBackgroundColorChanged;
  final Function(FontWeight) onFontWeightChanged;
  final Function(double) onFontSizeChanged;
  final Function(String) onFontFamilyChanged;
  final McSelectedStyleConfig config;

  const McSelectionStyleSection({
    super.key,
    required this.onTextColorChanged,
    required this.onBackgroundColorChanged,
    required this.onFontWeightChanged,
    required this.onFontSizeChanged,
    required this.onFontFamilyChanged,
    required this.config,
  });

  @override
  State<McSelectionStyleSection> createState() => _McSelectionStyleSectionState();
}

class _McSelectionStyleSectionState extends State<McSelectionStyleSection> {
  final List<String> _fontWeightDisplayValues = ['Thin', 'Normal', 'Bold'];
  final Map<String, FontWeight> _stringToFontWeightMap = {
    'Thin': FontWeight.w200,
    'Normal': FontWeight.w400,
    'Bold': FontWeight.w700,
  };

  late final TextEditingController _fontSizeController;
  late final FocusNode _fontSizeFocusNode;

  @override
  void initState() {
    super.initState();

    _fontSizeController = TextEditingController(text: widget.config.fontSize.toString());
    _fontSizeFocusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant McSelectionStyleSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newSizeText = widget.config.fontSize.toString();
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
    _fontSizeController.dispose();
    _fontSizeFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 24), // Pastdan ham joy tashladim
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TextAtom(
            text: 'Selection Style',
            fontSize: 24,
            fontWeight: FontWeight.w500,
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
          FontFamilySelectorMolecule(
            selectedFontFamily: widget.config.fontFamily,
            onChanged: widget.onFontFamilyChanged,
          ),
        ],
      ),
    );
  }
}
