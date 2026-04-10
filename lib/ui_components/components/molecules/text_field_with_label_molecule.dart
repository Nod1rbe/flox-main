import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/ui_components/components/atoms/text_atom.dart';
import 'package:flox/ui_components/components/atoms/text_field_atom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWithLabelMolecule extends StatefulWidget {
  final String name;
  final String currentValue;
  final TextInputType textInputType;
  final EdgeInsets padding;
  final List<TextInputFormatter>? inputFormatters;
  final double? fontSize;
  final ValueChanged<String> onChanged;
  final double? defaultSize;
  final Color backgroundColor;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const TextFieldWithLabelMolecule({
    super.key,
    required this.name,
    required this.onChanged,
    required this.currentValue,
    this.backgroundColor = AppColors.layoutBackground,
    this.inputFormatters,
    this.fontSize,
    this.defaultSize = 75,
    this.textInputType = TextInputType.text,
    this.controller,
    this.focusNode,
    this.padding = const EdgeInsets.only(bottom: 16),
  });

  @override
  State<TextFieldWithLabelMolecule> createState() => _TextFieldWithLabelMoleculeState();
}

class _TextFieldWithLabelMoleculeState extends State<TextFieldWithLabelMolecule> {
  late TextEditingController _internalController;

  TextEditingController get _effectiveController => widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = TextEditingController(text: widget.currentValue);
    } else {
      widget.controller!.text = widget.currentValue;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextAtom(text: widget.name, fontSize: widget.fontSize ?? 16),
          SizedBox(
            width: widget.defaultSize,
            child: TextFieldAtom(
              width: widget.defaultSize,
              fillColor: widget.backgroundColor,
              controller: _effectiveController,
              focusNode: widget.focusNode,
              keyboardType: widget.textInputType,
              inputFormatters: widget.inputFormatters,
              onChanged: widget.onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
