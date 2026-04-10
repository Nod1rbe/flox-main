import 'package:flox/core/constants/app_colors.dart';
import 'package:flox/feature/builder/configs/text_config/text_config.dart';
import 'package:flox/ui_components/components/atoms/icon_selector_atom.dart';
import 'package:flox/ui_components/components/atoms/text_atom.dart';
import 'package:flox/ui_components/components/atoms/text_field_atom.dart';
import 'package:flutter/material.dart';

class ChangeTextValueComponent extends StatefulWidget {
  final void Function(String emoji)? onIconSelected;
  final void Function(String text)? onTextChanged;
  final TextConfig config;

  const ChangeTextValueComponent({
    super.key,
    this.onIconSelected,
    this.onTextChanged,
    required this.config,
  });

  @override
  State<ChangeTextValueComponent> createState() => _ChangeTextValueComponentState();
}

class _ChangeTextValueComponentState extends State<ChangeTextValueComponent> {
  late final TextEditingController _textController;
  late final FocusNode _textFocusNode;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.config.text);
    _textFocusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant ChangeTextValueComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Tashqaridan kelgan 'config.text' o'zgarsa va
    // TextField hozir fokusda bo'lmasa, controllerni yangilaymiz.
    // Bu foydalanuvchi yozayotganda cursorning sakrab ketishining oldini oladi.
    if (widget.config.text != _textController.text && !_textFocusNode.hasFocus) {
      _textController.value = _textController.value.copyWith(
        text: widget.config.text,
        selection: TextSelection.collapsed(offset: widget.config.text.length),
      );
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF444444),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          TextFieldAtom(
            fillColor: AppColors.layoutBackground,
            controller: _textController,
            focusNode: _textFocusNode,
            onChanged: widget.onTextChanged,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const TextAtom(
                text: 'Leading icon',
                fontSize: 16,
                padding: EdgeInsets.all(12),
              ),
              IconSelectorAtom(
                onEmojiSelected: (emoji) {
                  widget.onIconSelected?.call(emoji);
                },
                currentEmoji: widget.config.leadingIcon,
              ),
            ],
          )
        ],
      ),
    );
  }
}
