import 'package:flox/feature/builder/configs/text_config/text_config.dart';
import 'package:flox/ui_components/components/atoms/drop_down_atom.dart';
import 'package:flox/ui_components/components/atoms/text_atom.dart';
import 'package:flox/ui_components/components/atoms/text_field_atom.dart';
import 'package:flox/ui_components/components/molecules/color_picker_molecule.dart';
import 'package:flox/ui_components/components/molecules/font_family_selector_molecule.dart';
import 'package:flutter/material.dart';

import '../../../../ui_components/components/icon_selector_component.dart';

class TextPropertiesSection extends StatefulWidget {
  final Function(String font) onFontChanged;
  final Function(double fontSize) onFontSizeChanged;
  final Function(FontWeight fontWeight) onFontWeightChanged;
  final Function(Color color) onColorChanged;
  final Function(TextAlign textAlign) onTextAlignChanged;
  final Function(String emoji) onEmojiSelected;
  final Function(String text) onTextChanged;
  final TextConfig textConfig;

  const TextPropertiesSection({
    super.key,
    required this.onFontChanged,
    required this.onFontSizeChanged,
    required this.onFontWeightChanged,
    required this.onColorChanged,
    required this.onEmojiSelected,
    required this.onTextChanged,
    required this.onTextAlignChanged,
    required this.textConfig,
  });

  @override
  State<TextPropertiesSection> createState() => _TextPropertiesSectionState();
}

class _TextPropertiesSectionState extends State<TextPropertiesSection> with AutomaticKeepAliveClientMixin {
  final List<String> alignmentValues = ['left', 'center', 'right'];
  late TextEditingController _fontSizeController;
  late FocusNode _fontSizeFocusNode;
  late FocusNode _textContentFocusNode;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _fontSizeController = TextEditingController(text: widget.textConfig.size.toString());
    _fontSizeFocusNode = FocusNode();
    _textContentFocusNode = FocusNode();
    _fontSizeController.addListener(_handleFontSizeChange);
  }

  @override
  void didUpdateWidget(TextPropertiesSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.textConfig.size != widget.textConfig.size && !_fontSizeFocusNode.hasFocus) {
      _fontSizeController.text = widget.textConfig.size.toString();
    }
  }

  @override
  void dispose() {
    _fontSizeController.dispose();
    _fontSizeFocusNode.dispose();
    _textContentFocusNode.dispose();
    super.dispose();
  }

  void _handleFontSizeChange() {
    if (_fontSizeFocusNode.hasFocus) {
      final value = double.tryParse(_fontSizeController.text) ?? widget.textConfig.size;
      widget.onFontSizeChanged(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextAtom(
            text: 'Text',
            fontSize: 24,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropDownAtom(
                  items: ['Thin', 'Normal', 'Bold'],
                  initialValue: getFontWeightInitial(widget.textConfig.weight),
                  onChanged: (value) {
                    FontWeight selectedFontWeight;
                    switch (value) {
                      case 'Thin':
                        selectedFontWeight = FontWeight.w200;
                        break;
                      case 'Bold':
                        selectedFontWeight = FontWeight.w700;
                        break;
                      default:
                        selectedFontWeight = FontWeight.w400;
                    }
                    widget.onFontWeightChanged(selectedFontWeight);
                  },
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 100,
                child: TextFieldAtom(
                  focusNode: _fontSizeFocusNode,
                  keyboardType: TextInputType.number,
                  controller: _fontSizeController,
                  onChanged: (value) {
                    final size = double.tryParse(value) ?? widget.textConfig.size;
                    widget.onFontSizeChanged(size);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropDownAtom(
                  items: alignmentValues,
                  initialValue: widget.textConfig.alignment.name.toLowerCase(),
                  onChanged: (value) {
                    final textAlign = TextAlign.values.firstWhere(
                      (e) => e.name == value,
                      orElse: () => TextAlign.left,
                    );
                    widget.onTextAlignChanged(textAlign);
                  },
                ),
              ),
              const SizedBox(width: 16),
              ColorPickerMolecule(
                initialColor: widget.textConfig.color,
                onColorChanged: widget.onColorChanged,
              ),
            ],
          ),
          const SizedBox(height: 16),
          FontFamilySelectorMolecule(
            selectedFontFamily: widget.textConfig.fontFamily,
            onChanged: widget.onFontChanged,
          ),
          const SizedBox(height: 16),
          ChangeTextValueComponent(
            onIconSelected: widget.onEmojiSelected,
            onTextChanged: widget.onTextChanged,
            config: widget.textConfig,
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
